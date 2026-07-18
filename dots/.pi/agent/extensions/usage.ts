import { homedir } from "node:os";
import { relative, resolve, sep } from "node:path";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth, type AutocompleteItem } from "@earendil-works/pi-tui";

const PROVIDER = "openai-codex";
const USAGE_URL = "https://chatgpt.com/backend-api/wham/usage";
const CACHE_MS = 60_000;
const REFRESH_MS = 5 * 60_000;

type JsonObject = Record<string, unknown>;

type UsageWindow = {
	label: string;
	usedPercent: number;
	resetAt?: number;
};

type UsageData = {
	plan?: string;
	windows: UsageWindow[];
	codeReviewWindows: UsageWindow[];
	credits?: string;
};

function object(value: unknown): JsonObject | undefined {
	return value !== null && typeof value === "object" && !Array.isArray(value) ? (value as JsonObject) : undefined;
}

function number(value: unknown): number | undefined {
	return typeof value === "number" && Number.isFinite(value) ? value : undefined;
}

function string(value: unknown): string | undefined {
	return typeof value === "string" && value.length > 0 ? value : undefined;
}

function field(record: JsonObject | undefined, snake: string, camel: string): unknown {
	return record?.[snake] ?? record?.[camel];
}

function formatDuration(seconds: number): string {
	if (seconds >= 86400 && seconds % 86400 === 0) return `${seconds / 86400}d`;
	if (seconds >= 3600 && seconds % 3600 === 0) return `${seconds / 3600}h`;
	if (seconds >= 60 && seconds % 60 === 0) return `${seconds / 60}m`;
	return `${seconds}s`;
}

function parseWindow(value: unknown, fallbackLabel: string): UsageWindow | undefined {
	const window = object(value);
	if (!window) return undefined;

	const usedPercent = number(field(window, "used_percent", "usedPercent"));
	if (usedPercent === undefined) return undefined;

	const windowSeconds = number(field(window, "limit_window_seconds", "limitWindowSeconds"));
	const resetAt = number(field(window, "reset_at", "resetAt"));
	const resetAfter = number(field(window, "reset_after_seconds", "resetAfterSeconds"));

	return {
		label: windowSeconds ? formatDuration(windowSeconds) : fallbackLabel,
		usedPercent: Math.max(0, Math.min(100, usedPercent)),
		resetAt: resetAt ?? (resetAfter !== undefined ? Date.now() / 1000 + resetAfter : undefined),
	};
}

function parseRateLimit(value: unknown): UsageWindow[] {
	const rateLimit = object(value);
	if (!rateLimit) return [];

	return [
		parseWindow(field(rateLimit, "primary_window", "primaryWindow"), "primary"),
		parseWindow(field(rateLimit, "secondary_window", "secondaryWindow"), "secondary"),
	].filter((window): window is UsageWindow => window !== undefined);
}

function parseUsage(value: unknown): UsageData {
	const payload = object(value);
	if (!payload) throw new Error("OpenAI returned an invalid usage response");

	const credits = object(payload.credits);
	const balance = field(credits, "balance", "balance");
	const unlimited = credits?.unlimited === true;
	const windows = parseRateLimit(field(payload, "rate_limit", "rateLimit"));
	const codeReviewWindows = parseRateLimit(field(payload, "code_review_rate_limit", "codeReviewRateLimit"));

	if (windows.length === 0 && codeReviewWindows.length === 0) {
		throw new Error("OpenAI usage response did not contain rate-limit windows");
	}

	return {
		plan: string(field(payload, "plan_type", "planType")),
		windows,
		codeReviewWindows,
		credits: unlimited ? "unlimited" : typeof balance === "number" || typeof balance === "string" ? String(balance) : undefined,
	};
}

function extractAccountId(token: string): string {
	try {
		const payloadPart = token.split(".")[1];
		if (!payloadPart) throw new Error("Invalid token");
		const base64 = payloadPart.replace(/-/g, "+").replace(/_/g, "/").padEnd(Math.ceil(payloadPart.length / 4) * 4, "=");
		const payload = object(JSON.parse(atob(base64)));
		const auth = object(payload?.["https://api.openai.com/auth"]);
		const accountId = string(auth?.chatgpt_account_id);
		if (!accountId) throw new Error("Missing account ID");
		return accountId;
	} catch {
		throw new Error("Could not read the ChatGPT account ID from the OpenAI OAuth token");
	}
}

function formatReset(resetAt?: number): string | undefined {
	if (!resetAt) return undefined;
	const remainingSeconds = Math.max(0, Math.round(resetAt - Date.now() / 1000));
	const days = Math.floor(remainingSeconds / 86400);
	const hours = Math.floor((remainingSeconds % 86400) / 3600);
	const minutes = Math.floor((remainingSeconds % 3600) / 60);
	if (days > 0) return `${days}d ${hours}h`;
	if (hours > 0) return `${hours}h ${minutes}m`;
	return `${minutes}m`;
}

function formatWindow(window: UsageWindow): string {
	const used = Math.round(window.usedPercent);
	const reset = formatReset(window.resetAt);
	return `${window.label}: ${used}% used · ${100 - used}% left${reset ? ` · resets in ${reset}` : ""}`;
}

function formatDetails(data: UsageData): string {
	const lines = [`Codex usage${data.plan ? ` (${data.plan})` : ""}`];
	lines.push(...data.windows.map(formatWindow));
	lines.push(...data.codeReviewWindows.map((window) => `Code review ${formatWindow(window)}`));
	if (data.credits !== undefined) lines.push(`Credits: ${data.credits}`);
	return lines.join("\n");
}

function statusText(data: UsageData): string {
	const windows = data.windows.length > 0 ? data.windows : data.codeReviewWindows;
	const summaries = windows.map((window) => {
		const reset = formatReset(window.resetAt)?.replace(/ /g, "");
		return `${window.label}:${100 - Math.round(window.usedPercent)}% left${reset ? ` ↻${reset}` : ""}`;
	});
	return `Codex ${summaries.join(" · ")}`;
}

function compactCwd(cwd: string): string {
	const home = resolve(homedir());
	const absolute = resolve(cwd);
	const fromHome = relative(home, absolute);
	if (fromHome === "") return "~";
	if (fromHome === ".." || fromHome.startsWith(`..${sep}`)) return cwd;
	return `~${sep}${fromHome}`;
}

function sanitizeStatus(text: string): string {
	return text.replace(/[\r\n\t]/g, " ").replace(/ +/g, " ").trim();
}

export default function usageExtension(pi: ExtensionAPI) {
	let statusEnabled = true;
	let cached: UsageData | undefined;
	let cachedAt = 0;
	let inFlight: Promise<UsageData> | undefined;
	let refreshTimer: ReturnType<typeof setInterval> | undefined;
	let activeContext: ExtensionContext | undefined;
	let activeProvider: string | undefined;
	let requestFooterRender: (() => void) | undefined;

	function findOAuthModel(ctx: ExtensionContext) {
		const model = ctx.modelRegistry.getAll().find((candidate) => candidate.provider === PROVIDER);
		if (!model) throw new Error("OpenAI Codex provider is not available");
		if (!ctx.modelRegistry.isUsingOAuth(model)) {
			throw new Error("OpenAI Codex OAuth is not configured. Run /login openai-codex first");
		}
		return model;
	}

	async function fetchUsage(ctx: ExtensionContext, force = false): Promise<UsageData> {
		if (!force && cached && Date.now() - cachedAt < CACHE_MS) return cached;
		if (inFlight) return inFlight;

		inFlight = (async () => {
			const model = findOAuthModel(ctx);
			const auth = await ctx.modelRegistry.getApiKeyAndHeaders(model);
			if (!auth.ok) throw new Error(auth.error);
			if (!auth.apiKey) throw new Error("OpenAI OAuth access token is unavailable");

			const response = await fetch(USAGE_URL, {
				signal: AbortSignal.timeout(10_000),
				headers: {
					accept: "application/json",
					authorization: `Bearer ${auth.apiKey}`,
					"chatgpt-account-id": extractAccountId(auth.apiKey),
					originator: "pi",
				},
			});

			if (!response.ok) {
				const body = await response.text();
				const message = body.slice(0, 300).replace(/\s+/g, " ").trim();
				throw new Error(`OpenAI usage request failed (${response.status})${message ? `: ${message}` : ""}`);
			}

			cached = parseUsage(await response.json());
			cachedAt = Date.now();
			return cached;
		})();

		try {
			return await inFlight;
		} finally {
			inFlight = undefined;
		}
	}

	function updateFooter(ctx: ExtensionContext, provider = activeProvider): void {
		activeContext = ctx;
		activeProvider = provider;

		if (!statusEnabled || provider !== PROVIDER) {
			requestFooterRender = undefined;
			ctx.ui.setFooter(undefined);
			return;
		}

		ctx.ui.setFooter((tui, theme, footerData) => {
			const renderNow = () => tui.requestRender();
			requestFooterRender = renderNow;
			const unsubscribeBranch = footerData.onBranchChange(renderNow);

			return {
				dispose() {
					unsubscribeBranch();
					if (requestFooterRender === renderNow) requestFooterRender = undefined;
				},
				invalidate() {},
				render(width: number): string[] {
					let location = compactCwd(ctx.cwd);
					const branch = footerData.getGitBranch();
					if (branch) location += ` (${branch})`;
					const sessionName = ctx.sessionManager.getSessionName();
					if (sessionName) location += ` • ${sessionName}`;

					const allWindows = cached ? [...cached.windows, ...cached.codeReviewWindows] : [];
					const highestUsage = allWindows.length > 0 ? Math.max(...allWindows.map((window) => window.usedPercent)) : 0;
					const color = highestUsage >= 95 ? "error" : highestUsage >= 80 ? "warning" : "dim";
					const leftText = cached ? statusText(cached) : "Codex usage: loading…";
					let left = theme.fg(color, leftText);
					const thinking = pi.getThinkingLevel();
					const modelId = ctx.model?.id ?? "openai-codex";
					const rightText = ctx.model?.reasoning
						? thinking === "off" ? `${modelId} • thinking off` : `${modelId} • ${thinking}`
						: modelId;
					const right = theme.fg("dim", rightText);

					const availableLeft = Math.max(0, width - visibleWidth(right) - 2);
					left = truncateToWidth(left, availableLeft, "…");
					const padding = " ".repeat(Math.max(1, width - visibleWidth(left) - visibleWidth(right)));
					const lines = [
						truncateToWidth(theme.fg("dim", location), width, theme.fg("dim", "…")),
						truncateToWidth(left + padding + right, width, ""),
					];

					const statuses = Array.from(footerData.getExtensionStatuses().entries())
						.map(([, text]) => sanitizeStatus(text))
						.filter(Boolean);
					if (statuses.length > 0) lines.push(truncateToWidth(statuses.join(" "), width, theme.fg("dim", "…")));
					return lines;
				},
			};
		});
	}

	function renderStatus(ctx: ExtensionContext, _data: UsageData): void {
		if (!statusEnabled || activeProvider !== PROVIDER) return;
		requestFooterRender?.();
	}

	async function refreshStatus(ctx: ExtensionContext, force = false): Promise<void> {
		if (!statusEnabled || activeProvider !== PROVIDER) return;
		try {
			renderStatus(ctx, await fetchUsage(ctx, force));
		} catch {
			// Keep stale status on transient failures; /usage reports errors explicitly.
		}
	}

	pi.registerCommand("usage", {
		description: "Show OpenAI Codex OAuth usage limits",
		getArgumentCompletions: (prefix: string): AutocompleteItem[] | null => {
			const options = ["refresh", "on", "off"];
			const items = options
				.filter((option) => option.startsWith(prefix.trim().toLowerCase()))
				.map((option) => ({ value: option, label: option }));
			return items.length > 0 ? items : null;
		},
		handler: async (args, ctx) => {
			const action = args.trim().toLowerCase();
			if (action === "off") {
				statusEnabled = false;
				updateFooter(ctx);
				ctx.ui.notify("Codex usage footer disabled", "info");
				return;
			}
			if (action === "on") {
				statusEnabled = true;
				updateFooter(ctx, ctx.model?.provider);
			} else if (action && action !== "refresh") {
				ctx.ui.notify("Usage: /usage [refresh|on|off]", "error");
				return;
			}

			try {
				const data = await fetchUsage(ctx, true);
				renderStatus(ctx, data);
				const details = formatDetails(data);
				if (ctx.hasUI) ctx.ui.notify(details, "info");
				else console.log(details);
			} catch (error) {
				const message = error instanceof Error ? error.message : String(error);
				if (ctx.hasUI) ctx.ui.notify(message, "error");
				else console.error(message);
			}
		},
	});

	pi.on("session_start", (_event, ctx) => {
		updateFooter(ctx, ctx.model?.provider);
		void refreshStatus(ctx);
		if (refreshTimer) clearInterval(refreshTimer);
		refreshTimer = setInterval(() => {
			if (activeContext) void refreshStatus(activeContext, true);
		}, REFRESH_MS);
		refreshTimer.unref?.();
	});

	pi.on("model_select", (event, ctx) => {
		updateFooter(ctx, event.model.provider);
		if (event.model.provider === PROVIDER) void refreshStatus(ctx);
	});

	pi.on("thinking_level_select", (_event, ctx) => {
		if (activeProvider === PROVIDER) requestFooterRender?.();
	});

	pi.on("agent_end", (_event, ctx) => {
		void refreshStatus(ctx);
	});

	pi.on("session_shutdown", (_event, ctx) => {
		if (refreshTimer) clearInterval(refreshTimer);
		refreshTimer = undefined;
		activeContext = undefined;
		requestFooterRender = undefined;
		ctx.ui.setFooter(undefined);
	});
}

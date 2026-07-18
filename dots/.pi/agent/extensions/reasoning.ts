import { getSupportedThinkingLevels, type ModelThinkingLevel } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import type { AutocompleteItem } from "@earendil-works/pi-tui";

const LEVELS: readonly ModelThinkingLevel[] = [
	"off",
	"minimal",
	"low",
	"medium",
	"high",
	"xhigh",
	"max",
];

function isThinkingLevel(value: string): value is ModelThinkingLevel {
	return LEVELS.includes(value as ModelThinkingLevel);
}

export default function reasoningExtension(pi: ExtensionAPI) {
	pi.registerCommand("reasoning", {
		description: "Set the current model's reasoning level",
		getArgumentCompletions: (prefix: string): AutocompleteItem[] | null => {
			const normalizedPrefix = prefix.trim().toLowerCase();
			const items = LEVELS.filter((level) => level.startsWith(normalizedPrefix)).map((level) => ({
				value: level,
				label: level,
			}));
			return items.length > 0 ? items : null;
		},
		handler: async (args, ctx) => {
			if (!ctx.model) {
				ctx.ui.notify("No model is currently selected", "error");
				return;
			}

			const supportedLevels = getSupportedThinkingLevels(ctx.model);
			const requested = args.trim().toLowerCase();
			let level: ModelThinkingLevel | undefined;

			if (requested) {
				if (!isThinkingLevel(requested)) {
					ctx.ui.notify(`Unknown reasoning level "${requested}". Valid levels: ${LEVELS.join(", ")}`, "error");
					return;
				}
				if (!supportedLevels.includes(requested)) {
					ctx.ui.notify(
						`Reasoning level "${requested}" is not supported by ${ctx.model.provider}/${ctx.model.id}. Supported: ${supportedLevels.join(", ")}`,
						"error",
					);
					return;
				}
				level = requested;
			} else if (ctx.hasUI) {
				level = (await ctx.ui.select(
					`Reasoning level (current: ${pi.getThinkingLevel()})`,
					supportedLevels,
				)) as ModelThinkingLevel | undefined;
			} else {
				console.log(`Current reasoning level: ${pi.getThinkingLevel()}. Supported: ${supportedLevels.join(", ")}`);
				return;
			}

			if (!level) return;

			pi.setThinkingLevel(level);
			ctx.ui.notify(`Reasoning level: ${pi.getThinkingLevel()}`, "info");
		},
	});
}

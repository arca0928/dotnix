export function apply(ctx) {
  ctx.inject(['authorization', 'credentials', 'appReady', 'appExit'], child => {
    child.effect(() => child.appReady.onReady(() => {
      void (async () => {
        try {
          const action = process.env.DSH_CHATGPT_ACTION;
          const key = 'llm-pi-ai/openai-codex';
          if (action === 'status') {
            const info = await child.credentials.describeRecord(key);
            console.error(`ChatGPT: ${info.configured ? 'configured' : 'not configured'}`);
            child.appExit(info.configured ? 0 : 1);
            return;
          }
          if (action === 'logout') {
            await child.credentials.deleteRecord(key);
            console.error('ChatGPT: local DSH credential removed');
            child.appExit(0);
            return;
          }
          if (action !== 'login') throw new Error('Unsupported action');
          const flow = child.authorization.list().find(entry => entry.key === key);
          if (!flow) throw new Error('ChatGPT authorization flow unavailable');
          const outcome = await child.authorization.begin({
            key: flow.key,
            method: 'oauth',
            interaction: {
              notify(notice) {
                console.error(notice.message);
                if (notice.url) console.error(notice.url);
                if (notice.code) console.error(`Device code: ${notice.code}`);
              },
              async prompt(prompt) {
                const device = prompt.kind === 'select'
                  && prompt.options.find(option => option.id === 'device_code');
                if (device) return device.id;
                throw new Error('Device-code login required');
              },
            },
          });
          console.error(`ChatGPT authorization: ${outcome.status}`);
          child.appExit(outcome.status === 'authorized' ? 0 : 1);
        } catch {
          // Provider errors can contain credentials; do not print their payloads.
          console.error('ChatGPT operation failed; check connectivity and retry.');
          child.appExit(1);
        }
      })();
    }));
  });
}

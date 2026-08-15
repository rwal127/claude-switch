# claude-switch

Claude Code profile switcher for Anthropic API providers Z.ai Alibaba DeepSeek and MiniMax

It switches Claude Code between named provider profiles by editing your local Claude config at `~/.claude/settings.json`. The repo contains only reusable code and placeholder examples. Real tokens live only in your local profile files outside the repo.

## What it does

- Applies a named profile to Claude settings
- Saves the current Claude override config into a named profile
- Switches back to direct mode by removing Anthropic override variables
- Supports generic named profiles plus shortcuts for `proxy`, `alibaba`, `deepseek`, and `minimax`
- Works on macOS and Linux with `bash` and `jq`

## Install

```bash
./install.sh
```

That creates a symlink at `~/.local/bin/claude-switch` by default and creates a local profiles directory at `${XDG_CONFIG_HOME:-$HOME/.config}/claude-switch/profiles`.

If you already use the legacy `~/.claude-switch` directory, the script will keep using it automatically unless you override the path.
Legacy flat files like `~/.claude-switch/proxy-profile.json` are still read and will be migrated into `~/.claude-switch/profiles/*.json` on first use.

Run `claude-switch paths` to see the exact locations on a given machine.

## Profile setup

Example templates are copied to your local profiles directory on install:

- `proxy.json.example`
- `alibaba.json.example`
- `deepseek.json.example`
- `minimax.json.example`

Create real profiles locally:

```bash
cp ~/.config/claude-switch/profiles/proxy.json.example ~/.config/claude-switch/profiles/proxy.json
```

Then edit the copied `.json` file and put in your own values.

For the built-in `alibaba` preset, the default base URL is `https://token-plan.ap-southeast-1.maas.aliyuncs.com/apps/anthropic` and the Claude-facing model selectors default to `qwen3.8-max` (Opus/Sonnet/model) and `qwen3.6-flash` (Haiku), matching Alibaba's current Claude Code setup guide. The preset also sets `CLAUDE_CODE_SUBAGENT_MODEL` to `qwen3.7-max` and `CLAUDE_CODE_MAX_CONTEXT_TOKENS` to `983616` by default.

For the built-in `deepseek` preset, the default Claude-facing model alias is `deepseek-v4-pro[1m]` so Claude Code requests the 1M-context variant described in DeepSeek's Claude Code integration docs.

For GLM 5.3 on the Z.ai proxy, set the Claude-facing model aliases to plain `glm-5.3` — no `[1m]` suffix is needed anymore since GLM-5.3 is natively 1M-context. Use `glm-5-turbo` for the Haiku and small-fast model slots, and `API_TIMEOUT_MS=3000000` as Z.ai recommends. Old `glm-5.2[1m]` IDs still work (they are auto-routed as 5.3), but updating keeps logs and quota reads accurate.

For the built-in `minimax` preset, the default base URL is `https://api.minimax.io/anthropic` and all Claude-facing model selectors are set to `MiniMax-M3`, matching MiniMax's current Claude Code setup guide.

Profile JSON format:

```json
{
  "ANTHROPIC_BASE_URL": "https://provider.example/anthropic",
  "ANTHROPIC_AUTH_TOKEN": "replace-me",
  "ANTHROPIC_MODEL": "provider-model-name",
  "ANTHROPIC_DEFAULT_OPUS_MODEL": "provider-opus-model",
  "ANTHROPIC_DEFAULT_SONNET_MODEL": "provider-sonnet-model",
  "ANTHROPIC_DEFAULT_HAIKU_MODEL": "provider-haiku-model",
  "CLAUDE_CODE_SUBAGENT_MODEL": "provider-subagent-model",
  "CLAUDE_CODE_MAX_CONTEXT_TOKENS": "provider-max-context-tokens",
  "ANTHROPIC_SMALL_FAST_MODEL": "provider-small-fast-model",
  "API_TIMEOUT_MS": "provider-api-timeout-ms"
}
```

Only `ANTHROPIC_BASE_URL` and `ANTHROPIC_AUTH_TOKEN` are required. Empty fields are ignored.

## Commands

```bash
claude-switch use proxy
claude-switch use my-work-proxy
claude-switch proxy
claude-switch alibaba
claude-switch deepseek
claude-switch minimax
claude-switch direct
claude-switch save my-current-config
claude-switch list
claude-switch status
claude-switch paths
```

## Env-based shortcuts

If a local profile file does not exist yet, these shortcuts can resolve values from env vars and then persist a local profile for future use:

- `proxy`
  - `CLAUDE_SWITCH_PROXY_BASE_URL`
  - `CLAUDE_SWITCH_PROXY_AUTH_TOKEN`
  - `CLAUDE_SWITCH_PROXY_MODEL`
  - `CLAUDE_SWITCH_PROXY_OPUS_MODEL`
  - `CLAUDE_SWITCH_PROXY_SONNET_MODEL`
  - `CLAUDE_SWITCH_PROXY_HAIKU_MODEL`
  - `CLAUDE_SWITCH_PROXY_SUBAGENT_MODEL`
  - `CLAUDE_SWITCH_PROXY_MAX_CONTEXT_TOKENS`
  - `CLAUDE_SWITCH_PROXY_SMALL_FAST_MODEL`
  - `CLAUDE_SWITCH_PROXY_API_TIMEOUT_MS`
- `alibaba`
  - `CLAUDE_SWITCH_ALIBABA_BASE_URL`
  - `CLAUDE_SWITCH_ALIBABA_AUTH_TOKEN`
  - `CLAUDE_SWITCH_ALIBABA_MODEL`
  - `CLAUDE_SWITCH_ALIBABA_OPUS_MODEL`
  - `CLAUDE_SWITCH_ALIBABA_SONNET_MODEL`
  - `CLAUDE_SWITCH_ALIBABA_HAIKU_MODEL`
  - `CLAUDE_SWITCH_ALIBABA_SUBAGENT_MODEL`
  - `CLAUDE_SWITCH_ALIBABA_MAX_CONTEXT_TOKENS`
  - `CLAUDE_SWITCH_ALIBABA_SMALL_FAST_MODEL`
  - `CLAUDE_SWITCH_ALIBABA_API_TIMEOUT_MS`
  - `ALIBABA_MODEL_STUDIO_API_KEY`
- `deepseek`
  - `CLAUDE_SWITCH_DEEPSEEK_BASE_URL`
  - `CLAUDE_SWITCH_DEEPSEEK_AUTH_TOKEN`
  - `CLAUDE_SWITCH_DEEPSEEK_MODEL`
  - `CLAUDE_SWITCH_DEEPSEEK_OPUS_MODEL`
  - `CLAUDE_SWITCH_DEEPSEEK_SONNET_MODEL`
  - `CLAUDE_SWITCH_DEEPSEEK_HAIKU_MODEL`
  - `CLAUDE_SWITCH_DEEPSEEK_SUBAGENT_MODEL`
  - `CLAUDE_SWITCH_DEEPSEEK_MAX_CONTEXT_TOKENS`
  - `CLAUDE_SWITCH_DEEPSEEK_SMALL_FAST_MODEL`
  - `CLAUDE_SWITCH_DEEPSEEK_API_TIMEOUT_MS`
  - `DEEPSEEK_API_KEY`
- `minimax`
  - `CLAUDE_SWITCH_MINIMAX_BASE_URL`
  - `CLAUDE_SWITCH_MINIMAX_AUTH_TOKEN`
  - `CLAUDE_SWITCH_MINIMAX_MODEL`
  - `CLAUDE_SWITCH_MINIMAX_OPUS_MODEL`
  - `CLAUDE_SWITCH_MINIMAX_SONNET_MODEL`
  - `CLAUDE_SWITCH_MINIMAX_HAIKU_MODEL`
  - `CLAUDE_SWITCH_MINIMAX_SUBAGENT_MODEL`
  - `CLAUDE_SWITCH_MINIMAX_MAX_CONTEXT_TOKENS`
  - `CLAUDE_SWITCH_MINIMAX_SMALL_FAST_MODEL`
  - `CLAUDE_SWITCH_MINIMAX_API_TIMEOUT_MS`
  - `MINIMAX_API_KEY`

## Notes

- Dependencies: `bash`, `jq`
- Default Claude settings file: `~/.claude/settings.json`
- Default Claude onboarding file: `~/.claude.json`
- Z.ai and MiniMax Claude Code guides also recommend `API_TIMEOUT_MS=3000000` (a profile key claude-switch manages); MiniMax additionally recommends `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1`
- Override locations with:
  - `CLAUDE_SWITCH_HOME`
  - `CLAUDE_SWITCH_PROFILES_DIR`
  - `CLAUDE_SWITCH_SETTINGS_FILE`
  - `CLAUDE_SWITCH_CLAUDE_JSON_FILE`

## Smoke test

```bash
./tests/smoke.sh
```

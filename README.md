# claude-switch

Claude Code profile switcher for Anthropic API providers Z.ai Alibaba Deepseek

It switches Claude Code between named provider profiles by editing your local Claude config at `~/.claude/settings.json`. The repo contains only reusable code and placeholder examples. Real tokens live only in your local profile files outside the repo.

## What it does

- Applies a named profile to Claude settings
- Saves the current Claude override config into a named profile
- Switches back to direct mode by removing Anthropic override variables
- Supports generic named profiles plus shortcuts for `proxy`, `alibaba`, and `deepseek`
- Works on macOS and Linux with `bash` and `jq`

## Install

```bash
./install.sh
```

That creates a symlink at `~/.local/bin/claude-switch` by default and creates a local profiles directory at `${XDG_CONFIG_HOME:-$HOME/.config}/claude-switch/profiles`.

If you already use the legacy `~/.claude-switch` directory, the script will keep using it automatically unless you override the path.

Run `claude-switch paths` to see the exact locations on a given machine.

## Profile setup

Example templates are copied to your local profiles directory on install:

- `proxy.json.example`
- `alibaba.json.example`
- `deepseek.json.example`

Create real profiles locally:

```bash
cp ~/.config/claude-switch/profiles/proxy.json.example ~/.config/claude-switch/profiles/proxy.json
```

Then edit the copied `.json` file and put in your own values.

Profile JSON format:

```json
{
  "ANTHROPIC_BASE_URL": "https://provider.example/anthropic",
  "ANTHROPIC_AUTH_TOKEN": "replace-me",
  "ANTHROPIC_MODEL": "provider-model-name",
  "ANTHROPIC_DEFAULT_OPUS_MODEL": "provider-opus-model",
  "ANTHROPIC_DEFAULT_SONNET_MODEL": "provider-sonnet-model",
  "ANTHROPIC_DEFAULT_HAIKU_MODEL": "provider-haiku-model"
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
- `alibaba`
  - `CLAUDE_SWITCH_ALIBABA_BASE_URL`
  - `CLAUDE_SWITCH_ALIBABA_AUTH_TOKEN`
  - `CLAUDE_SWITCH_ALIBABA_MODEL`
  - `ALIBABA_MODEL_STUDIO_API_KEY`
- `deepseek`
  - `CLAUDE_SWITCH_DEEPSEEK_BASE_URL`
  - `CLAUDE_SWITCH_DEEPSEEK_AUTH_TOKEN`
  - `CLAUDE_SWITCH_DEEPSEEK_MODEL`
  - `CLAUDE_SWITCH_DEEPSEEK_OPUS_MODEL`
  - `CLAUDE_SWITCH_DEEPSEEK_SONNET_MODEL`
  - `CLAUDE_SWITCH_DEEPSEEK_HAIKU_MODEL`
  - `DEEPSEEK_API_KEY`

## Notes

- Dependencies: `bash`, `jq`
- Default Claude settings file: `~/.claude/settings.json`
- Default Claude onboarding file: `~/.claude.json`
- Override locations with:
  - `CLAUDE_SWITCH_HOME`
  - `CLAUDE_SWITCH_PROFILES_DIR`
  - `CLAUDE_SWITCH_SETTINGS_FILE`
  - `CLAUDE_SWITCH_CLAUDE_JSON_FILE`

## Smoke test

```bash
./tests/smoke.sh
```

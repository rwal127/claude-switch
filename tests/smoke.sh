#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT_PATH="$REPO_DIR/bin/claude-switch"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}

trap cleanup EXIT

export HOME="$TMP_DIR/home"
export XDG_CONFIG_HOME="$HOME/.config"
export CLAUDE_SWITCH_HOME="$XDG_CONFIG_HOME/claude-switch"
export CLAUDE_SWITCH_PROFILES_DIR="$CLAUDE_SWITCH_HOME/profiles"
export CLAUDE_SWITCH_SETTINGS_FILE="$HOME/.claude/settings.json"
export CLAUDE_SWITCH_CLAUDE_JSON_FILE="$HOME/.claude.json"

mkdir -p "$HOME/.claude" "$CLAUDE_SWITCH_PROFILES_DIR"

printf '{"env":{}}\n' > "$CLAUDE_SWITCH_SETTINGS_FILE"

cat <<'EOF' > "$CLAUDE_SWITCH_PROFILES_DIR/proxy.json"
{
  "ANTHROPIC_BASE_URL": "https://proxy.example/anthropic",
  "ANTHROPIC_AUTH_TOKEN": "proxy-token",
  "ANTHROPIC_MODEL": "proxy-model"
}
EOF

bash "$SCRIPT_PATH" use proxy >/dev/null

jq -e '
  .env.ANTHROPIC_BASE_URL == "https://proxy.example/anthropic" and
  .env.ANTHROPIC_AUTH_TOKEN == "proxy-token" and
  .env.ANTHROPIC_MODEL == "proxy-model"
' "$CLAUDE_SWITCH_SETTINGS_FILE" >/dev/null

bash "$SCRIPT_PATH" save backup >/dev/null

jq -e '
  .ANTHROPIC_BASE_URL == "https://proxy.example/anthropic" and
  .ANTHROPIC_AUTH_TOKEN == "proxy-token"
' "$CLAUDE_SWITCH_PROFILES_DIR/backup.json" >/dev/null

bash "$SCRIPT_PATH" direct >/dev/null

jq -e '
  (.env.ANTHROPIC_BASE_URL // "") == "" and
  (.env.ANTHROPIC_AUTH_TOKEN // "") == "" and
  (.env.ANTHROPIC_MODEL // "") == ""
' "$CLAUDE_SWITCH_SETTINGS_FILE" >/dev/null

export DEEPSEEK_API_KEY="deepseek-token"
bash "$SCRIPT_PATH" deepseek >/dev/null

jq -e '
  .env.ANTHROPIC_BASE_URL == "https://api.deepseek.com/anthropic" and
  .env.ANTHROPIC_AUTH_TOKEN == "deepseek-token" and
  .env.ANTHROPIC_DEFAULT_HAIKU_MODEL == "deepseek-v4-flash"
' "$CLAUDE_SWITCH_SETTINGS_FILE" >/dev/null

[[ -f "$CLAUDE_SWITCH_PROFILES_DIR/deepseek.json" ]]

echo "Smoke test passed."

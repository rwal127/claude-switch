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

rm -f "$CLAUDE_SWITCH_PROFILES_DIR/proxy.json"

cat <<'EOF' > "$CLAUDE_SWITCH_HOME/proxy-profile.json"
{
  "ANTHROPIC_BASE_URL": "https://legacy-proxy.example/anthropic",
  "ANTHROPIC_AUTH_TOKEN": "legacy-proxy-token",
  "ANTHROPIC_DEFAULT_OPUS_MODEL": "legacy-opus",
  "ANTHROPIC_DEFAULT_SONNET_MODEL": "legacy-sonnet",
  "ANTHROPIC_DEFAULT_HAIKU_MODEL": "legacy-haiku"
}
EOF

bash "$SCRIPT_PATH" proxy >/dev/null

jq -e '
  .env.ANTHROPIC_BASE_URL == "https://legacy-proxy.example/anthropic" and
  .env.ANTHROPIC_AUTH_TOKEN == "legacy-proxy-token" and
  .env.ANTHROPIC_DEFAULT_OPUS_MODEL == "legacy-opus" and
  .env.ANTHROPIC_DEFAULT_SONNET_MODEL == "legacy-sonnet" and
  .env.ANTHROPIC_DEFAULT_HAIKU_MODEL == "legacy-haiku"
' "$CLAUDE_SWITCH_SETTINGS_FILE" >/dev/null

jq -e '
  .ANTHROPIC_BASE_URL == "https://legacy-proxy.example/anthropic" and
  .ANTHROPIC_AUTH_TOKEN == "legacy-proxy-token"
' "$CLAUDE_SWITCH_PROFILES_DIR/proxy.json" >/dev/null

bash "$SCRIPT_PATH" direct >/dev/null

export DEEPSEEK_API_KEY="deepseek-token"
bash "$SCRIPT_PATH" deepseek >/dev/null

jq -e '
  .env.ANTHROPIC_BASE_URL == "https://api.deepseek.com/anthropic" and
  .env.ANTHROPIC_AUTH_TOKEN == "deepseek-token" and
  .env.ANTHROPIC_MODEL == "deepseek-v4-pro[1m]" and
  .env.ANTHROPIC_DEFAULT_OPUS_MODEL == "deepseek-v4-pro[1m]" and
  .env.ANTHROPIC_DEFAULT_SONNET_MODEL == "deepseek-v4-pro[1m]" and
  .env.ANTHROPIC_DEFAULT_HAIKU_MODEL == "deepseek-v4-flash"
' "$CLAUDE_SWITCH_SETTINGS_FILE" >/dev/null

[[ -f "$CLAUDE_SWITCH_PROFILES_DIR/deepseek.json" ]]

unset DEEPSEEK_API_KEY
bash "$SCRIPT_PATH" direct >/dev/null

export MINIMAX_API_KEY="minimax-token"
bash "$SCRIPT_PATH" minimax >/dev/null

jq -e '
  .env.ANTHROPIC_BASE_URL == "https://api.minimax.io/anthropic" and
  .env.ANTHROPIC_AUTH_TOKEN == "minimax-token" and
  .env.ANTHROPIC_MODEL == "MiniMax-M3" and
  .env.ANTHROPIC_DEFAULT_OPUS_MODEL == "MiniMax-M3" and
  .env.ANTHROPIC_DEFAULT_SONNET_MODEL == "MiniMax-M3" and
  .env.ANTHROPIC_DEFAULT_HAIKU_MODEL == "MiniMax-M3"
' "$CLAUDE_SWITCH_SETTINGS_FILE" >/dev/null

[[ -f "$CLAUDE_SWITCH_PROFILES_DIR/minimax.json" ]]

echo "Smoke test passed."

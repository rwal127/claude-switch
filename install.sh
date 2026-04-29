#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${CLAUDE_SWITCH_INSTALL_BIN_DIR:-$HOME/.local/bin}"
TARGET_PATH="${BIN_DIR}/claude-switch"

default_switch_home() {
  local legacy_home xdg_home

  legacy_home="${HOME}/.claude-switch"
  xdg_home="${XDG_CONFIG_HOME:-${HOME}/.config}/claude-switch"

  if [[ -d "$legacy_home" && ! -d "$xdg_home" ]]; then
    printf '%s\n' "$legacy_home"
    return
  fi

  printf '%s\n' "$xdg_home"
}

SWITCH_HOME="${CLAUDE_SWITCH_HOME:-$(default_switch_home)}"
PROFILES_DIR="${CLAUDE_SWITCH_PROFILES_DIR:-$SWITCH_HOME/profiles}"

mkdir -p "$BIN_DIR"
mkdir -p "$PROFILES_DIR"

chmod +x "$REPO_DIR/bin/claude-switch"
ln -sfn "$REPO_DIR/bin/claude-switch" "$TARGET_PATH"

for example_path in "$REPO_DIR"/examples/profiles/*.json.example; do
  example_name="$(basename "$example_path")"
  target_example="${PROFILES_DIR}/${example_name}"
  if [[ ! -e "$target_example" ]]; then
    cp "$example_path" "$target_example"
  fi
done

cat <<EOF
Installed:
  $TARGET_PATH -> $REPO_DIR/bin/claude-switch

Profiles directory:
  $PROFILES_DIR

Next steps:
  1. Ensure $BIN_DIR is in your PATH
  2. Copy a *.json.example file in $PROFILES_DIR to *.json
  3. Fill in your own token locally
  4. Run: claude-switch list
EOF

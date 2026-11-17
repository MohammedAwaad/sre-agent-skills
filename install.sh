#!/usr/bin/env bash
# install.sh: copy the skills into Claude Code and/or OpenAI Codex.
#
#   ./install.sh            install for both (user level)
#   ./install.sh claude     Claude Code only  -> ~/.claude/skills/
#   ./install.sh codex      Codex only        -> ~/.agents/skills/
#   ./install.sh --project  install into the current repo instead
#                           (.claude/skills/ and .agents/skills/)
set -euo pipefail

src="$(cd "$(dirname "$0")" && pwd)/skills"
target="both"
scope="user"
for arg in "$@"; do
  case "$arg" in
    claude|codex|both) target="$arg" ;;
    --project) scope="project" ;;
    *) echo "unknown argument: $arg" >&2; exit 2 ;;
  esac
done

if [[ "$scope" == "user" ]]; then
  claude_dir="$HOME/.claude/skills"; codex_dir="$HOME/.agents/skills"
else
  claude_dir="$PWD/.claude/skills"; codex_dir="$PWD/.agents/skills"
fi

copy_to() {
  mkdir -p "$1"
  for skill in "$src"/*/; do
    name="$(basename "$skill")"
    rm -rf "${1:?}/$name"
    cp -R "$skill" "$1/$name"
    echo "installed $name -> $1/$name"
  done
}

[[ "$target" == "claude" || "$target" == "both" ]] && copy_to "$claude_dir"
[[ "$target" == "codex"  || "$target" == "both" ]] && copy_to "$codex_dir"
echo "done. Restart Claude Code or Codex if a skill does not show up."

#!/bin/bash
# RemotePass Design Marketplace — install script
# Run once per machine: bash install.sh

set -euo pipefail

SKILLS_DIR="$HOME/.claude/skills"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "RemotePass Design Marketplace — Setup"
echo "======================================"
echo ""

# Create the skills directory if it doesn't exist
mkdir -p "$SKILLS_DIR"

# Symlink all SKILL.md files into ~/.claude/skills/ (flattened, named by skill folder)
linked=0
while IFS= read -r -d '' skill; do
  skill_name=$(basename "$(dirname "$skill")")
  target="$SKILLS_DIR/${skill_name}.md"
  ln -sf "$skill" "$target"
  echo "  + /${skill_name}"
  ((linked++)) || true
done < <(find "$REPO_DIR/plugins" -name "SKILL.md" -print0)

echo ""
echo "$linked skill(s) linked to $SKILLS_DIR"
echo ""

# Optional: add team context to global Claude config
echo "Add shared team context to your global Claude config? (~/.claude/CLAUDE.md)"
echo "This loads RemotePass product context into every Claude session."
echo -n "(y/n): "
read -r answer

if [[ "$answer" =~ ^[Yy]$ ]]; then
  GLOBAL_CLAUDE="$HOME/.claude/CLAUDE.md"
  MARKER="<!-- remotepass-design-marketplace -->"

  if grep -q "$MARKER" "$GLOBAL_CLAUDE" 2>/dev/null; then
    echo "  Team context already present — skipping."
  else
    {
      echo ""
      echo "$MARKER"
      cat "$REPO_DIR/claude-md/CLAUDE.md"
      echo "$MARKER"
    } >> "$GLOBAL_CLAUDE"
    echo "  Added to $GLOBAL_CLAUDE"
  fi
fi

echo ""
echo "Done. Open Claude Code and type / to see your skills."
echo ""
echo "To get updates:  cd $REPO_DIR && git pull"
echo "New skill added: re-run bash install.sh"
echo ""

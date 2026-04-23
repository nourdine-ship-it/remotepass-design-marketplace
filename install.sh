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
# If SKILL.md sits directly in a skills/ folder (no subfolder), use the plugin name instead
linked=0
while IFS= read -r -d '' skill; do
  parent=$(basename "$(dirname "$skill")")
  if [ "$parent" = "skills" ]; then
    # No subfolder — climb up to the plugin folder for the name
    skill_name=$(basename "$(dirname "$(dirname "$skill")")")
  else
    skill_name="$parent"
  fi
  skill_dir=$(dirname "$skill")
  target="$SKILLS_DIR/${skill_name}"
  ln -sf "$skill_dir" "$target"
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
      cat "$REPO_DIR/CLAUDE.md"
      echo "$MARKER"
    } >> "$GLOBAL_CLAUDE"
    echo "  Added to $GLOBAL_CLAUDE"
  fi
fi

# Register hooks from each plugin into ~/.claude/settings.json
SETTINGS="$HOME/.claude/settings.json"
echo "Registering plugin hooks into $SETTINGS ..."
echo ""

python3 - "$REPO_DIR" "$SETTINGS" << 'PYEOF'
import json, os, sys

repo_dir = sys.argv[1]
settings_path = sys.argv[2]

try:
    with open(settings_path) as f:
        settings = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
    settings = {}

# Remove previously installed marketplace hooks (identified by repo_dir in command path)
existing = settings.get("hooks", {})
for event in list(existing.keys()):
    existing[event] = [
        e for e in existing[event]
        if not any(repo_dir in h.get("command", "") for h in e.get("hooks", []))
    ]
settings["hooks"] = existing

# Walk plugins and merge hooks
plugins_dir = os.path.join(repo_dir, "plugins")
count = 0
for plugin_name in sorted(os.listdir(plugins_dir)):
    plugin_dir = os.path.join(plugins_dir, plugin_name)
    hooks_json = os.path.join(plugin_dir, "hooks", "hooks.json")
    if not os.path.isfile(hooks_json):
        continue

    with open(hooks_json) as f:
        plugin_hooks = json.load(f)

    for event, entries in plugin_hooks.get("hooks", {}).items():
        if event not in settings["hooks"]:
            settings["hooks"][event] = []
        for entry in entries:
            resolved = []
            for h in entry.get("hooks", []):
                cmd = h["command"].replace("${CLAUDE_PLUGIN_ROOT}", plugin_dir)
                resolved.append({**h, "command": cmd})
            settings["hooks"][event].append({**entry, "hooks": resolved})
            count += 1
    print(f"  + {plugin_name} ({len(plugin_hooks.get('hooks', {}))} event(s))")

with open(settings_path, "w") as f:
    json.dump(settings, f, indent=2)
    f.write("\n")

print(f"\n{count} hook rule(s) registered into {settings_path}")
PYEOF

echo ""
echo "Done. Open Claude Code and type / to see your skills."
echo ""
echo "To get updates:  cd $REPO_DIR && git pull"
echo "New skill added: re-run bash install.sh"
echo ""

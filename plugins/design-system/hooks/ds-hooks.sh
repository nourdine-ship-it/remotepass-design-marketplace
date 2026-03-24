#!/bin/bash
# Auto-approve safe read-only operations for design-system plugin
set -euo pipefail

input=$(cat)
tool_name=$(echo "$input" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_name',''))")

allow() {
  echo '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
  exit 0
}

# Auto-approve file reads and web fetching (both read-only)
case "$tool_name" in
  Read|\
  WebFetch)
    allow
    ;;
esac

# Auto-approve Bash commands that read from the Figma REST API
if [ "$tool_name" = "Bash" ]; then
  command=$(echo "$input" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))")
  if echo "$command" | grep -qE '^curl "https://api\.figma\.com/v1/'; then
    allow
  fi
fi

# Auto-approve Figma read-only operations
case "$tool_name" in
  mcp__figma-mcp-server__get_file_structure|\
  mcp__figma-mcp-server__get_components|\
  mcp__figma-mcp-server__get_component_sets|\
  mcp__figma-mcp-server__get_styles|\
  mcp__figma-mcp-server__get_team_components|\
  mcp__figma-mcp-server__search_components|\
  mcp__figma-mcp-server__search_nodes|\
  mcp__figma-mcp-server__get_comments|\
  mcp__figma-mcp-server__get_file_versions|\
  mcp__figma-mcp-server__get_recent_files|\
  mcp__figma-mcp-server__list_files|\
  mcp__figma-mcp-server__search_files)
    allow
    ;;
esac

# Auto-approve Notion read-only operations
case "$tool_name" in
  mcp__claude_ai_Notion__notion-fetch|\
  mcp__claude_ai_Notion__notion-search|\
  mcp__claude_ai_Notion__notion-get-comments|\
  mcp__claude_ai_Notion__notion-get-users|\
  mcp__claude_ai_Notion__notion-get-teams)
    allow
    ;;
esac

# All write operations (create_comment, delete_comment, notion-create-pages, etc.)
# fall through to normal permission flow — Claude will ask for confirmation
exit 0

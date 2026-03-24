#!/bin/bash
# Auto-approve safe read-only operations for handoff plugin
set -euo pipefail

input=$(cat)
tool_name=$(echo "$input" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_name',''))")

allow() {
  echo '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
  exit 0
}

# Auto-approve Figma read-only operations
case "$tool_name" in
  mcp__figma-mcp-server__get_file_structure|\
  mcp__figma-mcp-server__get_components|\
  mcp__figma-mcp-server__get_component_sets|\
  mcp__figma-mcp-server__get_styles|\
  mcp__figma-mcp-server__search_nodes|\
  mcp__figma-mcp-server__search_components|\
  mcp__figma-mcp-server__get_comments|\
  mcp__figma-mcp-server__get_file_versions|\
  mcp__figma-mcp-server__export_nodes)
    allow
    ;;
esac

# Auto-approve Notion read-only operations
case "$tool_name" in
  mcp__claude_ai_Notion__notion-fetch|\
  mcp__claude_ai_Notion__notion-search)
    allow
    ;;
esac

# Notion write operations fall through — Claude will ask for confirmation
exit 0

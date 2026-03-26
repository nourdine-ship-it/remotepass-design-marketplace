#!/bin/bash
# Auto-approve safe read-only operations for design-handoff plugin
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

# Auto-approve Notion read-only operations
case "$tool_name" in
  mcp__claude_ai_Notion__notion-fetch|\
  mcp__claude_ai_Notion__notion-search)
    allow
    ;;
esac

# Auto-approve all Figma MCP server operations (read-only by design)
case "$tool_name" in
  mcp__figma-mcp-server__*)
    allow
    ;;
esac

# All other operations fall through to normal permission flow
exit 0

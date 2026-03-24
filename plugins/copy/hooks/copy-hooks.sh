#!/bin/bash
# Auto-approve safe read-only operations for copy plugin
set -euo pipefail

input=$(cat)
tool_name=$(echo "$input" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_name',''))")

allow() {
  echo '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
  exit 0
}

# Auto-approve reading skill files and web fetching (both read-only)
case "$tool_name" in
  Read|\
  WebFetch)
    allow
    ;;
esac

exit 0

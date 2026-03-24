---
title: Skill Name
description: One sentence — what this skill does. Shows in /help and autocomplete. Keep under 100 characters.
version: 1.0.0
requires: none
allowed-tools: WebFetch
argument-hint: "[what to pass, e.g. 'Figma link or component name']"
---

<!--
requires options:
  none              — works out of the box
  figma-bridge      — Figma MCP server must be running (see docs/setup.md)
  mcp-notion        — Notion MCP must be configured
  mcp-jira          — Jira MCP must be configured
  personal-config   — needs personal IDs in ~/.claude/design-team-config.md

allowed-tools options (add only what the skill actually needs):
  WebFetch          — fetch public URLs / Figma links
  Read              — read local files
  Write             — write local files
  Bash              — run shell commands (use sparingly)
  mcp__figma-mcp-server__*
  mcp__claude_ai_Notion__*
  mcp__claude_ai_Atlassian__*

Versioning: bump the version number in plugin.json only — never here.
-->

## Summary

2–3 sentences. What does this skill do? What does it produce? Who is it for?

## Why this is useful

The problem this skill solves for the team. Include the frustration or gap it addresses — this helps future contributors understand whether a proposed update is actually an improvement or just a preference.

## Key features

- [Feature / output 1]
- [Feature / output 2]
- [Feature / output 3]

## Triggers

Natural language examples that would activate this skill. Be specific — these help Claude know when to suggest the skill and help teammates know when to reach for it.

- "[Example trigger 1]"
- "[Example trigger 2]"
- "[Example trigger 3]"

## Prerequisites

<!-- Delete this section if requires: none -->

Before doing anything else, check:
- If this skill requires **figma-bridge**: attempt a Figma MCP tool call. If it fails, stop and tell the user: "This skill needs the Figma bridge running. Type `/connect-figma` first, or see `docs/setup.md`."
- If this skill requires **personal-config**: check if `~/.claude/design-team-config.md` exists. If not, stop and say: "You need a personal config file. See `docs/setup.md` — takes 2 minutes."

## Behavior & Instruction

Step-by-step instructions for what Claude does when this skill is invoked. This is the core of the skill — be specific. Vague instructions produce inconsistent output.

1. If context is missing, ask for: [list exactly what you need]
2. [Step 2]
3. [Step 3]
4. Always end with: [what the output looks like]

## Examples

Concrete examples of how to invoke this skill.

- "[Example 1]"
- "[Example 2]"

## Security & Safety

- [What operations this skill performs — read vs write]
- [What is auto-approved vs requires confirmation]
- [Any data sensitivity notes]

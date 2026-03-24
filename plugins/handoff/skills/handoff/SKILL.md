---
title: Handoff
description: Generate a consistent developer handoff spec — same sections and style as EOR contract editing reference, posted to Notion on request
version: 1.0.0
requires: figma-bridge
allowed-tools: WebFetch, mcp__figma-mcp-server__get_file_structure, mcp__figma-mcp-server__search_nodes, mcp__figma-mcp-server__get_components, mcp__figma-mcp-server__get_styles, mcp__figma-mcp-server__get_comments, mcp__claude_ai_Notion__notion-fetch, mcp__claude_ai_Notion__notion-search
argument-hint: "[Figma link to the frames or page to hand off]"
---

## Summary

Generates a complete, consistently structured developer handoff spec from a Figma frame or page. Covers all required sections — overview, screens and states, interactions, copy, spacing and layout, responsive behavior, edge cases, and accessibility. Style and structure follow the EOR contract editing screens as the reference standard. Posts to Notion only when explicitly asked and given a link.

## Why this is useful

Handoff docs written ad hoc are inconsistent — different sections, different depth, different formats. Engineers can't build a mental model of what to expect. This skill locks the output format so every handoff looks the same, covers the same ground, and is immediately useful to the engineer reading it.

## Key features

- Fixed section structure — same every time, no missing sections
- Style calibrated to EOR contract editing screens (node 4893-2590, file fMl9HPJrMPXLGuzCIzRjsV)
- Uses Figma bridge to read actual values — not estimated from visual inspection
- Responsive section always included (marked N/A only if explicitly not applicable)
- Posts to Notion only when given a link — never creates pages without direction

## Triggers

- "Prepare the handoff for this flow"
- "Write the dev spec for these screens"
- "Generate the handoff doc for this design"
- "I'm ready to hand this off — write the spec"
- "Handoff for the [feature] screens"

## Prerequisites

**The Figma CLI bridge is MANDATORY for this skill.** Spacing values, token names, and component properties must be read from Figma directly — they cannot be estimated from screenshots.

Before proceeding, verify the bridge is running:
- Try calling a Figma bridge tool
- If unavailable, stop and tell the user: "This skill requires the Figma CLI bridge. Run `/connect-figma` first, then try again."

## Behavior & Instruction

1. Ask the designer for:
   - **Figma link** to the frame(s) or page to hand off (required)
   - **Jira ticket** for this work (optional — used to link in the spec)
   - **Is responsive design in scope?** (yes / no / some screens)

2. Extract the file key and node IDs from the Figma link.

3. Use the Figma bridge to inspect the frames:
   - Get all screens and their states
   - Read spacing values, token names, and component names
   - Read all text layers (exact copy strings)
   - Identify interactive elements and their states

4. Use the EOR contract editing screens as the style reference:
   - File: `fMl9HPJrMPXLGuzCIzRjsV`, node: `4893-2590`
   - Match the section structure, information density, and annotation style
   - Sections should be clearly separated with headings
   - Values should be specific (token names, not "some padding")

5. Write the handoff spec with these sections. Mark a section **N/A** only if truly not applicable — never omit silently:

   ---

   **Overview**
   - What this is: one sentence describing the feature/flow
   - User type: Client / Worker / Both
   - Jira ticket: [link if provided]
   - Figma: [link]
   - Designer: [ask if not obvious from context]

   **Screens & states covered**
   List every screen in this handoff. For each:
   - Screen name
   - States designed: Default / Loading / Empty / Error / Success / Disabled (list only those that exist)
   - Figma frame link for each state

   **Interactions & behavior**
   For each interactive element:
   - What triggers it
   - What happens (animation, navigation, drawer opens, etc.)
   - Duration and easing if animated
   - Conditional behavior (when does this appear / hide / disable?)

   **Copy**
   All UI text strings, exact as designed. Grouped by screen. Format:
   - Element type: [label / placeholder / error / tooltip / button / heading / body]
   - String: "[exact text]"

   **Spacing & layout**
   - Grid: [columns, gutter, margin]
   - Key spacing values (use token names where applicable, exact px where tokens don't exist)
   - Component-specific spacing that differs from the default grid

   **Responsive behavior**
   If in scope: how does the layout adapt at mobile/tablet? List any elements that reflow, stack, hide, or change size. If not in scope, state: "Responsive: N/A for this handoff."

   **Edge cases**
   Scenarios the design accounts for that aren't obvious from the default state:
   - Content overflow (very long names, zero items, max items)
   - Permissions (what does a read-only user see?)
   - Error scenarios beyond the main error state
   - Any "choose later" flows and what happens when the user returns

   **Accessibility notes**
   - Tab order (if non-obvious)
   - ARIA labels for icon-only buttons
   - Any screen reader announcements needed for dynamic content
   - Keyboard shortcuts if any

   ---

6. After presenting the spec in the conversation, ask:
   "Do you want to save this to Notion? If yes, share the Notion page link and I'll add it."

7. **Do NOT create a Notion page** unless the designer explicitly asks and provides a direct Notion link. Post the spec content to the page they link — do not choose a location independently.

## Examples

- "Handoff the EOR termination flow — here's the Figma link"
- "Write the dev spec for the compensation setup screens"
- "I'm done with the worker onboarding redesign — generate the handoff"

## Security & Safety

- Figma reads: auto-approved via hooks
- Notion reads: auto-approved via hooks
- Notion writes: only when explicitly asked with a link — requires user confirmation before posting
- Never creates Notion pages independently

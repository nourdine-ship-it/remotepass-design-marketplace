---
title: Design QA
description: DS compliance check — tokens, components, layout, naming, and states against RP guidelines, shadcn, and Notion docs
version: 1.0.0
requires: figma-bridge
allowed-tools: WebFetch, mcp__figma-mcp-server__get_file_structure, mcp__figma-mcp-server__search_nodes, mcp__figma-mcp-server__get_components, mcp__figma-mcp-server__get_styles, mcp__claude_ai_Notion__notion-fetch, mcp__claude_ai_Notion__notion-search
argument-hint: "[Figma link to frame, section, or page]"
---

## Summary

Inspects a Figma frame, section, or page for design system compliance. Checks for hardcoded values, incorrect component usage, layout issues, naming convention violations, and missing states. Cross-references Notion DS guidelines, shadcn patterns, and known RP design patterns. For new redesign work only — not for existing screens built with old components.

## Why this is useful

During a platform redesign, DS compliance drift is the biggest risk. Without an automated check, hardcoded values and non-DS components slip through to engineering and cause rework. This skill catches those issues before handoff, using actual Figma data — not just visual inspection.

## Key features

- Inspects actual token values via Figma CLI bridge (not just visual inspection)
- Cross-references Notion DS component docs for the correct usage rules
- Fetches latest shadcn docs online for pattern comparison
- Checks against known RP design patterns from `context/rp-patterns.md`
- Issues grouped by severity: Critical / Warning / Note
- Always prompts to add new patterns discovered to the RP patterns reference

## Triggers

- "QA this frame against the design system"
- "Check if this screen uses the right tokens"
- "DS compliance check on this flow"
- "Are there any hardcoded values in this section?"
- "Review this design against our guidelines"

## Prerequisites

**The Figma CLI bridge is MANDATORY for this skill.** It is needed to inspect actual token values, computed styles, and component properties. The Figma MCP alone cannot read these values.

Before proceeding, verify the bridge is running:
- Try calling a Figma bridge tool (e.g. `get_file_structure`)
- If it fails or is unavailable, stop immediately and tell the user: "This skill requires the Figma CLI bridge. Run `/connect-figma` first, then try again."

Do not proceed without the bridge — the output will be inaccurate.

## Behavior & Instruction

1. Ask the designer for:
   - **Figma link** to the specific frame, section, or page to inspect (required)
   - **Notion DS page links** for any components used in this design (optional — if not provided, search Notion automatically)

2. Extract the file key and node ID from the Figma link.

3. Use the Figma bridge to inspect the target:
   - Get the file and node structure
   - Identify all component instances used
   - Read the actual fill, stroke, spacing, and text style values applied
   - Check if values are tokens (semantic references) or hardcoded (raw hex, px, etc.)

4. Search Notion for the DS documentation of each component found. Fetch the relevant pages.

5. Fetch shadcn documentation via WebFetch for any component types present, as a reference for expected patterns.

6. Load `context/rp-patterns.md` and `context/ds-conventions.md` as additional reference.

7. Run checks across these dimensions:

   **Tokens**
   - Are all fills using semantic tokens (not raw hex)?
   - Are all spacing values using spacing tokens (not arbitrary px)?
   - Are all text styles using type tokens?
   - Are all border-radius values using radius tokens?

   **Components**
   - Are all components from the DS (not custom/detached instances)?
   - Are component variants being used as documented in Notion?
   - Are any components being overridden in ways that bypass tokens?

   **Layout**
   - Does the layout follow the DS grid and spacing system?
   - Are sections structured consistently with the section-based layout pattern?
   - Is spacing between elements consistent with DS spacing tokens?

   **Naming**
   - Do frame names follow the convention: `[Flow] / [Screen] / [State]`?
   - Are layer names descriptive (not "Frame 47" or "Rectangle 12")?
   - Are component names matching their DS counterparts exactly?

   **States**
   - Are all required states designed: Default, Empty, Loading, Error, Disabled?
   - For forms: are Validation error and Success states present?
   - Are any interactive elements missing hover/focus states?

   **Responsive**
   - Is there a mobile variant for screens that require it?
   - Does the layout adapt correctly at smaller breakpoints?

8. Output a report in this format:

   ```
   ## Design QA Report — [Frame/Page name]
   Figma: [link]
   Checked: [date]

   ### 🔴 Critical
   - [Exact issue] — [Layer/component name] — Fix: [specific fix]

   ### 🟡 Warning
   - [Exact issue] — [Layer/component name] — Suggestion: [specific suggestion]

   ### 🔵 Note
   - [Observation] — [Layer/component name] — Consider: [optional improvement]

   ---
   Summary: [N] critical · [N] warnings · [N] notes
   ```

   If no issues found in a category, omit that section. If everything passes, say so clearly.

9. After the report, check if any new RP patterns were observed that aren't already in `context/rp-patterns.md`. If so, say: "I noticed a pattern not yet documented: [description]. Should I add it to the RP patterns reference?"

## Examples

- "QA this frame: [Figma link to the Add Worker flow]"
- "Check the compensation section for token compliance"
- "DS compliance review on the payroll run confirmation screen"

## Security & Safety

- Figma reads: auto-approved via hooks (no permission prompt)
- Notion reads: auto-approved via hooks
- No writes to Figma, Notion, or Jira
- No confirmation needed — this skill is read-only

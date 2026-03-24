---
title: Design QA
description: DS compliance check — tokens, components, layout, naming, and states against RP guidelines, shadcn, and Notion docs, inspected via the Figma REST API
version: 1.1.0
requires: |
  - Figma frame URL (required) — the frame, section, or page to inspect
  - FIGMA_ACCESS_TOKEN environment variable — for REST API access
  - Notion MCP connected — for fetching DS component documentation
allowed-tools: WebFetch, Read, Bash
argument-hint: "[figma-url]"
---

## Summary

Inspects a Figma frame, section, or page for design system compliance. Checks for hardcoded values, incorrect component usage, layout issues, naming convention violations, and missing states. Cross-references Notion DS component docs and shadcn patterns. Uses the Figma REST API — no bridge CLI required.

## Why this is useful

During a platform redesign, DS compliance drift is the biggest risk. Without an automated check, hardcoded values and non-DS components slip through to engineering and cause rework. This skill catches those issues before handoff using actual Figma data.

## Key features

- Figma REST API inspection — reads actual token values, component names, and layer structure
- Cross-references Notion DS docs for correct component usage rules
- Fetches latest shadcn docs for pattern comparison
- Issues grouped by severity: Critical / Warning / Note

## Triggers

- "QA this frame against the design system"
- "Check if this screen uses the right tokens"
- "DS compliance check on this flow"
- "Are there any hardcoded values in this section?"
- "Review this design against our guidelines"

## Prerequisites

- **Figma frame URL** (required) — the specific frame, section, or page to inspect
- **Figma REST API token** — set as `FIGMA_ACCESS_TOKEN` in the environment. Must be a **read-only token**: grant only `files:read` and `variables:read` scopes. Do not grant write, delete, or update permissions.
- **Notion MCP connected** — used to fetch DS component documentation

## Behavior & Instruction

1. **Collect inputs and verify connections**

   Check what was provided in the arguments. If the Figma URL is missing, ask for it.

   Then verify:
   - Confirm `FIGMA_ACCESS_TOKEN` is available. If not, ask the user to set it — remind them it must be a read-only token (`files:read` + `variables:read` scopes only, no write or delete permissions).
   - Confirm Notion MCP is connected by making a lightweight call (`mcp__claude_ai_Notion__notion-fetch`). If it fails, tell the user: "Notion MCP is not connected — please check your MCP configuration before running this skill."

2. **Extract IDs from the Figma URL**
   - Extract the file key from the URL path
   - Extract `node-id`, convert dashes to colons (e.g. `4605-4156` → `4605:4156`)

3. **Inspect the target frame via Figma REST API**
   ```
   curl "https://api.figma.com/v1/files/{file_key}/nodes?ids={node_id}&depth=4" \
     -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
   ```

   Extract:
   - All component instances used (names, which DS components they are)
   - All fill values — check for raw hex colors (no token binding)
   - All spacing values (`paddingLeft/Right/Top/Bottom`, `itemSpacing`) — check for arbitrary px values
   - All text style references — check if they're using DS type tokens
   - All border-radius values — flag non-zero values with no token binding
   - Layer names — check for generic names like "Frame 47" or "Rectangle 12"
   - Frame naming — check for `[Flow] / [Screen] / [State]` convention

   **Token audit accuracy rules:**
   - `boundVariables` with empty string value (`""`) is not a hardcoded value. Cross-check the actual pixel value.
   - `cornerRadius: 0` and `rectangleCornerRadii: [0,0,0,0]` with no binding are not violations.
   - Only flag non-zero fills, spacings, or radii with no variable binding.
   - **External library tokens** have a long hash prefix before `/` (e.g. `VariableID:2348e5af.../1699:241`). Flag separately from hardcoded values.

4. **Fetch Notion DS docs** for each DS component found in the frame

   Search Notion for the component's documentation page. Fetch and extract the correct variant usage rules from the `## Variants & Properties` section. Use this to check if components are being used correctly.

5. **Fetch shadcn docs** (WebFetch) for relevant component types as a pattern reference
   - `https://ui.shadcn.com/docs/components/{component-name}`

6. **Run checks across these dimensions:**

   **Tokens**
   - All fills using semantic tokens (not raw hex)?
   - All spacing values using spacing tokens (not arbitrary px)?
   - All text styles using DS type tokens?
   - All border-radius values using radius tokens (non-zero only)?

   **Components**
   - All components from the DS (not custom/detached instances)?
   - Component variants used as documented in Notion?
   - Any components overridden in ways that bypass tokens?

   **Layout**
   - Does the layout follow the DS grid and spacing system?
   - Is spacing between elements consistent with DS spacing tokens?

   **Naming**
   - Frame names follow `[Flow] / [Screen] / [State]` convention?
   - Layer names descriptive (not "Frame 47" or "Rectangle 12")?

   **States**
   - All required states designed: Default, Empty, Loading, Error, Disabled?
   - For forms: Validation error and Success states present?
   - Interactive elements have hover/focus states?

7. **Output report:**

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

## Examples

- "QA this frame: [Figma link to the Add Worker flow]"
- "Check the compensation section for token compliance"
- "DS compliance review on the payroll run confirmation screen"

## Security & Safety

- Figma REST API read — non-destructive.
- Notion reads — non-destructive.
- No writes anywhere, no confirmation needed.

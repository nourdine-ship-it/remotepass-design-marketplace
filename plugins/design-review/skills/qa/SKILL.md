---
title: Design Review
description: Structured critique across 6 UX dimensions including DS compliance — extracts Figma layer data, cross-references the DS library and Notion docs, delivers actionable feedback sorted by severity
version: 1.3.0
requires: |
  - Figma frame URL (required)
  - FIGMA_ACCESS_TOKEN (required for private files — set as env var with files:read scope)
  - Notion MCP (required — for reading RemotePass DS documentation)
allowed-tools: WebFetch, Bash, mcp__claude_ai_Notion__notion-fetch, mcp__claude_ai_Notion__notion-search
argument-hint: "[figma-url]"
---

## What is this about?

Structured, honest critique of a design across six dimensions. Extracts the actual Figma layer tree — text content, component names, nesting, variable bindings, states — cross-references the RemotePass Design System Figma library and Notion documentation, then delivers specific, actionable findings sorted by severity.

## What is the value?

Critique without a shared framework produces vague, inconsistent feedback. Reading the Figma layer tree directly means every finding is grounded in what's actually in the file. Cross-referencing the DS library and Notion docs catches token misuse, hardcoded values, and component deviations before they reach engineering.

## What does it do?

- Extracts layer structure, text layers, component instances, variable bindings, and nesting from Figma
- Cross-references the RemotePass DS Figma library to verify component usage
- Reads Notion DS documentation to validate token, spacing, color, and typography rules
- Reviews across six fixed dimensions to ensure full coverage
- Delivers one concrete fix per issue, sorted by severity

## When to call it?

- "Review this design before I share it with the team"
- "Give me feedback on this flow — I'm not sure about the hierarchy"
- "Quick critique of this modal before I hand off to engineering"
- "I got vague feedback from the PM, help me pressure-test it"

## What is needed?

- **Figma frame URL** — the specific frame, screen, or flow to review
- **`FIGMA_ACCESS_TOKEN`** — only required if the file is private. Set in environment with `files:read` scope only (no write or delete permissions). If missing and the file is inaccessible, ask the user to set it.
- **Notion MCP** — must be configured to access the RemotePass workspace. Used to read DS component documentation and foundations (colour, typography, spacing, layout).

## Fixed resources

These are always referenced — do not ask the user for them:

- **RemotePass DS Figma file:** `https://www.figma.com/design/68BjBAp23kbcFrNQ9bK6jP/RemotePass-Design-System`
- **RemotePass DS Notion docs:** `https://www.notion.so/remotepass/RemotePass-Design-System-254c5c4e315080bc9db4f3bc75fa129a`

## How does it work?

1. **Check inputs**

   If the Figma URL is missing, ask for it. Check whether `FIGMA_ACCESS_TOKEN` is set in the environment — use it if available, skip the header if not. If the API call fails with a 403, ask the user to provide the token.

2. **Load DS reference material**

   In parallel:
   - Fetch the Notion DS root page and navigate to relevant sections (foundations: colour, typography, spacing, layout; and any component pages relevant to what's in the frame)
   - Fetch the RemotePass DS Figma file's component list to get canonical component names and structure:
     ```bash
     curl "https://api.figma.com/v1/files/68BjBAp23kbcFrNQ9bK6jP/components" \
       -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
     ```

3. **Extract IDs from the design frame URL**
   - File key: from the URL path segment after `/file/` or `/design/`
   - Node ID: from `node-id` query param — convert dashes to colons (e.g. `4605-4156` → `4605:4156`)

4. **Fetch the design frame from the Figma REST API**

   ```bash
   curl "https://api.figma.com/v1/files/{file_key}/nodes?ids={node_id}&depth=4" \
     -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
   ```

   Extract from the response:
   - All text layers and their content
   - All component instances and their source component names
   - Variable bindings on fills, strokes, spacing, and text styles — note any properties with raw hardcoded values instead of bound variables
   - Layer nesting depth and structure
   - Visible states or variants
   - Frame dimensions and layout structure

5. **Review across 6 dimensions**

   - **Clarity** — Is it immediately obvious what to do and why? Are labels and CTAs unambiguous?
   - **Hierarchy** — Does the structure guide attention in the right order? Are primary and secondary actions visually distinct?
   - **Friction** — Where might a user hesitate, get confused, or drop off? Unnecessary steps or unclear inputs?
   - **Consistency** — Are patterns and interactions coherent with the rest of the product?
   - **Edge cases** — What states are missing? (empty, loading, error, long text, mobile)
   - **Design system compliance** — Do all components match their counterpart in the DS Figma library? Are all fills, strokes, spacing values, and text styles bound to DS variables and tokens — no hardcoded values? Cross-reference Notion docs for the relevant components and foundations to confirm correct usage.

6. **Output findings sorted by severity**

   Group all issues across all dimensions into:
   - **Critical** — blocks use, causes confusion, or would fail a usability test
   - **High** — creates friction, mismatches expectations, or violates DS rules
   - **Medium** — noticeable issues to fix before handoff
   - **Low** — polish, minor inconsistencies, or nice-to-haves

   For each issue: tag the dimension, state the observation referencing the exact layer name, text string, or component, and give one concrete fix.

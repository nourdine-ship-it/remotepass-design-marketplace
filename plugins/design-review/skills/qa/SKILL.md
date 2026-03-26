---
title: Design Review
description: Structured critique across 5 UX dimensions including copy and tone — extracts Figma layer data, delivers actionable feedback sorted by severity
version: 1.4.0
requires: |
  - Figma frame URL (required)
  - FIGMA_ACCESS_TOKEN (required for private files — set as env var with files:read scope)
allowed-tools: WebFetch, Bash
argument-hint: "[figma-url]"
---

## What is this about?

Structured, honest critique of a design across five dimensions. Extracts the actual Figma layer tree — text content, component names, nesting, states — then delivers specific, actionable findings sorted by severity.

## What is the value?

Critique without a shared framework produces vague, inconsistent feedback. Reading the Figma layer tree directly means every finding is grounded in what's actually in the file, not assumptions about the design.

## What does it do?

- Extracts layer structure, text layers, component instances, and nesting from Figma
- Reviews across five fixed dimensions to ensure full coverage — including copy and tone against RemotePass voice guidelines
- Delivers one concrete fix per issue, sorted by severity

## When to call it?

- "Review this design before I share it with the team"
- "Give me feedback on this flow — I'm not sure about the hierarchy"
- "Quick critique of this modal before the crit"
- "I got vague feedback from the PM, help me pressure-test it"

## What is needed?

- **Figma frame URL** — the specific frame, screen, or flow to review
- **`FIGMA_ACCESS_TOKEN`** — only required if the file is private. Set in environment with `files:read` scope only (no write or delete permissions). If missing and the file is inaccessible, ask the user to set it.

## How does it work?

1. **Check inputs**

   If the Figma URL is missing, ask for it. Check whether `FIGMA_ACCESS_TOKEN` is set in the environment — use it if available, skip the header if not. If the API call fails with a 403, ask the user to provide the token.

2. **Extract IDs from the design frame URL**
   - File key: from the URL path segment after `/file/` or `/design/`
   - Node ID: from `node-id` query param — convert dashes to colons (e.g. `4605-4156` → `4605:4156`)

3. **Fetch the design frame from the Figma REST API**

   ```bash
   curl "https://api.figma.com/v1/files/{file_key}/nodes?ids={node_id}&depth=4" \
     -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
   ```

   Extract from the response:
   - All text layers and their content
   - All component instances and their source component names
   - Layer nesting depth and structure
   - Visible states or variants
   - Frame dimensions and layout structure

4. **Review across 5 dimensions**

   - **Clarity** — Is it immediately obvious what to do and why? Are labels and CTAs unambiguous?
   - **Hierarchy** — Does the structure guide attention in the right order? Are primary and secondary actions visually distinct?
   - **Friction** — Where might a user hesitate, get confused, or drop off? Unnecessary steps or unclear inputs?
   - **Consistency** — Are patterns and interactions coherent with the rest of the product?
   - **Copy & tone** — Does all microcopy (labels, CTAs, error messages, tooltips, placeholders, helper text) follow RemotePass voice guidelines? Clear, warm, direct — no jargon, no passive voice, no filler words ("seamlessly", "powerful", "robust", "leverage"). Placeholders: free text → `e.g. [realistic example]`, selects → `Select [noun]`. Never repeat the label in a placeholder.

5. **Output findings sorted by severity**

   Group all issues across all dimensions into:
   - **Critical** — blocks use, causes confusion, or would fail a usability test
   - **High** — creates friction, mismatches expectations, or violates product patterns
   - **Medium** — noticeable issues to fix before sharing with the team
   - **Low** — polish, minor inconsistencies, or nice-to-haves

   For each issue: tag the dimension, state the observation referencing the exact layer name, text string, or component, and give one concrete fix.
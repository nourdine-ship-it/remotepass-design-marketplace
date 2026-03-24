---
title: Design Review
description: Structured design critique across 5 dimensions — clarity, hierarchy, friction, consistency, edge cases — inspects the Figma frame via REST API for accurate layer data
version: 1.1.0
requires: |
  - Figma frame URL (required) — the screen or flow to review
  - FIGMA_ACCESS_TOKEN environment variable — for REST API access
allowed-tools: WebFetch, Read, Bash
argument-hint: "[figma-url]"
---

## Summary

Gives a structured, honest critique of a design across five UX dimensions. Inspects the Figma frame via the REST API to extract actual layer structure, text content, and component names — then produces specific, anchored observations with one concrete fix per issue.

## Why this is useful

Async design critique without a shared framework produces inconsistent, often useless feedback. Inspecting the actual Figma layer tree means findings are grounded in what's really there — not a visual impression of a screenshot.

## Key features

- Figma REST API inspection — extracts layer structure, text layers, component names, and nesting
- Five fixed dimensions — ensures coverage, prevents random jumping
- One concrete change per issue — forces actionable specificity
- Design stage awareness — early explorations get direction feedback, handoff-ready designs get detail feedback
- Priority output — ends with the single most important thing to fix

## Triggers

- "Review this design before I share it with the team"
- "Give me feedback on this flow — I'm not sure about the hierarchy"
- "Can you critique this screen? It's mid-fi, ready for a first review"
- "I got vague feedback from the PM, help me pressure-test it"
- "Review this against UX principles before I hand it off"

## Prerequisites

- **Figma frame URL** (required) — the specific frame, screen, or flow to review
- **Figma REST API token** — set as `FIGMA_ACCESS_TOKEN` in the environment. Must be a **read-only token**: grant only `files:read` scope. Do not grant write, delete, or update permissions.

## Behavior & Instruction

1. **Collect inputs and verify access**

   Check what was provided in the arguments. If the Figma URL is missing, ask for it.

   Confirm `FIGMA_ACCESS_TOKEN` is available in the environment. If not, ask the user to set it — remind them it must be a read-only token (`files:read` scope only, no write or delete permissions).

   Also ask for any context that's missing (skip if already provided):
   - **User goal:** what is the user trying to accomplish?
   - **Business goal:** what does this design need to achieve?
   - **Design stage:** Early exploration / Mid-fidelity / Ready for dev handoff
   - **Focus area:** (optional) what are you most uncertain about?

2. **Extract IDs from the Figma URL**
   - Extract the file key from the URL path
   - Extract `node-id`, convert dashes to colons (e.g. `4605-4156` → `4605:4156`)

3. **Inspect the frame via Figma REST API**
   ```
   curl "https://api.figma.com/v1/files/{file_key}/nodes?ids={node_id}&depth=4" \
     -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
   ```

   From the response, extract:
   - Frame name and type
   - All text layers and their content (for copy and hierarchy review)
   - All component instances and which DS components are used
   - Layer nesting depth and structure (for hierarchy review)
   - Any visible states or variants in use
   - Frame dimensions and basic layout structure

4. **Review the design across 5 dimensions.** For each:
   - Give a 1-sentence verdict: **Strong** / **Needs work** / **Unclear without more context**
   - List specific observations — reference the exact layer name, text string, or component
   - Suggest one concrete change per issue identified

   The 5 dimensions:
   - **Clarity** — Is it immediately obvious what to do and why? Are labels and CTAs unambiguous?
   - **Hierarchy** — Does the structure guide attention in the right order? Are primary and secondary actions visually distinct?
   - **Friction** — Where might a user hesitate, get confused, or drop off? Are there unnecessary steps or unclear inputs?
   - **Consistency** — Does this use components and patterns the user already knows? Any deviations from DS components?
   - **Edge cases** — What states does this not handle? (empty, loading, error, long text, mobile)

5. **End with: Priority fix** — the single most important thing to address before this moves to the next stage, and why.

## Examples

- "Review the EOR onboarding flow — it's mid-fi and I'm sharing it with the PM tomorrow"
- "This is the empty state for the Payroll tab. Does the hierarchy work?"
- "Quick critique of this modal before I hand off to engineering"

## Security & Safety

- Figma REST API read — non-destructive.
- No writes anywhere, no confirmation needed.

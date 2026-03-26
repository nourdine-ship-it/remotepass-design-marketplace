---
title: Handoff Readiness
description: Pre-handoff checklist — verifies breakpoints, use cases, system states, DS compliance, and changelog before a design moves to dev
version: 1.0.0
requires: |
  - Figma frame URL (required)
  - FIGMA_ACCESS_TOKEN (required for private files — set as env var with files:read scope)
  - Notion MCP (required — for reading RemotePass DS documentation)
allowed-tools: WebFetch, Bash, mcp__claude_ai_Notion__notion-fetch, mcp__claude_ai_Notion__notion-search
argument-hint: "[figma-url]"
---

## What is this about?

A structured pre-handoff gate. Runs through a fixed checklist against the actual Figma file — layer structure, DS token usage, breakpoints, use cases, system states, text length variations, and changelog — then delivers a Pass/Fail result per category with specific gaps called out.

## What is the value?

Designs that move to dev incomplete create rework. This skill catches missing states, hardcoded values, unreviewed breakpoints, and absent changelogs before engineering picks up the ticket — not after.

## What does it do?

- Fetches the Figma frame and reads its layer structure, component instances, variable bindings, and visible states
- Cross-references the RemotePass DS Figma library and Notion documentation to verify token and component usage
- Checks all required breakpoints, use cases, system states, and text length variations
- Flags naming and layer hygiene issues as advisory (non-blocking)
- Verifies changelog presence on the Figma page
- Prompts the designer to mark the frame as Ready for Dev in Figma

## When to call it?

- "Is this design ready for dev?"
- "Check this before I move the ticket to Ready for Dev"
- "Run a handoff check on this flow"

## What is needed?

- **Figma frame URL** — the specific frame, section, or flow to check
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
   - All frames and their names — identify breakpoint variants (desktop, mobile, tablet)
   - All component instances and their source component names
   - Variable bindings on fills, strokes, spacing, and text styles — note any properties with raw hardcoded values instead of bound variables
   - Layer names and nesting structure
   - Visible states, variants, and interaction labels
   - Text layer content for length variation assessment

   Also fetch the Figma page metadata to check for a changelog:
   ```bash
   curl "https://api.figma.com/v1/files/{file_key}?depth=1" \
     -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
   ```

5. **Run the readiness checklist**

   Evaluate each category and assign **Pass** or **Fail**. For each Fail, call out the specific gap.

   ### Breakpoints
   - **Desktop** — frame present and complete
   - **Mobile** — frame present and complete
   - **Tablet** — optional; flag if the feature warrants it but is absent

   ### Use cases
   Context-aware — infer from the feature what cases are expected, then verify each is designed:
   - Default / initial state
   - Submitted / saved state
   - Empty state (no data, first use)
   - File added / item selected
   - Success confirmation
   - Any other case relevant to the specific flow

   ### System states
   Context-aware — infer from the feature what states are expected, then verify each is designed:
   - Loading
   - Error (inline validation, API failure, empty results)
   - Success / confirmation
   - Any other interaction or behaviour relevant to the specific flow

   ### Text length variations
   - Short text — fits in one line, no wrapping
   - Long text — label or value exceeds expected width
   - Overflow / truncation — how is overflow handled? Is truncation deliberate and marked?
   - Wrapping — does layout hold when text wraps to multiple lines?

   ### Naming & layer hygiene _(advisory — non-blocking)_
   - Frames follow the naming convention: `[Flow] / [Screen name] / [State]`
   - No unnamed layers (`Frame 42`, `Group 7`)
   - No orphaned or hidden layers that are not intentional states

   ### DS compliance
   - All component instances match their canonical counterpart in the RemotePass DS Figma library
   - All fills, strokes, spacing values, and text styles are bound to DS variables and tokens — no hardcoded values
   - Cross-reference Notion docs for the relevant components and foundations to confirm correct usage
   - Cross-reference shadcn for structural alignment where applicable

   ### Changelog
   - A changelog frame or section is present on the Figma page
   - It reflects the current version of the design (recent changes are documented)

   ### Ready for Dev
   - Prompt the designer: "Have you marked this frame as Ready for Dev in Figma?" If not, remind them to do so before handing off to engineering.

6. **Output**

   Deliver one Pass/Fail table per category. For each Fail, state the specific gap and what needs to be added or fixed before handoff. Naming & layer hygiene findings are listed separately as advisory — they do not affect the overall Pass/Fail result.

   End with an overall verdict:
   - **Ready** — all required categories pass
   - **Not ready** — one or more required categories fail, list what's blocking

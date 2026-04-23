---
title: Handoff Readiness
description: Pre-handoff checklist — verifies breakpoints, modes & themes, use cases, system states, DS compliance, and changelog before a design moves to dev
version: 1.0.4
requires: |
  - Figma frame URL (required)
  - FIGMA_ACCESS_TOKEN (required for private files — set as env var with files:read and variables:read scopes)
  - Notion MCP (required — for reading RemotePass DS documentation)
allowed-tools: WebFetch, Bash, Edit, Write, mcp__claude_ai_Notion__notion-fetch, mcp__claude_ai_Notion__notion-search
argument-hint: "[figma-url]"
---

## What is this about?

A structured pre-handoff gate. Runs through a fixed checklist against the actual Figma file — layer structure, DS token usage, breakpoints, use cases, system states, text length variations, and changelog — then delivers a Pass/Fail result per category with specific gaps called out.

## What is the value?

Designs that move to dev incomplete create rework. This skill catches missing states, hardcoded values, unreviewed breakpoints, and absent changelogs before engineering picks up the ticket — not after.

## What does it do?

- Fetches the Figma frame and reads its layer structure, component instances, variable bindings, and visible states
- Cross-references the RemotePass DS Figma library and Notion documentation to verify token and component usage
- Checks all required breakpoints, modes & themes, use cases, system states, and text length variations
- Flags naming and layer hygiene issues as advisory (non-blocking)
- Verifies changelog presence on the Figma page
- Prompts the designer to mark the frame as Ready for Dev in Figma

## When to call it?

- "Is this design ready for dev?"
- "Check this before I move the ticket to Ready for Dev"
- "Run a handoff check on this flow"

## What is needed?

- **Figma frame URL** — the specific frame, section, or flow to check
- **`FIGMA_ACCESS_TOKEN`** — required for private files. Set in environment with `files:read` and `variables:read` scopes only (no write or delete permissions). If missing, a friendly setup flow will guide you through saving it — you won't need to do this again. If present but invalid or missing the `variables:read` scope, the skill stops and tells you what to fix.
- **Notion MCP** — must be configured to access the RemotePass workspace. Used to read DS component documentation and foundations (colour, typography, spacing, layout).

## Fixed resources

These are always referenced — do not ask the user for them:

- **RemotePass DS Figma file:** `https://www.figma.com/design/68BjBAp23kbcFrNQ9bK6jP/RemotePass-Design-System`
- **RemotePass DS Notion docs:** `https://www.notion.so/remotepass/RemotePass-Design-System-254c5c4e315080bc9db4f3bc75fa129a`

## How does it work?

1. **Check inputs and token**

   If the Figma URL is missing, ask for it.

   Token flow:
   - **If `FIGMA_ACCESS_TOKEN` is not set:** show the friendly collection flow —
     > "Don't worry, Nourdine thought of this 👋 I need a Figma access token to read the file. Two options:
     > **A** — Paste your token here and I'll save it automatically. You won't need to do this again.
     > **B** — Save it yourself: open `~/.claude/settings.local.json` and add `"FIGMA_ACCESS_TOKEN": "your-token-here"` under the `"env"` key."

     If the user chooses A: write the token to `~/.claude/settings.local.json` under `env.FIGMA_ACCESS_TOKEN`, then continue.

   - **If `FIGMA_ACCESS_TOKEN` is set:** call `GET /v1/me` to verify it is valid —
     ```bash
     curl "https://api.figma.com/v1/me" -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
     ```
     If the response is not 200, stop and tell the user their token is invalid or expired — they need to generate a new one.

   - **Scope check:** call `GET /v1/files/{file_key}/variables/local` to verify the token has `variables:read` scope —
     ```bash
     curl "https://api.figma.com/v1/files/{file_key}/variables/local" \
       -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
     ```
     If the response is 403, stop and tell the user to regenerate their token with `variables:read` scope added.

2. **Load DS reference material**

   In parallel:
   - Fetch the Notion DS root page and navigate to relevant sections (foundations: colour, typography, spacing, layout; and any component pages relevant to what's in the frame)
   - Fetch canonical component names from the RemotePass DS Figma file using a two-step lookup — avoids pulling 4,700+ icon results that bury UI components:

     **Step 1** — fetch the file structure to identify the COMPONENTS page(s):
     ```bash
     curl "https://api.figma.com/v1/files/68BjBAp23kbcFrNQ9bK6jP?depth=1" \
       -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
     ```
     From the response, find pages whose name contains "Component" (case-insensitive). Collect their node IDs.

     **Step 2** — fetch component nodes directly from those pages:
     ```bash
     curl "https://api.figma.com/v1/files/68BjBAp23kbcFrNQ9bK6jP/nodes?ids={components_page_ids}&depth=2" \
       -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
     ```
     Extract component names and structure from this targeted response only.

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

   Skip any node where `visible === false` — do not descend into hidden layers. This applies to all extraction above, including variable bindings and hardcoded value detection.

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

   ### Modes & themes
   Dark mode is a theme variant, not a breakpoint — check it separately for every frame:
   - **Light** — variant present and complete for each frame
   - **Dark** — variant present and complete for each frame

   Fail if either variant is absent for any frame. Do not treat dark mode as optional.

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
   - **Skeleton / page-level loading** — placeholder layout shown while the page or section loads
   - **Button loading** — spinner or disabled state on a CTA during an async action
   - **Component-level loading** — data-fetching components (combobox, dropdown, table, select) that have their own loading state while fetching options or results
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
   - When checking for hardcoded fills, apply the following exclusions:
     - **Hidden layers** — skip any node where `visible === false`. Do not report hardcoded fills on hidden layers or their children.
     - **Flag icon components** — skip `INSTANCE` nodes whose name matches flag icon patterns (e.g. country flags such as `flag-us`, `flag-gb`, `Flag / US`, `Flag / GB`). These use locale-specific colors by design. Do not flag hardcoded fills on these instances or their children.
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

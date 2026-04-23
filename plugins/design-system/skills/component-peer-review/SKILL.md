---
title: Component Peer Review
description: Peer review a DS component — inspect Figma structure via REST API, cross-check shadcn, Radix, and the RemotePass DS Notion docs, audit tokens and naming, review the component Notion documentation, then present findings
version: 1.1.2
requires: |
  - Figma component URL (required) — the component set to review
  - Notion documentation URL (required) — the component's doc page
  - FIGMA_ACCESS_TOKEN environment variable — for REST API access
  - Notion MCP connected — for reading Notion pages and optionally writing findings
allowed-tools: WebFetch, Read, Bash, Edit, Write, mcp__claude_ai_Notion__notion-fetch, mcp__claude_ai_Notion__notion-search, mcp__claude_ai_Notion__notion-update-page
argument-hint: "[figma-url] [notion-url]"
---

## What is this about?

Runs a full peer review of a design system component before it's marked ready for dev. Inspects the Figma component structure via the REST API, cross-checks against shadcn, Radix UI, and the RemotePass DS Notion documentation, audits token bindings and naming conventions, checks DS compliance, then reviews the component's Notion documentation for completeness, accuracy, and formatting. Presents all findings and offers to write them to a Notion page.

## What is the value?

Catches issues that are invisible to the author — hardcoded values, naming that won't map to code, missing states, and doc sections that reference the wrong property names. Saves engineering rounds by surfacing these before handoff.

## What does it do?

- Figma inspection via REST API — structure, variants, token bindings
- Cross-checks against shadcn, Radix UI, and the RemotePass DS Notion docs
- DS compliance audit — verifies all fills, strokes, spacing, and text styles are bound to DS variables and tokens (no hardcoded values)
- Naming review using Button as the canonical DS reference
- Notion doc review — structure, accuracy, references, and formatting
- Numbered findings with severity tags: `[fix]`, `[improve]`, `[minor]`
- Offers to write findings to a user-provided Notion page

## When to call it?

- "Peer review this component" + Figma URL + Notion URL
- "Review the Badge component before I mark it ready for dev"
- "Can you check the Figma and Notion docs for the DatePicker?"
- "Run a peer review on this" + links

## What is needed?

- **Figma component URL** (required) — the component set to review
- **Notion documentation URL** (required) — the component's doc page
- **`FIGMA_ACCESS_TOKEN`** — set in environment with `files:read` and `variables:read` scopes only (no write or delete permissions). If missing, a friendly setup flow will guide you through saving it — you won't need to do this again. If present but invalid or missing the `variables:read` scope, the skill stops and tells you what to fix.
- **Notion MCP** — must be configured to access the RemotePass workspace.

## Fixed resources

These are always referenced — do not ask the user for them:

- **RemotePass DS Figma file:** `https://www.figma.com/design/68BjBAp23kbcFrNQ9bK6jP/RemotePass-Design-System`
- **RemotePass DS Notion docs:** `https://www.notion.so/remotepass/RemotePass-Design-System-254c5c4e315080bc9db4f3bc75fa129a`

## How does it work?

1. **Collect inputs and verify connections**

   Check what was provided in the arguments. If either URL is missing, ask for it before proceeding:
   - **Figma component URL** — the component set to review
   - **Notion documentation URL** — the component's doc page

   Then verify token and connections:
   - **If `FIGMA_ACCESS_TOKEN` is not set:** show the friendly collection flow —
     > "Don't worry, Nourdine thought of this 👋 I need a Figma access token to read the file. Two options:
     > **A** — Paste your token here and I'll save it automatically. You won't need to do this again. Note: the token must have `files:read` and `variables:read` scopes — no write or delete permissions.
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

   - Confirm Notion MCP is connected by making a lightweight call (`mcp__claude_ai_Notion__notion-fetch` with the page ID). If it fails, tell the user: "Notion MCP is not connected — please check your MCP configuration before running this skill."

   Do not proceed until both URLs are provided and both connections are confirmed.

2. **Extract IDs**
   - From the Figma URL: file key and node ID (convert dashes to colons, e.g. `4605-4156` → `4605:4156`)
   - From the Notion URL: page ID

3. **Load reference material** (in parallel)

   - Fetch shadcn docs: `https://ui.shadcn.com/docs/components/{component-name}`
   - Fetch Radix UI docs: `https://www.radix-ui.com/primitives/docs/components/{component-name}` (if a primitive exists)
   - Fetch the RemotePass DS Notion root page and navigate to the relevant component and foundation pages (colour, typography, spacing, layout)
   - Fetch the **Button** component from the DS Figma file as the canonical naming reference:
     ```bash
     curl "https://api.figma.com/v1/files/68BjBAp23kbcFrNQ9bK6jP/nodes?ids={button_node_id}&depth=3" \
       -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
     ```
     From Button, establish: property casing (PascalCase), boolean naming patterns (`Show X` / `Has X`), size values (`xs/sm/default/lg` lowercase), state values (`Default/Hover/Focus/Disabled` PascalCase).

4. **Inspect the component via Figma REST API**
   ```bash
   curl "https://api.figma.com/v1/files/{file_key}/nodes?ids={node_id}&depth=5" \
     -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
   ```

   Extract:
   - Component name and type (COMPONENT_SET, FRAME, or other)
   - If the node is a **FRAME**, look inside for the actual COMPONENT_SET children — do not treat the frame itself as the component
   - All variant properties and their values (from `componentPropertyDefinitions`)
   - All slot properties (INSTANCE_SWAP), boolean properties, text properties
   - Token bindings (`boundVariables`) per layer

   **Token audit accuracy rules:**
   - `boundVariables` with an empty string value (`""`) means the variable ID wasn't captured — not confirmation of a hardcoded value. Cross-check the actual pixel value before flagging.
   - `boundVariables` on the component SET level does not reflect what's inside each variant — do a second pass on individual variant children if needed.
   - `cornerRadius: 0` and `rectangleCornerRadii: [0,0,0,0]` with no binding are **not violations** — zero is the default.
   - Only flag non-zero fills, spacings, or radii with no variable binding.
   - **External library tokens** have a long hash prefix before `/` (e.g. `VariableID:2348e5af.../1699:241`). **Local tokens** are short numeric (e.g. `VariableID:132:42`). Flag external tokens separately — do not treat them as violations.

5. **Figma review** — produce numbered findings for:
   - **Structure** — does it match shadcn's sub-component model? Are slots used correctly? Any redundant variants that could be a boolean (or vice versa)?
   - **Naming** — compare every property name, variant value, and slot name against DS conventions from step 3. State the exact rename for each flag. Do NOT flag `#id` suffixes (e.g. `Root#4900:0`) unless they cause a real conflict.
   - **Tokens** — apply accuracy rules from step 4. Only flag verified non-zero unbound values; list the actual pixel value next to each (e.g. `gap: 8px — no token binding`). Flag external library tokens separately.
   - **Scalability** — missing states present in shadcn, properties that will be hard to maintain, anything an engineer can't map cleanly to code.

6. **DS compliance audit**

   Before reviewing the Notion documentation, verify that all fills, strokes, spacing values, and text styles in the component are bound to DS variables and tokens with no hardcoded values. Cross-reference the RemotePass DS Notion docs (foundations: colour, typography, spacing) and the DS Figma file to confirm correct token usage.

   Flag any layer where:
   - A fill or stroke has a raw hex/rgba value instead of a bound colour token
   - A spacing, padding, or gap value has a raw pixel value instead of a bound spacing token
   - A text layer uses a raw font size, weight, or line-height instead of a bound text style

7. **Fetch and review the Notion documentation**

   Fetch the component's Notion page using `mcp__claude_ai_Notion__notion-fetch`. Also fetch the **Button** and **Checkbox** reference pages to compare structure and formatting.

   Review against the required page structure (in order):
   0. **Preview image** — a visual reference image must appear at the very top of the page, before `## Description`. Flag as `[fix]` if absent.
   1. `## Description` — 1–2 sentences, no inline Figma link
   2. `## Changelog` — table: Date / Designer / Change
   3. `---`
   4. `## References` — shadcn link + Radix primitive link (or "no primitive" note). Fetch each URL to confirm it resolves before flagging it as broken.
   5. `---`
   6. `## Deviations from shadcn` — yellow callout per structural deviation, or single green "perfect match" callout. Structural deviations only — visual/styling differences (border radius, padding, spacing, colors, tokens) are NOT deviations.
   7. `---`
   8. `## Variants & Properties` — one `###` sub-section per sub-component, 3-column table (Property / Values / Notes). Property names must match exact Figma names from step 4.
   9. `---`
   10. `## RemotePass Use Cases` — "Add examples here" placeholder is expected, don't flag it
   11. `---`
   12. `## Do's & Don'ts` — `<columns>` with two explicit `<column>` children: all green callouts left, all red callouts right. Never interleaved.

   Produce numbered findings for: **Structure**, **Accuracy**, **References**, **Formatting**.

8. **Present the full review report**

   ```
   ## Peer Review — [Component Name]

   ### Figma

   **Structure**
   1. [fix/improve/minor] [specific issue] → [exact action]
   ✅ Structure — no issues.

   **Naming**
   1. [fix] Rename `"OldName"` → `"NewName"` — [reason]
   ✅ Naming — no issues.

   **Tokens**
   1. [fix] `[layer name]`: [property] = [actual pixel value], no token binding → bind to `[token]`
   ✅ No external library tokens.

   **Scalability**
   1. [improve] Missing `[State]` variant — present in shadcn, will likely be needed
   ✅ Scalability — no concerns.

   **DS Compliance**
   1. [fix] `[layer name]`: fill = #1A1A1A, no token binding → bind to `[colour token]`
   ✅ DS Compliance — all values bound to tokens.

   ---

   ### Notion Documentation

   **Structure**
   1. [fix] Missing `## [Section]` section
   ✅ Structure — no issues.

   **Accuracy**
   1. [fix] Variants & Properties table lists `"[wrong name]"` — actual Figma prop is `"[correct name]"`
   ✅ Accuracy — no issues.

   **References**
   1. [fix] shadcn link points to [wrong component] → should be [correct URL]
   ✅ References — no issues.

   **Formatting**
   1. [minor] `## Do's & Don'ts` uses interleaved callouts instead of two-column layout → restructure
   ✅ Formatting — no issues.
   ```

   Severity: `[fix]` = blocking · `[improve]` = should fix · `[minor]` = cosmetic

   If a section is clean, always write `✅ [Section name] — no issues.` — never omit it silently.

9. **Offer to write findings to Notion**

   After presenting the report, ask:

   > "Would you like me to write these findings to a Notion page? If so, share the link and I'll populate it."

   If the user provides a page URL, extract the page ID and write the findings using `mcp__claude_ai_Notion__notion-update-page`. Do not create new Notion pages. Do not modify the component's documentation page without explicit confirmation.

## Key references

- Figma DS file key: `68BjBAp23kbcFrNQ9bK6jP`
- Figma DS file URL: `https://www.figma.com/design/68BjBAp23kbcFrNQ9bK6jP/RemotePass-Design-System`
- Figma API token: `$FIGMA_ACCESS_TOKEN`
- RemotePass DS Notion docs: `https://www.notion.so/remotepass/RemotePass-Design-System-254c5c4e315080bc9db4f3bc75fa129a`
- shadcn docs base: `https://ui.shadcn.com/docs/components`
- Radix UI docs base: `https://www.radix-ui.com/primitives/docs/components`
- Button and Checkbox (Notion): canonical reference pages for structure and formatting
- External token IDs: long hash prefix before `/` (e.g. `VariableID:2348e5af.../1699:241`)
- Local token IDs: short numeric (e.g. `VariableID:132:42`)
- `cornerRadius: 0` with no binding = not a violation
- `rectangleCornerRadii: [0,0,0,0]` with no binding = not a violation

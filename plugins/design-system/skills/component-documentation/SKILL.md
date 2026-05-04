---
title: Component Documentation
description: Full workflow — inspect a Figma component via REST API, cross-check shadcn, confirm findings, then write structured documentation to a Notion page
version: 1.2.1
requires: |
  - Figma component URL (required) — the component set to document
  - Notion page URL (required) — an empty page the user has already created for this component
  - FIGMA_ACCESS_TOKEN environment variable — for REST API access
  - Notion MCP connected — for reading and writing Notion pages
allowed-tools: WebFetch, Read, Bash, Edit, Write, mcp__claude_ai_Notion__notion-fetch, mcp__claude_ai_Notion__notion-search, mcp__claude_ai_Notion__notion-update-page
argument-hint: "[figma-url] [notion-url]"
---

## What is this about?

Full documentation workflow for a RemotePass design system component. Inspects the component via the Figma REST API, cross-checks against shadcn and Radix UI, presents findings for confirmation, then writes structured documentation to the provided Notion page in the exact format the DS uses.

## What is the value?

Documentation written without inspecting the actual Figma data drifts from reality. This skill reads the component directly, presents what it finds for designer confirmation, then writes to Notion — so docs match what was actually built.

## What does it do?

- Figma REST API inspection
- shadcn + Radix cross-check for structural deviations
- Findings confirmation before writing — designer can correct anything
- Figma improvement suggestions (naming, tokens, missing states)
- Writes the exact Notion page structure the DS uses (based on Radio Group reference)
- Sets Figma URL as a database property, not inline in content
- Custom component support — purple callout + omits Deviations section

## When to call it?

- "Document the Checkbox component for the design system"
- "Write DS docs for the new Tag component"
- "I need to add the DatePicker to Notion — document it"
- "Document this component following our standard format"

## What is needed?

- **Figma component URL** (required) — the component set to document
- **Notion page URL** (required) — an empty page you've already created for this component (place it next to Button, Radio Group, Checkbox in the Components section)
- **Figma REST API token** — set as `FIGMA_ACCESS_TOKEN` in the environment. Must be a **read-only token**: grant only `files:read` scope. Do not grant write, delete, or update permissions.
- **Notion MCP connected** — used to write the documentation page

## How does it work?

1. **Collect inputs and verify connections**

   Check what was provided in the arguments:
   - **Figma component URL** — the component set to document
   - **Notion page URL** — the empty page to write to

   If either is missing, ask before proceeding.

   Then verify token and connections:
   - **If `FIGMA_ACCESS_TOKEN` is not set:** show the friendly collection flow —
     > "Don't worry, Nourdine thought of this 👋 I need a Figma access token to read the file. Two options:
     > **A** — Paste your token here and I'll save it automatically. You won't need to do this again. Note: the token must have `files:read` scope — no write or delete permissions.
     > **B** — Save it yourself: open `~/.claude/settings.local.json` and add `"FIGMA_ACCESS_TOKEN": "your-token-here"` under the `"env"` key."

     If the user chooses A: write the token to `~/.claude/settings.local.json` under `env.FIGMA_ACCESS_TOKEN`, then continue.

   - **If `FIGMA_ACCESS_TOKEN` is set:** call `GET /v1/me` to verify it is valid —
     ```bash
     curl "https://api.figma.com/v1/me" -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
     ```
     If the response is not 200, stop and tell the user their token is invalid or expired — they need to generate a new one.

   - Confirm Notion MCP is connected by making a lightweight call (`mcp__claude_ai_Notion__notion-fetch` with the page ID). If it fails, tell the user: "Notion MCP is not connected — please check your MCP configuration before running this skill."

   Do not proceed until both URLs are provided and both connections are confirmed.

2. **Extract IDs**
   - From the Figma URL: extract the file key and node ID (convert dashes to colons, e.g. `4605-4156` → `4605:4156`)
   - From the Notion URL: extract the page ID

3. **Inspect the component via Figma REST API**
   ```
   curl "https://api.figma.com/v1/files/{file_key}/nodes?ids={node_id}&depth=3" \
     -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
   ```

   Use `depth=3` — enough to extract ComponentSet → Component → first-level children. Only go deeper if the tree is unusually nested.

   Extract:
   - Component name and type (COMPONENT_SET, FRAME, or other)
   - If the node is a **FRAME**, look inside for COMPONENT_SET children — do not treat the frame itself as the component
   - All variant properties and their values (from `componentPropertyDefinitions`)
   - All slot properties (INSTANCE_SWAP), boolean properties, text properties
   - Token bindings (`boundVariables`) per layer

   **Token audit accuracy rules:**
   - `boundVariables` with an empty string value (`""`) means the variable ID wasn't captured — not a hardcoded value. Cross-check the actual pixel value.
   - `cornerRadius: 0` and `rectangleCornerRadii: [0,0,0,0]` with no binding are not violations — zero is the default.
   - Corner radius bindings are stored in `boundVariables` under `rectangleCornerRadii`, not `cornerRadius`. Always check for `rectangleCornerRadii` — checking for `cornerRadius` will produce false positives on properly bound layers.
   - Only flag non-zero fills, spacings, or radii with no variable binding.
   - **External library tokens** have a long hash prefix before `/` (e.g. `VariableID:2348e5af.../1699:241`). **Local tokens** are short numeric (e.g. `VariableID:132:42`). Flag external tokens separately.

4. **Cross-check with shadcn and Radix UI** (WebFetch)
   - `https://ui.shadcn.com/docs/components/{component-name}`
   - `https://www.radix-ui.com/primitives/docs/components/{component-name}` (if a Radix component exists)

   Compare:
   - Are all shadcn states/variants present in Figma?
   - Does the component structure match the shadcn sub-component model?
   - **List every structural deviation** — added/renamed/removed sub-components, properties, variants, or states. Do NOT list visual/styling differences (border radius, padding, spacing, colors, token choices) — those are not deviations.
   - Note any Figma states that are RemotePass additions (custom, no shadcn equivalent).

5. **Present findings and wait for confirmation**

   Present:
   1. Component name + variants/properties table (what's in Figma)
   2. shadcn alignment — what matches, what's missing, what's custom
   3. Token audit — external library tokens or hardcoded non-zero values
   4. Structural deviations from shadcn (structural only)
   5. Questions if anything is unclear

   Wait for the designer to confirm or resolve issues before proceeding.

6. **Present Figma improvement suggestions** (separate from findings)

   Review for:
   - **Token hygiene** — hardcoded values or missing token bindings
   - **Naming** — property names that don't follow DS conventions (PascalCase, `Show X` booleans, `Default/Hover/Focus/Disabled` states)
   - **Missing states** — states present in shadcn but absent in Figma
   - **Structural gaps** — sub-components or composition patterns from shadcn that are missing
   - **Redundant variants** — overlapping or simplifiable variants

   Format as a numbered list with bold category labels. Note priority per item.

   Wait for the designer to acknowledge before proceeding to Notion.

7. **Write the Notion page**

   First, fetch the Radio Group reference page (`314c5c4e-3150-801a-a782-d29fe8cf30cb`) using `mcp__claude_ai_Notion__notion-fetch` to sample its exact block format. This prevents guessing Notion syntax (e.g. tables are `<table header-row="true">`, not markdown pipes).

   **Determine component type before writing:**
   - **shadcn component** → standard structure, include `## Deviations from shadcn`
   - **Custom component** (no shadcn equivalent) → add purple callout at the very top (before `## Description`), and **omit** `## Deviations from shadcn` entirely

   Purple callout for custom components:
   ```
   ::: callout {color="purple_bg"}
   **Custom Component** — Not part of shadcn/ui. No Radix UI primitive. Built exclusively for RemotePass.
   :::
   ```

   Write the page using `mcp__claude_ai_Notion__notion-update-page` with `replace_content`.

   **Page structure (in this exact order):**

   1. `## Description` — 1–2 sentences describing the component. No inline Figma link.
   2. `## Changelog` — table: Date / Designer / Change. Today's date, designer = Nourdine, change = "Initial documentation — [summary of variants and states]. Shadcn/ui alignment." For custom components: "Custom component, no shadcn alignment."
   3. `---`
   4. `## References` — shadcn/ui source link (`https://ui.shadcn.com/docs/components/{component-name}`) + Radix UI link (`https://www.radix-ui.com/primitives/docs/components/{component-name}`). If no Radix component: "No Radix UI component — shadcn [Component] is a pure styled component (HTML only)." For custom: "No shadcn/ui component — [Component] is a custom RemotePass component with no shadcn or Radix UI counterpart."
   5. `---`
   6. `## Deviations from shadcn` — **shadcn components only; omit entirely for custom components.** Structural deviations only (added sub-components, renamed/added/removed properties, extra or missing variants/states). Do NOT include visual/styling differences. If no structural deviations: single green callout: `<callout color="green_bg">**Perfect shadcn match** — No deviations. All variants and states map directly to shadcn behaviour.</callout>`. If deviations exist: one yellow callout per deviation: `<callout color="yellow_bg">**Category** — explanation + implementation note.</callout>`. Then `---`.
   7. `## Variants & Properties` — one `###` sub-section per sub-component, 3-column table (Property / Values / Notes)
   8. `---`
   9. `## RemotePass Use Cases` — just the text "Add examples here"
   10. `---`
   11. `## Do's & Don'ts` — two-column layout. All green (do) callouts in the left column. All red (don't) callouts in the right column. Never interleave:
       ```
       <columns>
         <column>
           ::: callout {icon="/icons/checkmark_green.svg" color="green_bg"}
             Do text here
           :::
         </column>
         <column>
           ::: callout {icon="/icons/clear_red.svg" color="red_bg"}
             Don't text here
           :::
         </column>
       </columns>
       ```

   **After writing page content**, also set the Figma URL as a database property using `mcp__claude_ai_Notion__notion-update-page` with `update_properties`:
   ```json
   { "Figma": "https://www.figma.com/design/..." }
   ```
   Do not include the Figma link inline in the page content.

## Some examples

- "Document the Badge component — here's the Figma link and the empty Notion page"
- "Write DS docs for the Combobox: [figma-url] [notion-url]"
- "Document this component following the standard format"

## Security notes

- Figma REST API read — non-destructive.
- Notion read (reference page) — non-destructive.
- Notion write (populate the user-provided page) — expected write, no additional confirmation needed.
- No changes to existing Notion pages without explicit confirmation.

## Key references

- Figma DS file key: `68BjBAp23kbcFrNQ9bK6jP`
- Figma DS file URL: `https://www.figma.com/design/68BjBAp23kbcFrNQ9bK6jP/RemotePass-Design-System`
- Figma API token: `$FIGMA_ACCESS_TOKEN`
- RemotePass DS Notion docs: `https://www.notion.so/remotepass/RemotePass-Design-System-254c5c4e315080bc9db4f3bc75fa129a`
- Radio Group reference page (Notion): `314c5c4e-3150-801a-a782-d29fe8cf30cb`
- shadcn docs base: `https://ui.shadcn.com/docs/components`
- Radix UI docs base: `https://www.radix-ui.com/primitives/docs/components`
- Designer name for changelog: Nourdine
- External token IDs: long hash prefix before `/` (e.g. `VariableID:2348e5af.../1699:241`)
- Local token IDs: short numeric (e.g. `VariableID:132:42`)
- `cornerRadius: 0` with no binding = not a violation
- `rectangleCornerRadii: [0,0,0,0]` with no binding = not a violation

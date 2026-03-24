---
title: Peer Review
description: Peer review a DS component — inspect Figma structure via REST API, compare to shadcn, audit tokens and naming, then review the Notion documentation
version: 1.0.0
requires: |
  - Figma component URL (required) — the component set to review
  - Notion documentation URL (required) — the component's doc page
  - Figma REST API access (used for component inspection)
allowed-tools: WebFetch, Read, Bash
argument-hint: "[figma-url] [notion-url]"
---

## Summary

Runs a full peer review of a design system component before it's marked ready for dev. Inspects the Figma component structure via the REST API, compares it against shadcn and Radix UI, audits token bindings and naming conventions, then reviews the Notion documentation for completeness, accuracy, and formatting.

## Why this is useful

Catches issues that are invisible to the author — hardcoded values, naming that won't map to code, missing states, and doc sections that reference the wrong property names. Saves engineering rounds by surfacing these before handoff.

## Key features

- Figma inspection via REST API — no bridge CLI required
- Shadcn and Radix comparison — flags structural deviations and missing states
- Token audit — only flags verified non-zero unbound values, not defaults
- Naming review — checks against DS conventions from already ready-for-dev components
- Notion doc review — structure, accuracy, references, and formatting
- Numbered findings with severity tags — `[fix]`, `[improve]`, `[minor]`
- Creates a workload ticket in Notion after the review

## Triggers

- "Peer review this component" + Figma URL + Notion URL
- "Review the Badge component before I mark it ready for dev"
- "Can you check the Figma and Notion docs for the DatePicker?"
- "Run a peer review on this" + links

## Prerequisites

- **Figma component URL** (required) — the component set to review
- **Notion documentation URL** (required) — the component's doc page
- **Figma REST API token** — set as `FIGMA_ACCESS_TOKEN` in the environment. Must be a **read-only token**: grant only `files:read` and `variables:read` scopes. Do not grant write, delete, or update permissions.

## Behavior & Instruction

1. **Collect inputs and verify connections**

   Check what was provided in the arguments. If either URL is missing, ask for it before proceeding:
   - **Figma component URL** — the component set to review (e.g. `https://www.figma.com/design/...?node-id=...`)
   - **Notion documentation URL** — the component's doc page in the design system

   Then verify access:
   - Confirm the **Figma REST API token** is available in the environment (`FIGMA_ACCESS_TOKEN`). If not, ask the user to set it — remind them it must be a read-only token (`files:read` + `variables:read` scopes only).
   - Confirm **Notion MCP is connected** by making a lightweight call (`mcp__claude_ai_Notion__notion-fetch` with the page ID). If it fails, tell the user: "Notion MCP is not connected — please check your MCP configuration before running this skill."

   Do not proceed to any subsequent step until both URLs are provided and both connections are confirmed.

2. **Extract IDs from the arguments**
   - From the Figma URL: extract the file key and node ID (convert dashes to colons, e.g. `4605-4156` → `4605:4156`)
   - From the Notion URL: extract the page ID

3. **Inspect the component via Figma REST API**
   ```
   curl "https://api.figma.com/v1/files/{file_key}/nodes?ids={node_id}&depth=5" \
     -H "X-Figma-Token: {token}"
   ```
   Extract:
   - Component name and type (COMPONENT_SET, FRAME, or other)
   - If the node is a **FRAME** (e.g. a docs frame), look inside it for the actual COMPONENT_SET children — do not treat the frame itself as the component
   - All variant properties and their values (from `componentPropertyDefinitions`)
   - All slot properties (INSTANCE_SWAP), boolean properties, text properties
   - Token bindings (`boundVariables`) per layer

   **Token audit accuracy rules:**
   - A `boundVariables` key with an empty string value (`""`) means the variable ID wasn't captured — it is **not** confirmation of a hardcoded value. Cross-check the actual pixel value before flagging.
   - `boundVariables` on the component SET level does not reflect what's inside each variant — do a second pass on individual variant children if needed.
   - `cornerRadius: 0` and `rectangleCornerRadii: [0,0,0,0]` with no binding are **not violations** — zero is the default.
   - Only flag non-zero fills, spacings, or radii with no variable binding.
   - **External library tokens** have a long hash prefix before `/` (e.g. `VariableID:2348e5af.../1699:241`). **Local tokens** are short numeric (e.g. `VariableID:132:42`). Flag external tokens separately from hardcoded values — do not treat them as violations.

4. **Fetch shadcn and Radix UI docs** (WebFetch)
   - `https://ui.shadcn.com/docs/components/{component-name}`
   - `https://www.radix-ui.com/primitives/docs/components/{component-name}` (if a primitive exists)
   - Extract: sub-components, all props/variants, standard states, default structure.

5. **Check DS naming conventions** using **Button** as the primary reference (it is the canonical ready-for-dev component). Fetch it via the Figma REST API and extract its property names, variant values, boolean patterns, and slot names. Establish: property casing (PascalCase), boolean naming patterns (`Show X` / `Has X`), size values (`xs/sm/default/lg` lowercase), state values (`Default/Hover/Focus/Disabled` PascalCase).

6. **Figma review** — produce numbered findings for:
   - **Structure**: does it match shadcn's sub-component model? Are slots used correctly? Any redundant variants that could be a boolean (or vice versa)?
   - **Naming**: compare every property name, variant value, and slot name against DS conventions from step 5; state the exact rename for each flag. Do NOT flag `#id` suffixes (e.g. `Root#4900:0`) unless they cause a real conflict or confuse engineers.
   - **Tokens**: apply accuracy rules from step 3 — only flag verified non-zero unbound values; list the actual pixel value next to each (e.g. `gap: 8px — no token binding`); flag external library tokens separately from hardcoded values
   - **Scalability**: missing states present in shadcn, properties that will be painful to maintain, anything an engineer can't map cleanly to code

7. **Fetch the Notion documentation page** using `mcp__claude_ai_Notion__notion-fetch` with the page ID from step 1. Also fetch the two reference pages (Button and Checkbox) to compare structure and formatting.

8. **Notion documentation review** — compare against Button and Checkbox reference pages. Required sections in order:
   1. `## Description` — 1–2 sentences, no inline Figma link
   2. `## Changelog` — table: Date / Designer / Change
   3. `---`
   4. `## References` — shadcn link + Radix primitive link (or "no primitive" note)
   5. `---`
   6. `## Deviations from shadcn` — yellow callout per structural deviation, or single green "perfect match" callout
   7. `---`
   8. `## Variants & Properties` — one `###` sub-section per sub-component, 3-column table (Property / Values / Notes)
   9. `---`
   10. `## RemotePass Use Cases` — "Add examples here" placeholder is expected, don't flag it
   11. `---`
   12. `## Do's & Don'ts` — `<columns>` with two explicit `<column>` children: all green left, all red right

   Produce numbered findings for:
   - **Structure**: every section present, correct order, correct `---` dividers
   - **Accuracy**: property names in tables must match exact Figma names from step 3; deviations must match shadcn reality from step 4; cross-check each listed deviation and remove any that are visual-only or no longer true
   - **References**: fetch each URL to confirm it resolves before flagging it as broken
   - **Deviations**: only structural deviations count (added/renamed/removed sub-components, properties, variants, states) — visual/styling differences (border radius, padding, spacing, colors, tokens) are NOT deviations
   - **Formatting**: callout syntax, table structure, column layout must match Button/Checkbox exactly

9. **Present the full review report** using this format:

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

10. **Create a workload ticket** in the Notion workload database using `mcp__claude_ai_Notion__notion-create-pages`:
   - Title: `[Component Name] — Peer Review`
   - Status: `In Progress`, Priority: `Mid`
   - Content: plain checklist, one line per finding, grouped by Figma and Notion, no explanations

   Share the ticket URL with the user after creating it.

   > Do not make any changes to Notion documentation without explicit confirmation.

## Examples

- "Peer review the Badge component" + Figma URL + Notion URL
- "Review this before I mark it ready for dev" + links
- "Run a peer review on the DatePicker"

## Security & Safety

- Figma and Notion reads are non-destructive.
- Only write operation is creating a workload ticket — no confirmation needed for that.
- Any edits to existing Notion documentation require explicit user confirmation.

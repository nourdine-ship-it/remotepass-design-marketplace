---
title: Copy Review
description: UX writing review against RemotePass UX Writing Guidelines — extracts Figma text layers, applies rule IDs by element type, delivers findings with corrected versions
version: 1.0.0
requires: |
  - Figma frame URL (required)
  - FIGMA_ACCESS_TOKEN (required for private files — set as env var with files:read scope)
  - Notion MCP (required — for loading the UX Writing Guidelines)
allowed-tools: WebFetch, Bash, Edit, Write, mcp__claude_ai_Notion__notion-fetch
argument-hint: "[figma-url]"
---

## What is this about?

A focused UX writing review grounded in the RemotePass UX Writing Guidelines. Reads every text layer in the Figma frame, classifies each string by element type, and checks it against the relevant rules from the guidelines. Every finding cites its rule ID and includes a corrected version.

## What is the value?

Copy issues are invisible in visual reviews. Passive voice, wrong placeholder format, title-cased headings, and vague CTAs all slip through — until engineering ships them. This skill catches them at the source, before handoff.

## What does it do?

- Loads the RemotePass UX Writing Guidelines from Notion (the authoritative source)
- Samples the RemotePass Authentication flow as a copy reference — to learn established patterns and apply them for consistency (not re-reviewed every run, just used to calibrate)
- Extracts all text layers from the Figma frame
- Classifies each string by element type (heading, label, CTA, placeholder, error, tooltip, etc.)
- Applies the relevant rule IDs per element type
- Checks for typos — because "Submti" ships faster than you think
- Delivers findings sorted by severity, each citing a rule ID, the offending copy, and a corrected version

## When to call it?

- "Check the copy on this frame"
- "Is the microcopy on this flow correct?"
- "Review the error messages in this modal"
- "Does this match our voice guidelines?"

## What is needed?

- **Figma frame URL** — the specific frame or flow to review
- **`FIGMA_ACCESS_TOKEN`** — required for private files. Set in environment with `files:read` scope only (no write or delete permissions). If missing, a friendly setup flow will guide you through saving it — you won't need to do this again. If present but invalid, the skill stops and tells you what to fix.
- **Notion MCP** — must be configured to access the RemotePass workspace. Used to load the UX Writing Guidelines.

## Fixed resources

These are always referenced — do not ask the user for them:

- **RemotePass UX Writing Guidelines (Notion):** `https://www.notion.so/remotepass/UX-Writing-Guidelines-34ac5c4e315081af914eedcf96a37688`
- **RemotePass Authentication flow (Figma):** `https://www.figma.com/design/ogBNZwwCeLGcDWrZVfHqRQ/Client---Worker---Authentication?node-id=91-1473` — used as a copy pattern reference, not re-reviewed every run

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

2. **Load the UX Writing Guidelines**

   Fetch the RemotePass UX Writing Guidelines using `mcp__claude_ai_Notion__notion-fetch` with the page ID `34ac5c4e-3150-81af-914e-edcf96a37688`. This is the authoritative rule set — do not rely on memory or approximations. Keep the full rule table in context for step 6.

3. **Sample the Authentication flow for copy patterns**

   Fetch the Authentication reference frame to calibrate copy patterns. Use `depth=10` to capture deeply nested text layers inside components:
   ```bash
   curl "https://api.figma.com/v1/files/ogBNZwwCeLGcDWrZVfHqRQ/nodes?ids=91:1473&depth=10" \
     -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
   ```
   Walk the full node tree and collect every text layer where `visible !== false`. If a component instance contains nested text layers that are truncated by depth, fetch that instance node separately:
   ```bash
   curl "https://api.figma.com/v1/files/ogBNZwwCeLGcDWrZVfHqRQ/nodes?ids={instance_node_id}&depth=10" \
     -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
   ```
   From all collected text: infer established patterns — placeholder format, CTA phrasing, error message structure, label style, heading length. Use these patterns to inform findings — flag copy in the reviewed frame that deviates from them even if no explicit rule is broken.

4. **Extract IDs from the Figma URL**
   - File key: path segment after `/design/` or `/file/`
   - Node ID: `node-id` query param — convert dashes to colons (e.g. `4605-4156` → `4605:4156`)

5. **Fetch the frame from the Figma REST API**

   Use `depth=10` to capture deeply nested text layers inside components:
   ```bash
   curl "https://api.figma.com/v1/files/{file_key}/nodes?ids={node_id}&depth=10" \
     -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
   ```
   Walk the full node tree and collect every text layer where `visible !== false`. If a component instance contains nested text layers truncated by depth, fetch that instance node separately using the same pattern as step 3. Do not proceed to classification until all visible text is accounted for.

6. **Classify text layers by element type**

   For each text layer, infer its element type from context (layer name, component name, nesting position):

   | Element type | Applicable rules |
   |---|---|
   | Page / section / modal / step title | `HEAD-*` |
   | Field label | `LABEL-*` |
   | Placeholder | `PLACE-*` |
   | Button / CTA | `CTA-*` |
   | Inline link | `LINK-*` |
   | Helper text (below a field) | `HELP-*` |
   | Inline field error | `ERR-*` |
   | Toast title or body | `TOAST-*` |
   | Banner title or body | `BANNER-*` |
   | Checkbox or radio label | `CHECK-*` |
   | Tooltip | `TOOL-*` |
   | Tag or badge | `TAG-*` |
   | Nav item | `NAV-*` |
   | Empty state | `EMPTY-*` |
   | Loading state | `LOAD-*` |
   | Success state | `SUCC-*` |
   | Modal or dialog | `MODAL-*` |
   | Destructive action modal | `DEST-*` |

   Apply global rules to all text regardless of type: `CASE-*`, `PUNCT-*`, `VOICE-*`, `VOCAB-*`. Also apply `NUM-*`, `PLUR-*`, `TRUNC-*` to any text containing numbers, currencies, dates, or truncated strings.

7. **Apply the rules and check for typos**

   For each classified element, apply every rule scoped to its type from the guidelines loaded in step 2. Cross-reference patterns from the Authentication flow (step 3) — flag deviations even if no explicit rule is broken.

   Also scan every text layer for typos. Flag any misspelling with the corrected word.

   When a rule fails or a typo is found: note the location, the current copy, the rule ID (or "Typo"), and write the corrected version.

8. **Output findings sorted by severity**

   Group all issues into:
   - **Critical** — misleading or broken copy that would cause a user to fail a task
   - **High** — wrong pattern, passive voice, vague CTA, broken placeholder or error rule
   - **Medium** — word case error, punctuation, vocabulary violation, or tone mismatch
   - **Low** — typos, polish, minor rewording suggestions

   For each issue, provide enough context for the designer to locate the element without hunting:
   ```
   [RULE-ID]
   Where: [page name] → [frame or section name] → [layer name or element description]
   Current: "[exact copy as written]"
   Issue: [what rule it breaks or pattern it deviates from]
   Fix: "[corrected version]"
   ```

   If no issues found: "Hark — not a single comma out of place. Shakespeare himself would've shipped this. ✓"

## Key references

- UX Writing Guidelines (Notion): `34ac5c4e-3150-81af-914e-edcf96a37688`
- Authentication flow (Figma): file key `ogBNZwwCeLGcDWrZVfHqRQ`, node `91:1473`
- Rule ID prefix reference: `CASE`, `PUNCT`, `VOICE`, `HEAD`, `LABEL`, `PLACE`, `CTA`, `LINK`, `HELP`, `ERR`, `TOAST`, `BANNER`, `CHECK`, `TOOL`, `TAG`, `NAV`, `EMPTY`, `LOAD`, `SUCC`, `MODAL`, `DEST`, `TRUNC`, `PLUR`, `NUM`, `VOCAB`, `A11Y`, `L10N`

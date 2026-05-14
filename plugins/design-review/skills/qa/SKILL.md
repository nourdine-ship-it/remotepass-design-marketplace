---
title: Design Review
description: Structured critique across 4 UX dimensions — extracts Figma layer data, delivers actionable feedback sorted by severity
version: 1.5.3
requires: |
  - Figma frame URL (required)
  - FIGMA_ACCESS_TOKEN (required for private files — set as env var with files:read scope)
allowed-tools: WebFetch, Bash, Edit, Write
argument-hint: "[figma-url]"
---

## What is this about?

Structured, honest critique of a design across four dimensions. Extracts the actual Figma layer tree — text content, component names, nesting, states — then delivers specific, actionable findings sorted by severity.

## What is the value?

Critique without a shared framework produces vague, inconsistent feedback. Reading the Figma layer tree directly means every finding is grounded in what's actually in the file, not assumptions about the design.

## What does it do?

- Extracts layer structure, text layers, component instances, and nesting from Figma
- Reviews across four fixed dimensions to ensure full coverage
- Delivers one concrete fix per issue, sorted by severity

## When to call it?

- "Review this design before I share it with the team"
- "Give me feedback on this flow — I'm not sure about the hierarchy"
- "Quick critique of this modal before the crit"
- "I got vague feedback from the PM, help me pressure-test it"

## What is needed?

- **Figma frame URL** — the specific frame, screen, or flow to review
- **`FIGMA_ACCESS_TOKEN`** — required for private files. Set in environment with `files:read` scope only (no write or delete permissions). If missing, a friendly setup flow will guide you through saving it — you won't need to do this again. If present but invalid, the skill stops and tells you what to fix.

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

   Skip any node where `visible === false` — do not descend into hidden layers.

4. **Review across 4 dimensions**

   - **Clarity** — Is it immediately obvious what to do and why? Are labels and CTAs unambiguous?
   - **Hierarchy** — Does the structure guide attention in the right order? Are primary and secondary actions visually distinct?
   - **Friction** — Where might a user hesitate, get confused, or drop off? Unnecessary steps or unclear inputs?
   - **Consistency** — Are patterns and interactions coherent with the rest of the product?

5. **Output findings sorted by severity**

   Output one table per dimension. Within each dimension, list issues in the table then follow with 1–2 brief ✅ lines for notable things that are done well. If a dimension has no issues, show only the ✅ lines. Always include at least one ✅ line per dimension — never leave a dimension entirely silent.

   For each finding: reference the exact layer name, text string, or component. Give one concrete fix.

   ```
   ## Design Review — [Frame name]

   **Clarity**
   | Severity | Finding | Fix |
   |----------|---------|-----|
   | 🔴 Critical | [specific finding] | [concrete fix] |
   | 🟠 High | [specific finding] | [concrete fix] |

   ✅ [Notable thing done well.]

   ---

   **Hierarchy**
   | Severity | Finding | Fix |
   |----------|---------|-----|
   | 🟡 Medium | [specific finding] | [concrete fix] |

   ✅ [Notable thing done well.]

   ---

   **Friction**
   ✅ [No major friction — one specific positive observation.]

   ---

   **Consistency**
   | Severity | Finding | Fix |
   |----------|---------|-----|
   | ⚪ Low | [specific finding] | [concrete fix] |

   ✅ [Notable thing done well.]
   ```

   Severity: 🔴 Critical = blocks use · 🟠 High = creates friction · 🟡 Medium = noticeable · ⚪ Low = polish

   Always close with:
   > ⚠️ Make your review complete — run /copy on this frame to check UX writing. Or don't, and risk shipping 'Cart' spelled as 'Fart'.
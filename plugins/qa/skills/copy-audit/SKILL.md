---
title: Copy Audit
status: placeholder
---

> **Placeholder** — This skill is not yet active. It will be set up once the RemotePass copy standards are documented.

---
title: Copy Audit
description: Check all UI text in a frame against RemotePass copy standards — flags tone, format, placeholder, and error copy issues
version: 1.0.0
requires: none
allowed-tools: WebFetch, mcp__figma-mcp-server__get_file_structure, mcp__figma-mcp-server__search_nodes
argument-hint: "[Figma link, screenshot, or paste the copy directly]"
---

## Summary

Audits all UI text in a design against RemotePass copy standards. Flags voice and tone violations, incorrect placeholder format, error messages that are too vague, character limit violations, jargon, and passive voice. Works from a Figma link, a screenshot, or pasted copy.

## Why this is useful

Copy inconsistency is invisible until it compounds. One designer writes "Enter your email", another writes "e.g. john@example.com" — both are in the product, neither is wrong in isolation, but together they erode trust. This skill catches those gaps early and keeps the product voice coherent.

## Key features

- Checks against `context/copy-standards.md` (RemotePass voice, placeholder rules, error format)
- Flags specific strings with the exact issue and a suggested fix
- Works from Figma link, screenshot, or pasted text
- Severity: Critical (wrong format / jargon) / Warning (tone drift) / Note (could be sharper)

## Triggers

- "Audit the copy on this screen"
- "Check if the text in this flow follows our standards"
- "Are there any copy issues with this design?"
- "Review the error messages in this form"
- "Copy check before handoff"

## Prerequisites

None for screenshot or pasted copy. If using a Figma link, the Figma bridge should be running for best results — but the skill can work without it if the designer pastes the copy manually.

## Behavior & Instruction

1. Ask the designer for one of:
   - **Figma link** to the frame or page (if bridge is running, extract all text layers)
   - **Screenshot** (extract visible text from the image)
   - **Pasted copy** (list of strings with their UI element type)

2. Load `context/copy-standards.md` as the reference.

3. For each string found, check:

   **Voice & tone**
   - Is it clear, warm, and direct?
   - Any jargon? (EOR-specific acronyms without explanation, technical terms the user wouldn't know)
   - Any passive voice?
   - Any filler words: "seamlessly", "powerful", "robust", "leverage", "streamline"?

   **Placeholder text**
   - Free text inputs: must use `e.g. [realistic example]` format
   - Selects/dropdowns: must use `Select [noun]` format
   - Never repeats the label. Never uses "Add value", "Enter text", "Type here"

   **Error messages**
   - Are they specific? (name the problem, suggest the fix)
   - Do they avoid blaming the user?
   - Are they accurate? ("Invalid input" is not acceptable)

   **Character limits**
   - Do any strings exceed recommended limits for their element type?
   - Button labels: 1–3 words, max 20 chars
   - Tooltip: max 80 chars
   - Toast: max 60 chars
   - Modal title: max 50 chars

   **Consistency**
   - Are parallel UI elements using consistent register and phrasing?
   - Are confirmation dialogs following the verb + noun pattern?

4. Output in this format:

   ```
   ## Copy Audit — [Screen/Page name]

   ### 🔴 Critical
   - **"[original string]"** ([element type])
     Issue: [what's wrong]
     Fix: "[suggested replacement]"

   ### 🟡 Warning
   - **"[original string]"** ([element type])
     Issue: [tone drift / inconsistency]
     Suggestion: "[suggested replacement]"

   ### 🔵 Note
   - **"[original string]"** ([element type])
     Consider: [optional sharpening]

   ---
   Summary: [N] critical · [N] warnings · [N] notes
   ```

5. If all copy passes, say so clearly with a one-line summary.

## Examples

- "Copy audit on the EOR onboarding flow — here's the Figma link"
- "Check the error messages in the payroll submission form"
- "Here's the copy for the termination flow — is it all on-brand?"

## Security & Safety

- Figma reads: auto-approved via hooks (if bridge running)
- No writes anywhere
- No confirmation needed — read-only skill

---
title: A11y Check
description: WCAG 2.1 AA accessibility review — contrast, touch targets, focus order, and text sizes from a Figma frame
version: 1.0.0
requires: figma-bridge
allowed-tools: WebFetch, mcp__figma-mcp-server__get_file_structure, mcp__figma-mcp-server__search_nodes, mcp__figma-mcp-server__get_styles
argument-hint: "[Figma link to frame or page]"
---

## Summary

Reviews a Figma frame for WCAG 2.1 AA accessibility compliance. Checks color contrast ratios, touch target sizes, minimum text sizes, focus order logic, and interactive element labelling using actual values from the Figma bridge — not visual estimation.

## Why this is useful

Accessibility issues caught at the design stage cost almost nothing to fix. The same issues caught in QA or production cost significantly more. This skill makes accessibility review a routine part of every designer's workflow, not an afterthought.

## Key features

- Reads actual color values and spacing from Figma (not estimates)
- Checks contrast ratios against WCAG 2.1 AA thresholds
- Flags touch targets smaller than 44×44pt
- Checks minimum text sizes and line heights
- Reviews focus order logic based on frame structure
- Flags missing labels on interactive elements

## Triggers

- "A11y check this screen"
- "Does this meet WCAG?"
- "Accessibility review before I hand this off"
- "Check the contrast and touch targets on this flow"
- "Any accessibility issues with this component?"

## Prerequisites

**The Figma CLI bridge is MANDATORY for this skill.** Actual color values and spacing must be read from Figma directly — visual inspection cannot produce accurate contrast ratios or spacing measurements.

Before proceeding, verify the bridge is running:
- Try calling a Figma bridge tool
- If unavailable, stop and tell the user: "This skill requires the Figma CLI bridge. Run `/connect-figma` first, then try again."

## Behavior & Instruction

1. Ask the designer for:
   - **Figma link** to the frame or page to review (required)
   - **Context**: is this a mobile frame, desktop, or both? (affects touch target threshold)

2. Extract file key and node ID from the Figma link.

3. Use the Figma bridge to read:
   - All text layers: font size, font weight, line height, color value
   - All background colors for each text layer
   - All interactive element sizes (buttons, inputs, links, icons with actions)
   - Frame and layer structure (for focus order assessment)
   - Any placeholder or hint text

4. Run checks across these dimensions:

   **Color contrast**
   - Normal text (<18pt regular / <14pt bold): minimum contrast ratio 4.5:1
   - Large text (≥18pt regular / ≥14pt bold): minimum contrast ratio 3:1
   - UI components and graphical elements: minimum 3:1 against adjacent color
   - Calculate the actual ratio for each text layer. Flag any that fail.

   **Touch targets (mobile)**
   - Minimum: 44×44pt for all interactive elements (buttons, inputs, icons with tap actions, links)
   - Flag anything smaller with the actual measured size

   **Text sizes**
   - Minimum body text: 16pt (mobile), 14pt (desktop)
   - Minimum secondary/label text: 12pt
   - Flag any text below threshold with its actual size and location

   **Focus order**
   - Based on the frame structure, does the logical reading/tab order match the visual flow?
   - Flag any elements that appear out of order or that would be skipped

   **Interactive element labels**
   - Do all buttons have visible text labels or accessible names?
   - Do all icon-only buttons have a tooltip or ARIA label defined in the design?
   - Do all form inputs have associated labels (not just placeholder text)?

   **Images and icons**
   - Are decorative images/icons marked appropriately?
   - Do meaningful images have alt text defined?

5. Output in this format:

   ```
   ## A11y Check — [Frame/Page name]
   Standard: WCAG 2.1 AA
   Figma: [link]

   ### 🔴 Fail
   - **Contrast** — "[Text layer]": [foreground] on [background] = [ratio]:1 (required: [threshold]:1)
   - **Touch target** — "[Element]": [W×H]pt (required: 44×44pt minimum)

   ### 🟡 Warning
   - **Text size** — "[Layer]": [size]pt at [location] — consider increasing to [recommended]pt
   - **Focus order** — "[Element]" appears after "[Element]" visually but may tab before it

   ### 🔵 Note
   - **Label** — "[Icon button]" has no visible label — add tooltip or confirm ARIA label in handoff notes

   ---
   Summary: [N] fails · [N] warnings · [N] notes
   WCAG 2.1 AA: [Pass / Fail]
   ```

6. If all checks pass, confirm with a one-line summary: "WCAG 2.1 AA — all checks passed."

## Examples

- "A11y check on the payroll confirmation screen"
- "Does the EOR onboarding flow meet WCAG?"
- "Check contrast and touch targets on this mobile design"

## Security & Safety

- Figma reads: auto-approved via hooks
- No writes anywhere
- No confirmation needed — read-only skill

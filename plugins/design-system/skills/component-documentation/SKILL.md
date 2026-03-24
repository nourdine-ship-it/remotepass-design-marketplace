---
title: Component Documentation
description: Write complete design system documentation — anatomy, variants, usage guidelines, content rules, and accessibility
version: 1.0.0
requires: none
allowed-tools: WebFetch
argument-hint: "[component name]"
---

## Summary

Writes complete, consistently structured documentation for a RemotePass design system component. Covers every section the team has standardised on — anatomy, variants, usage guidelines, content rules, accessibility, and related components — so the design system docs feel coherent regardless of who wrote any individual entry.

## Why this is useful

Inconsistent documentation is a design system smell. When docs are written by different people at different times without a shared structure, the DS becomes hard to trust. This skill enforces the standard format every time.

## Key features

- Fixed section structure — same format for every component, always
- Anatomy section forces completeness — naming every part surfaces things that haven't been agreed on
- "When not to use" is mandatory — the most skipped and most valuable section
- Purpose over description — "why it exists" not just "what it looks like"

## Triggers

- "Document the Checkbox component for the design system"
- "Write DS docs for the new Tag component"
- "I need to add the DatePicker to Notion — write the documentation"
- "Component docs for the Status Badge"
- "Document this component following our standard format"

## Prerequisites

None. Works best with a Figma link or screenshot showing all variants.

## Behavior & Instruction

1. If the user hasn't provided enough context, ask for:
   - **Component name:** as it appears in the design system
   - **Purpose:** what it is and what problem it solves (1–2 sentences)
   - **All variants:** visual or described — every variant that exists
   - **Usage context:** where in the product is it used? In what flows?
   - **Do/Don't examples:** (optional) existing examples of right and wrong usage
   - **Related components:** (optional) what does it relate to, compose with, or replace?
   - **Accessibility notes:** (optional) known requirements or patterns
   - **Figma link:** (optional) use WebFetch to extract any available context

2. Write documentation with the following sections in this exact order:

   **Overview**
   2–3 sentences: what it is, what it does, and why it exists in the design system — not just what it looks like. Distinguish purpose from description.

   **Anatomy**
   Label and describe each part of the component (container, label, icon, indicator, etc.). Numbered or bulleted list.

   **Variants**
   For each variant:
   - Name (as it appears in Figma)
   - When to use it
   - Visual distinguisher (what makes it look different)

   **Usage guidelines**

   *When to use:*
   3–5 specific scenarios where this is the right component.

   *When not to use:*
   3–5 specific scenarios with a suggestion for what to use instead.

   **Content guidelines**
   - Recommended character limits for text elements
   - Tone and language notes
   - What to do when content is too long

   **Accessibility**
   - Keyboard interaction
   - Screen reader expectations
   - Relevant ARIA patterns

   **Related components**
   List related components with a one-line note on when you'd choose one over the other.

3. Keep the tone professional but not dry — precise without being overly technical. This documentation is read by designers and developers alike.

## Examples

- "Write documentation for the Button component"
- "DS docs for the new Combobox — here's a Figma link with all variants"
- "Document the Alert/Banner component we just finalized"

## Security & Safety

- Read-only skill — WebFetch only for public Figma links.
- No writes, no confirmation needed.

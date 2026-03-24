---
title: Microcopy
description: Generate short UI strings — labels, errors, empty states, tooltips — with character counts and tone labels
version: 1.0.0
requires: none
allowed-tools: WebFetch
argument-hint: "[element type and context, e.g. 'error message for failed payment']"
---

## Summary

Generates short, precise UI strings for a single element — button labels, error messages, placeholder text, tooltips, empty states, confirmation prompts. Returns 5 variants with character count and tone label so the designer can scan and choose in under 30 seconds.

## Why this is useful

Microcopy is where decisions feel "small" but compound into how confident a user feels. This skill is optimised for speed — you describe the situation, Claude gives you options you can use immediately, already counted and labelled.

## Key features

- 5 variants per request — enough to see the option space without being overwhelming
- Character count per variant — no manual counting
- One-word tone label per variant (e.g. "reassuring", "neutral", "urgent")
- Parallel strings input — prevents register mismatch with surrounding UI

## Triggers

- "What should the submit button say on the payroll confirmation screen?"
- "Write a placeholder for the contractor rate input"
- "I need 5 options for the tooltip on the EOR fee field"
- "What's a good empty state label when there are no pending invoices?"
- "Error message for when a bank account fails verification"

## Prerequisites

None. Works out of the box.

## Behavior & Instruction

1. If the user hasn't provided full context, ask for:
   - **Element type:** button, tooltip, placeholder, empty state headline, error message, confirmation label, etc.
   - **Situation:** what is happening? (e.g. "a user has just deleted an item and cannot undo it")
   - **Character limit:** hard max. If none, say "no limit".
   - **Tone direction:** (optional) e.g. "direct and calm — don't alarm unnecessarily"
   - **Avoid:** any specific words or patterns to skip
   - **Parallel strings:** other labels in the same UI area for consistency (optional but valuable)

2. Write **5 variants**. Follow RemotePass voice: clear, warm, direct. No jargon, no filler.

3. For each variant, show on one line:
   - The string itself
   - Character count in parentheses
   - One-word tone label in italics

4. After the 5 variants, flag any that risk being too long for common screen sizes.

## Examples

- "Button label for the primary CTA on the EOR contract review screen"
- "Placeholder for the 'Reason for termination' textarea"
- "Error message when a worker's contract can't be saved due to missing fields"
- "Empty state for the SpendCards tab when no cards have been issued yet"

## Security & Safety

- Read-only skill — no tools called, no external writes.
- No confirmation needed.

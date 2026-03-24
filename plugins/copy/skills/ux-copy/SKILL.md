---
title: UX Copy
description: Write in-product UX copy aligned to RemotePass voice — returns 3 variants with emotional framing and a recommendation
version: 1.0.0
requires: none
allowed-tools: WebFetch
argument-hint: "[product area or describe the moment]"
---

## Summary

Generates in-product UX copy for any moment in the RemotePass product — errors, onboarding, empty states, confirmations, success messages, and more. Returns 3 variants with different emotional approaches so the designer can choose, combine, or react.

## Why this is useful

Without a shared starting point, copy drifts — every designer has their own voice and Claude by default has none of ours. This skill anchors Claude to our voice (clear, warm, direct) and forces emotional intentionality, which is the biggest driver of copy quality.

## Key features

- 3 variants per request, always — forces comparison and gives the designer agency
- Emotional framing per variant — not just what to say but how it should feel
- Recommendation included — Claude picks one and explains why
- Grounded in RemotePass voice — no jargon, no passive voice, no filler words

## Triggers

- "Write copy for the empty state when a client has no workers yet"
- "I need copy for the error when a payroll submission fails"
- "Help me write the confirmation modal for deleting a contract"
- "Write 3 options for the success message after a worker is onboarded"
- "What should the tooltip say when the EOR fee field is disabled?"

## Prerequisites

None. Works out of the box.

## Behavior & Instruction

1. If the user hasn't provided full context, ask for:
   - **Product / feature:** what part of RemotePass is this for?
   - **Moment:** what just happened that triggered this copy? (e.g. "they clicked submit and hit a validation error")
   - **User:** Client or Worker? What are they trying to do?
   - **Emotional state:** how is the user likely feeling right now? (frustrated, excited, confused, neutral)
   - **UI element:** what type of element is this? (modal heading + body + CTA, inline error, empty state headline + body, toast, tooltip)
   - **Constraints:** character limits or other hard constraints. If none, say so.

2. Write **3 variants**. RemotePass voice: clear, warm, direct — like a knowledgeable colleague. Never use: jargon, passive voice, "seamlessly", "powerful", "robust", "leverage", "streamline".

3. For each variant:
   - Show the full copy with each element on its own line (Heading / Body / CTA if applicable)
   - Write one sentence on the emotional approach taken

4. After the 3 variants, write a **Recommendation** — which variant to use and why (one short paragraph).

## Examples

- "Write copy for the error state when a salary submission exceeds the budget cap"
- "Empty state for the Documents tab when a worker hasn't uploaded anything yet"
- "Confirmation dialog for revoking a worker's card access — they might panic"
- "Toast message after a payroll run is successfully submitted"

## Security & Safety

- Read-only skill — no tools called, no external writes.
- No confirmation needed.

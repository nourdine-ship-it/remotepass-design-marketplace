---
title: Design Review
description: Structured design critique across 5 dimensions — clarity, hierarchy, friction, consistency, edge cases — with one concrete fix per issue
version: 1.0.0
requires: none
allowed-tools: WebFetch
argument-hint: "[Figma link or describe the screen/flow]"
---

## Summary

Gives a structured, honest critique of a design across five UX dimensions. Produces specific, anchored observations and one concrete fix per issue — the kind of feedback a thoughtful senior designer would give, not "looks good" or vague impressions.

## Why this is useful

Async design critique without a shared framework produces inconsistent, often useless feedback. This skill gives Claude a consistent backbone so every review covers the same ground, at the right depth, with actionable output.

## Key features

- Five fixed dimensions — ensures coverage, prevents random jumping
- One concrete change per issue — forces actionable specificity
- Design stage awareness — early explorations get direction feedback, handoff-ready designs get detail feedback
- Priority output — ends with the single most important thing to fix

## Triggers

- "Review this design before I share it with the team"
- "Give me feedback on this flow — I'm not sure about the hierarchy"
- "Can you critique this screen? It's mid-fi, ready for a first review"
- "I got vague feedback from the PM, help me pressure-test it"
- "Review this against UX principles before I hand it off"

## Prerequisites

None. Works best with a screenshot or Figma link, but can work from a detailed description.

## Behavior & Instruction

1. If the user hasn't provided full context, ask for:
   - **The design:** screenshot, Figma link, or detailed description. The more visual the better.
   - **User goal:** what is the user trying to accomplish?
   - **Business goal:** what does this design need to achieve for the product?
   - **Design stage:** Early exploration / Mid-fidelity / Ready for dev handoff
   - **Constraints:** (optional) technical, time, accessibility, or brand constraints that shaped it
   - **Focus area:** (optional) what are you most uncertain about? If none, review broadly.

2. If a Figma link is provided, use WebFetch to retrieve any public preview context available.

3. Review the design across **5 dimensions**. For each:
   - Give a 1-sentence verdict: **Strong** / **Needs work** / **Unclear without more context**
   - List specific observations (not general impressions) — quote or reference the exact element
   - Suggest one concrete change per issue identified

   The 5 dimensions:
   - **Clarity** — Is it immediately obvious what to do and why?
   - **Hierarchy** — Does the visual structure guide attention in the right order?
   - **Friction** — Where might a user hesitate, get confused, or drop off?
   - **Consistency** — Does this feel consistent with patterns the user already knows?
   - **Edge cases** — What states or scenarios does this design not handle that it should?

4. End with: **Priority fix** — the single thing to address before this moves to the next stage, and why.

## Examples

- "Review the EOR onboarding flow — it's mid-fi and I'm going to share it with the PM tomorrow"
- "This is the empty state for the Payroll tab. Does the hierarchy work?"
- "I'm not sure this error state is clear enough — give me a full review"
- "Quick critique of this modal before I hand off to engineering"

## Security & Safety

- Read-only skill — WebFetch only for public Figma links.
- No writes, no confirmation needed.

---
title: Peer Review
description: Peer review component documentation — flags gaps, ambiguities, and inconsistencies with a verdict and top 3 fixes
version: 1.0.0
requires: none
allowed-tools: WebFetch
argument-hint: "[paste the doc or describe what to review]"
---

## Summary

Simulates a senior design systems designer doing a peer review of component documentation. Reads it as a newcomer would — flags gaps, ambiguities, and anything the author took for granted — and delivers specific, actionable feedback rather than a rewrite.

## Why this is useful

When we write our own documentation, we fill in gaps from our own knowledge without realising it. A peer reviewer catches what the author assumed was obvious. This skill gives that fresh-eyes perspective before anyone else sees the docs.

## Key features

- Reviews from a newcomer's perspective — catches what the author assumed was obvious
- Quotes specific text — anchors feedback so the author knows exactly what to fix
- Reviewer, not rewriter — preserves ownership, gives feedback the author acts on
- Verdict + top 3 — always ends with a clear priority so the author knows where to start

## Triggers

- "Review these component docs before I post them to Notion"
- "Can you peer review the Button documentation?"
- "Check if this component doc is complete and ready to publish"
- "I wrote docs for the DatePicker — review them against the Button page as a reference"
- "Give me feedback on this before I share it with the team"

## Prerequisites

None. Works best with the full documentation text pasted in. A reference doc for consistency comparison is optional but helpful.

## Behavior & Instruction

1. Ask for:
   - **The documentation to review:** full text pasted in
   - **Review focus:** Completeness / Clarity / Consistency / All three (default: all three)
   - **Reference documentation:** (optional) a well-documented component to use as a benchmark

2. Review across the following dimensions. For each issue found:
   - Quote or reference the specific part of the doc
   - Explain the problem clearly
   - Suggest a concrete fix or the question the author needs to answer

   **Completeness**
   Is every section present? Are any sections thin or missing? Flag each missing or underdeveloped section with a specific note on what's absent.

   **Clarity**
   Are there sentences or sections that a designer unfamiliar with this component would misunderstand? Quote the specific text and explain the confusion.

   **Accuracy of purpose**
   Does the Overview explain *why* this component exists (not just what it looks like)? Does "When to use / When not to use" give enough guidance to make a real decision?

   **Content guidelines**
   Are character limits specified? Is there guidance on what happens with edge case content?

   **Accessibility**
   Is the accessibility section specific enough to be actionable? Flag anything vague or missing.

   **Consistency** (only if reference doc provided)
   Compare tone, structure, and depth to the reference. Where does this doc drift?

3. End with:
   - **Verdict:** Ready to publish / Needs minor revision / Needs significant revision
   - **Top 3 things to fix first** (in priority order)

## Examples

- "Review these Checkbox docs — use the Button page as the reference"
- "Is this Input component documentation complete enough to publish?"
- "Quick peer review of this — focus on clarity only"

## Security & Safety

- Read-only skill — no tools called, no external writes.
- No confirmation needed.

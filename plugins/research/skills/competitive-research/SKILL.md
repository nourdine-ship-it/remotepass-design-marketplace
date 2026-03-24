---
title: Competitive Research
description: Research how competitors handle a pattern or feature — returns a structured comparison table and synthesis of what to learn
version: 1.0.0
requires: none
allowed-tools: WebFetch, mcp__claude_ai_Notion__notion-fetch
argument-hint: "[pattern or feature to research, e.g. 'payroll approval flow']"
---

## Summary

Researches how competitors and relevant products handle a specific design pattern or feature. Returns a structured comparison table covering UX approach, key decisions, strengths, and weaknesses — plus a synthesis of what RemotePass should learn or avoid. Saves to Notion on request.

## Why this is useful

Design decisions made without competitive context risk reinventing the wheel or duplicating known failures. This skill makes competitive research fast enough to actually do — 10 minutes instead of 2 hours — and formats the output so it's immediately useful in a design brief or decision log.

## Key features

- Researches multiple competitors via WebFetch
- Structured comparison table per competitor
- Synthesis section: what to adopt, what to avoid, what RemotePass can do better
- Focused on UX patterns and decisions, not business or pricing
- Saves to Notion only when given a link

## Triggers

- "How do competitors handle the payroll approval flow?"
- "Competitive research on worker onboarding"
- "What does [Deel / Remote / Oyster] do for expense management?"
- "Research how other HR platforms handle document signing"
- "Comp analysis for the EOR contract flow"

## Prerequisites

None. WebFetch is used to gather publicly available product information.

## Behavior & Instruction

1. Ask the designer for:
   - **Pattern or feature to research**: be specific (e.g. "payroll run approval flow" not just "payroll")
   - **Competitors to include**: (e.g. Deel, Remote.com, Oyster, Rippling, Gusto) — or ask Claude to pick 4–5 relevant ones
   - **User type in focus**: Client (employer) or Worker (employee)?
   - **What you're trying to learn**: what decision is this research informing?

2. Use WebFetch to research each competitor:
   - Product pages, help docs, changelogs, design blogs, and app screenshots where publicly available
   - Focus on UX decisions: flow structure, key screens, copy patterns, interaction model

3. For each competitor, extract:
   - How they handle the pattern (flow summary)
   - Key UX decisions observed
   - What they do well
   - What they do poorly or what's missing

4. Output:

   **Competitive Overview — [Pattern name]**
   User focus: [Client / Worker]
   Competitors: [list]

   ```
   | Dimension | [Competitor 1] | [Competitor 2] | [Competitor 3] | RemotePass (current) |
   |---|---|---|---|---|
   | Flow structure | ... | ... | ... | ... |
   | Key UX decision | ... | ... | ... | ... |
   | Strengths | ... | ... | ... | ... |
   | Weaknesses | ... | ... | ... | ... |
   | Notable detail | ... | ... | ... | ... |
   ```

   **Synthesis**

   *What to adopt or be inspired by:*
   - [Specific pattern from a competitor worth learning from]

   *What to avoid:*
   - [Specific pattern that creates friction or is confusing]

   *Where RemotePass can do better:*
   - [Gap in the competitive landscape we could own]

   *Open questions for the design:*
   - [Things the research raised but didn't answer]

5. After presenting the output, ask:
   "Do you want to save this to Notion? If yes, share the page link."

6. **Do NOT create a Notion page independently.**

## Examples

- "How do Deel and Remote handle EOR contract creation? Research 4 competitors."
- "Competitive research on expense card management — Worker perspective"
- "How does Rippling handle bulk payroll approval?"

## Security & Safety

- WebFetch: read-only, public URLs only
- Notion writes: only when explicitly asked with a provided link
- No confirmation needed for the research itself — only for Notion writes

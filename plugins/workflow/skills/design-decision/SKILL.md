---
title: Design Decision
description: Document a design decision — the choice made, alternatives considered, rationale, and trade-offs — saves to Notion on request
version: 1.0.0
requires: none
allowed-tools: mcp__claude_ai_Notion__notion-fetch
argument-hint: "[describe the decision made]"
---

## Summary

Structures a design decision into a clear, referenceable record: what was decided, what alternatives were considered and why they were rejected, the rationale, the trade-offs, and the date. Makes async design communication easier and prevents relitigating the same decisions. Saves to Notion only when given a link.

## Why this is useful

Design decisions made verbally or in Slack disappear. When a decision gets questioned weeks later — by a PM, an engineer, or another designer — there's no record of the reasoning. This skill creates that record in 2 minutes instead of 20.

## Key features

- Structured format: decision, context, alternatives, rationale, trade-offs
- Captures who made the decision and when
- Flags if a decision is revisable vs. locked
- Saves to Notion only when given a link

## Triggers

- "Document this design decision"
- "Log why we chose this approach"
- "I made a call on the compensation layout — document it"
- "Record the rationale for using a drawer instead of a modal here"
- "Design decision: we're going with the top-down model for KSA"

## Prerequisites

None.

## Behavior & Instruction

1. Ask the designer for:
   - **The decision**: what was chosen? (e.g. "Use a drawer for the edit action, not a modal")
   - **Context**: what problem were you solving? What prompted this decision?
   - **Alternatives considered**: what other approaches did you think about?
   - **Why this one**: what made this the right choice over the alternatives?
   - **Trade-offs**: what does this decision give up or make harder?
   - **Revisability**: is this locked (hard to change later) or open to revisiting?
   - **Jira or Figma link**: (optional) for reference

2. If the designer gives a brief answer, ask follow-up questions to flesh out the alternatives and trade-offs — these are the most valuable parts.

3. Generate the decision record:

   ---

   **Design Decision — [Short title of the decision]**
   Date: [today's date]
   Designer: [ask if not obvious]
   Status: [Decided / Under review]
   Revisable: [Yes — easy to change / Yes — but costly / No — locked in]

   **Decision**
   [One sentence, clear and specific: "We will use X for Y."]

   **Context**
   [What problem were we solving? What prompted the decision? What constraints existed?]

   **Alternatives considered**

   | Option | Why considered | Why rejected |
   |---|---|---|
   | [Alternative 1] | [Reason it was on the table] | [Reason it was ruled out] |
   | [Alternative 2] | [Reason] | [Reason] |

   **Rationale**
   [Why the chosen approach is the right one given the context and constraints. Be specific — not just "it's simpler" but why simpler is the right call here.]

   **Trade-offs**
   [What does this decision make harder or give up? Be honest.]

   **References**
   - Jira: [link if provided]
   - Figma: [link if provided]

   ---

4. After presenting the record, ask:
   "Do you want to save this to Notion? If yes, share the page link and I'll add it."

5. **Do NOT create a Notion page independently.** Only post when given a direct link.

## Examples

- "Document the decision to use the top-down compensation model for KSA"
- "Log why we chose horizontal scroll for health insurance provider selection"
- "Record the decision: Continue button stays enabled, validate on submit only"

## Security & Safety

- Notion reads: auto-approved if needed for context
- Notion writes: only when explicitly asked with a provided link
- No confirmation needed for the document generation — only for Notion writes

---
title: Design Brief
description: Turn a Jira ticket into a structured design brief — problem, goals, constraints, success criteria, and open questions
version: 1.0.0
requires: mcp-jira
allowed-tools: mcp__claude_ai_Atlassian__getJiraIssue, mcp__claude_ai_Atlassian__searchJiraIssuesUsingJql, mcp__claude_ai_Notion__notion-fetch
argument-hint: "[Jira ticket key, e.g. RP-1234]"
---

## Summary

Reads a Jira ticket and generates a structured design brief: problem statement, user and business goals, constraints, success criteria, out-of-scope items, and open questions. Gives the designer a clear starting point before opening Figma. Saves to Notion only when given a link.

## Why this is useful

Designers often jump into Figma before fully understanding the problem. A brief forces clarity on the goal, the user, the constraints, and what success looks like — before a pixel is placed. This skill makes writing a brief fast enough to actually do on every ticket.

## Key features

- Reads Jira ticket automatically — no copy-pasting required
- Structured output: problem, goals, constraints, success criteria, out-of-scope, questions
- Flags ambiguities and missing information in the ticket
- Saves to Notion only when given a link

## Triggers

- "Write a design brief for RP-1234"
- "Turn this Jira ticket into a design brief"
- "I'm starting work on [ticket] — create the brief"
- "Design brief for the EOR termination flow"
- "Help me define the brief before I start designing"

## Prerequisites

Jira MCP must be configured. If the Jira tools are unavailable, stop and tell the user: "This skill needs the Jira MCP configured. Check `docs/setup.md` for instructions, or paste the ticket content directly."

## Behavior & Instruction

1. Ask the designer for:
   - **Jira ticket key** (e.g. RP-1234) or a link
   - **User type in scope**: Client, Worker, or both? (if not clear from the ticket)

2. Fetch the Jira ticket using `getJiraIssue`. Read:
   - Summary / title
   - Description (full)
   - Labels, components, priority
   - Any linked issues (epics, blockers, dependencies)
   - Reporter and assignee

3. If the ticket is thin or unclear, note what's missing and ask the designer to clarify before continuing.

4. Generate the design brief:

   ---

   **Design Brief — [Ticket title]**
   Jira: [RP-XXXX link]
   User: [Client / Worker / Both]
   Priority: [from Jira]
   Designer: [assignee or ask]

   **Problem statement**
   One paragraph. What is the problem this ticket is solving? Write it from the user's perspective, not the engineering perspective. If the ticket doesn't state a clear problem, derive it from context — and flag the assumption.

   **User goal**
   As a [Client / Worker], I want to [accomplish X], so that [outcome Y].

   **Business goal**
   What does RemotePass need this to achieve? (Revenue, retention, compliance, efficiency?)

   **Constraints**
   - Technical: [known technical limitations from the ticket or product context]
   - Time: [deadline if mentioned]
   - Scope: [what's explicitly included or excluded per the ticket]
   - Other: [compliance, brand, accessibility, other]

   **Success criteria**
   How will we know this design solved the problem? List 3–5 measurable or observable outcomes.

   **Out of scope**
   What is explicitly NOT being addressed in this ticket? (Prevents scope creep.)

   **Open questions**
   Things the brief couldn't answer from the ticket. These need answers before or during design.
   - [Question 1 — who can answer this?]
   - [Question 2 — who can answer this?]

   **References**
   - Jira: [link]
   - Related tickets: [any linked issues]

   ---

5. After presenting the brief, ask:
   "Do you want to save this to Notion? If yes, share the page link and I'll add it."

6. **Do NOT create a Notion page independently.** Only post when given a direct link.

## Examples

- "Design brief for RP-892 — EOR termination flow"
- "Turn this ticket into a brief: [Jira link]"
- "I'm starting the payroll run redesign — write the brief from RP-1104"

## Security & Safety

- Jira reads: read-only, no ticket modification
- Notion reads: auto-approved
- Notion writes: only when explicitly asked with a provided link
- No confirmation needed for the brief generation — only for Notion writes

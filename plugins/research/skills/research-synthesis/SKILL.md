---
title: Research Synthesis
description: Turn raw interview notes or research data into themes, pain points, and insights — saves to Notion on request
version: 1.0.0
requires: none
allowed-tools: mcp__claude_ai_Notion__notion-fetch, mcp__claude_ai_Notion__notion-search
argument-hint: "[paste notes or describe the research session]"
---

## Summary

Takes raw interview notes, usability test observations, or survey responses and synthesises them into structured themes, pain points, user needs, and key insights. Surfaces notable quotes. Saves to Notion only when explicitly given a link.

## Why this is useful

Raw research notes are only useful if they get synthesised. The synthesis step — grouping, theming, prioritising — is time-consuming and easy to skip under deadline pressure. This skill does the first pass so the designer can focus on interpreting, not sorting.

## Key features

- Identifies recurring themes across multiple sessions or data points
- Separates pain points, user needs, and opportunities
- Surfaces verbatim quotes worth keeping
- Flags surprising or unexpected findings
- Saves to Notion only when given a link — never independently

## Triggers

- "Synthesise these interview notes"
- "Turn this research into themes"
- "I ran 5 user tests — help me pull out the key findings"
- "Analyse this research data"
- "What are the main pain points from these sessions?"

## Prerequisites

None. User pastes notes, describes sessions, or shares a document link.

## Behavior & Instruction

1. Ask the designer for:
   - **The raw material**: interview transcripts, notes, survey responses, usability test observations — paste directly or describe
   - **Number of sessions/participants** (helps calibrate confidence in themes)
   - **User type**: Client, Worker, or mixed?
   - **Research goal**: what were you trying to learn?

2. Read all the material provided.

3. Synthesise into this structure:

   **Themes** (recurring patterns across multiple data points)
   For each theme:
   - Theme name (short, action-oriented)
   - Description: what does this pattern represent?
   - Evidence: how many sessions / participants mentioned this?
   - Representative quote (verbatim, with participant label if available)

   **Pain points** (specific frustrations or blockers)
   Bulleted list, most frequent first. Each with: the pain, the context, frequency.

   **User needs** (what users are trying to accomplish that the product isn't fully serving)
   Bulleted list. Each as: "Users need to [verb] so that [outcome]."

   **Opportunities** (implications for design)
   Based on the pain points and needs — what could be improved or built?

   **Surprising findings** (anything unexpected or that challenges assumptions)
   Flag these separately so they don't get buried.

   **Quotes to keep**
   3–5 verbatim quotes that best illustrate the most important findings.

4. After presenting the synthesis, ask:
   "Do you want to save this to Notion? If yes, share the page link."

5. **Do NOT create a Notion page independently.** Post only to a link the designer explicitly provides.

## Examples

- "Here are my notes from 6 worker interviews about the payroll experience — synthesise them"
- "Usability test observations from 4 sessions on the EOR onboarding — what are the themes?"
- "Survey responses from 20 clients about the dashboard — find the main pain points"

## Security & Safety

- Notion reads: auto-approved if needed for context
- Notion writes: only when explicitly asked with a provided link
- No confirmation needed for the synthesis itself — only for Notion writes

---
title: UX Audit
description: Scored usability review against Nielsen's 10 heuristics plus RemotePass-specific principles
version: 1.0.0
requires: none
allowed-tools: WebFetch, mcp__claude_ai_Notion__notion-fetch, mcp__claude_ai_Notion__notion-search
argument-hint: "[Figma link or screenshot + describe the user goal]"
---

## Summary

Runs a structured usability review of a screen or flow against Nielsen's 10 heuristics, scored 0–2 per dimension. Also checks against RemotePass-specific design principles drawn from the product's known patterns. Produces a scored report with specific observations and prioritised recommendations.

## Why this is useful

UX problems that feel like "something's off" are hard to act on without a framework. This skill names the problem precisely — which heuristic is violated, where, and why — so feedback is specific enough to act on.

## Key features

- Scores each of Nielsen's 10 heuristics: 0 = fail, 1 = partial, 2 = pass
- Adds RemotePass-specific checks (two user types, confirmation patterns, empty states)
- References the actual design — not generic UX advice
- Ends with a prioritised action list

## Triggers

- "UX audit this flow"
- "Review this screen against usability principles"
- "Score this design for usability"
- "Something feels off about this flow — help me identify what"
- "Heuristic evaluation of this screen"

## Prerequisites

None. Works from a Figma link, screenshot, or detailed description. The more context provided, the more accurate the output.

## Behavior & Instruction

1. Ask the designer for:
   - **The design**: Figma link, screenshot, or detailed description
   - **User goal**: what is the user trying to accomplish in this flow?
   - **User type**: Client, Worker, or both?
   - **Design stage**: Exploration / Mid-fi / Ready for dev
   - **Specific concern**: (optional) what are you most uncertain about?

2. If a Figma link is provided, use WebFetch to retrieve any public preview context.

3. Score the design across Nielsen's 10 heuristics. For each:
   - **Score**: 0 (fails), 1 (partial — issues present), 2 (passes)
   - **Observations**: specific, reference the actual element or moment in the flow
   - **Recommendation**: one concrete improvement if score < 2

   The 10 heuristics:
   1. **Visibility of system status** — does the user always know what's happening?
   2. **Match between system and real world** — does it use language and concepts the user knows?
   3. **User control and freedom** — can the user undo, exit, or go back easily?
   4. **Consistency and standards** — are similar things treated the same way?
   5. **Error prevention** — does the design prevent mistakes before they happen?
   6. **Recognition over recall** — can the user see what they need rather than remember it?
   7. **Flexibility and efficiency** — does it work for both new and experienced users?
   8. **Aesthetic and minimalist design** — is every element earning its place?
   9. **Help users recognise, diagnose, recover from errors** — are errors clear and fixable?
   10. **Help and documentation** — is help available when needed?

4. After the 10 heuristics, run RemotePass-specific checks:

   **Two user types**
   - If both Client and Worker are in scope: are their distinct needs and permissions clearly handled?

   **Confirmation patterns**
   - Are destructive or irreversible actions protected by a confirmation dialog?

   **State coverage**
   - Are Empty, Loading, and Error states designed?

   **Drawer pattern**
   - Are edit actions consistently using drawers (not modals or inline)?

   **Escape hatch**
   - Is there always a clear way to cancel, go back, or choose later?

5. Output the scored report:

   ```
   ## UX Audit — [Screen/Flow name]
   User: [Client / Worker / Both]
   Stage: [Exploration / Mid-fi / Ready for dev]

   ### Nielsen's 10 Heuristics

   | # | Heuristic | Score | Key observation |
   |---|---|---|---|
   | 1 | Visibility of system status | [0/1/2] | [One line] |
   | 2 | Match with real world | [0/1/2] | [One line] |
   | ... | ... | ... | ... |

   **Total: [N]/20**

   ### Issues to fix (score 0 or 1 only)

   For each heuristic that scored 0 or 1:
   - **[Heuristic name]** — [Specific observation referencing the actual design]
     → Fix: [Concrete recommendation]

   ### RemotePass-specific checks
   - ✅ / ⚠️ [Check name]: [observation]

   ### Priority action list
   1. [Most critical fix]
   2. [Second priority]
   3. [Third priority]
   ```

## Examples

- "UX audit the EOR onboarding flow — Client perspective, mid-fi"
- "Score this payroll submission screen for usability"
- "Something feels off about the compensation setup — run a heuristic review"

## Security & Safety

- Notion reads: auto-approved via hooks
- No writes anywhere
- No confirmation needed — read-only skill

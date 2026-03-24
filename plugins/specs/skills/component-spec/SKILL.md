---
title: Component Spec
description: Write engineering-ready component specs — props table, all states, interactions, accessibility, and edge cases
version: 1.0.0
requires: none
allowed-tools: WebFetch
argument-hint: "[component name or Figma link]"
---

## Summary

Produces a complete, engineering-ready spec for a component being handed off to development. Covers the props API, all visual and interaction states, keyboard behavior, accessibility requirements, and edge cases — so engineers have no reason to ask follow-up questions.

## Why this is useful

Handoff gaps cost time on both sides. When a spec is incomplete, engineers ask questions, designers re-open Figma, and momentum stalls. This skill anticipates what an engineer needs to know so the designer can focus on designing, not back-and-forth after handoff.

## Key features

- Props/API table in engineering-friendly format (`name | type | default | required | description`)
- Covers all states — not just default, but hover, focus, active, disabled, loading, error, empty
- Edge cases section — flags scenarios the design may not have addressed
- Do/Don't rules — 3–5 usage guardrails for this specific component

## Triggers

- "Write the spec for this component so I can hand it off"
- "Generate the engineering spec for the DatePicker"
- "Can you write a full component spec from this Figma frame?"
- "I need to hand off the EOR status badge — write the spec"
- "Write specs for all the states on this dropdown"

## Prerequisites

None. Works best with a screenshot or Figma link showing all states.

## Behavior & Instruction

1. If the user hasn't provided enough context, ask for:
   - **Component name:** as it will appear in code
   - **Design:** screenshot or Figma link — all states should be visible if possible
   - **All states:** default, hover, focus, active, disabled, loading, error, empty (only those that apply)
   - **Props / variants:** all configurable variants
   - **Interaction behavior:** what happens on click, hover, keyboard interaction?
   - **Accessibility requirements:** (optional) specific ARIA roles, keyboard nav needs
   - **Related components:** (optional) what does this compose with or depend on?

2. If a Figma link is provided, use WebFetch to retrieve any public preview context.

3. Write a full component spec with these sections:

   **1. Overview**
   What this component is, what problem it solves, when to use it. (2–3 sentences)

   **2. Props / API**
   Table: `prop name | type | default | required | description`
   Include all configurable properties visible in the design.

   **3. States**
   For each state that applies (default, hover, focus, active, disabled, loading, error, empty):
   - Visual description
   - What triggers this state
   - What changes from the default state

   **4. Interactions**
   - Mouse behavior (hover, click, drag if applicable)
   - Keyboard behavior (tab order, shortcuts, focus management)
   - Touch behavior (if applicable)

   **5. Content guidelines**
   - Character limits for any text elements
   - What happens when text overflows
   - Required vs optional content

   **6. Accessibility**
   - ARIA role and attributes
   - Keyboard navigation
   - Screen reader behavior
   - Color contrast requirements

   **7. Edge cases**
   Scenarios the design may not have explicitly addressed that engineering needs to handle.

   **8. Do / Don't**
   3–5 specific usage rules for this component.

## Examples

- "Spec the primary Button component — here's a screenshot with all states"
- "Write the full spec for the Tag/Badge component used in People > Status column"
- "Component spec for the file upload dropzone in the Documents tab"

## Security & Safety

- Read-only skill — WebFetch only for public Figma links.
- No writes, no confirmation needed.

# RemotePass — Known Design Patterns

This file is a living reference. Every time a designer defines a new pattern or behavior, it should be added here so Claude can learn from it and check against it during QA and reviews.

> **How to update:** When Claude identifies a new pattern during a session, it will suggest adding it here. Nourdine reviews and commits.

---

## Layout & Structure

### Section-based layout
Long forms and detail views use a section-based layout: each section has a title, a divider, and its own content block. Sections are vertically stacked with consistent spacing between them. Used in: contract details, EOR compensation, job information.

### Drawer for edit actions
Editing any record opens a drawer (side panel), never a modal or inline edit. Drawers contain the full edit form. On submit, the drawer closes and the page reflects the update.

### Pre-filled drawer when pending request exists
If a pending request already exists for a record, the edit drawer opens pre-filled with the pending values, and shows a warning banner at the top. The user can modify and resubmit. Used in: EOR contract changes.

### Timeline section
Records with a lifecycle (contracts, payroll runs) display a timeline on the right side showing status history. Each timeline entry has a status tag, a date, and optionally an actor name.

---

## Navigation & Flow

### Two user types — always design for both
Every flow must be considered from both the **Client** perspective (company admin) and the **Worker** perspective. Screens, copy, and permissions differ between them.

### Horizontal scroll for option selection
When presenting a set of options (providers, plans, presets) that may not all fit on screen, use horizontal scroll. Always place a "Choose later" or escape option at the end of the scroll. Used in: health insurance provider selection.

### Step-based flows
Multi-step processes use a top stepper component. Each step is a separate screen, not a long single-page form. Progress is always visible.

---

## Components & Interaction

### Confirmation dialog before destructive actions
Any action that is hard or impossible to reverse (delete, submit for legal review, terminate) must show a confirmation dialog before executing. Title: verb + noun ("Submit Change Request?"). Body: explain the consequence, not just repeat the action. CTA mirrors the title verb.

### Warning banner + reason textarea
When an action requires a reason or has a risk, show a warning banner at the top of the drawer/modal and a textarea for the reason. Collapse additional context in a "What happens next?" accordion. Used in: request changes flow, EOR termination.

### "What happens next?" accordion
Used alongside warning banners in high-stakes actions. Collapsed by default. Contains a brief explanation of the downstream consequences. Always placed below the main form content.

### Status tags
Status is always shown as a tag (chip), not plain text. Tags have a consistent color system: green = active/approved, yellow = pending, red = rejected/failed, grey = draft/inactive.

---

## Compensation Patterns

### Top-down model (KSA)
Total compensation is defined first (read-only, from Step 2). The breakdown is a preset split. States: Default (100% Base) / Presets list / Preset selected / Custom.
Presets: 100% Base / 70-20-10 / 60-30-10 / 75-25 / Custom.

### Bottom-up model (non-KSA)
Individual components are added and the total auto-calculates. Base salary is pre-filled with the full total and is non-deletable (no trash icon). Errors shown in red text below the table: "Remaining to allocate · X SAR" (under) or "Over the monthly compensation by X SAR" (over).

### Continue stays enabled; validate on submit
Forms with allocation or budget logic keep the Continue CTA active at all times. Validation happens on submit, not on change. This is a deliberate product decision — do not change without checking with PM.

---

## Copy & Content

### Placeholder format
- Free text / number inputs: `e.g. [realistic example]`
- Selects / dropdowns: `Select [noun]`
- Never repeat the label. Never use "Add value" or "Enter text".

### Error specificity
Errors name the exact problem and the exact fix. "Invalid input" is not acceptable. "Amount exceeds monthly compensation by 500 SAR" is correct.

### "Choose later" escape
Whenever a required choice might not be available or ready, offer a "Choose later" option. This keeps the user moving through the flow. Used in: health insurance plan selection, provider selection.

---

## States to always design

Every component and screen must account for these states:
- **Default** — standard loaded state
- **Empty** — no data yet (with CTA if there's an action available)
- **Loading** — skeleton or spinner
- **Error** — something went wrong (be specific)
- **Disabled** — action not available (explain why with a tooltip if not obvious)

For forms specifically, also design:
- **Validation error** — inline, appears on submit
- **Success** — confirm the action completed

---

*Last updated: 2026-03-23 — Nourdine*
*Add new patterns via PR or by asking Claude to suggest an update.*

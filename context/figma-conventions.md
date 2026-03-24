# RemotePass — Figma File Conventions

Applies to all new design work from the redesign onwards. Existing files with old components are exempt.

---

## File naming

`[Project key] — [Feature or area]`

Examples:
- `EOR — Compensation & Benefits`
- `Payroll — Run Management`
- `SpendCards — Issuance Flow`
- `Global — Design System`

---

## Page structure (mandatory order)

Every Figma file must follow this page order:

| # | Page name | Purpose |
|---|---|---|
| 1 | `Cover` | File thumbnail, project name, owner, last updated date |
| 2 | `Brief` | Project context, goals, constraints, user types in scope, links to Jira |
| 3 | `[Flow] — Exploration` | Early concepts, divergent thinking, not for dev |
| 4 | `[Flow] — v[N]` | Versioned iterations (v1, v2, v3…) |
| 5 | `[Flow] — Ready for dev` | Final, locked. This is what gets handed off. |
| 6 | `Archive` | Deprecated screens, rejected directions, old versions |

**Rules:**
- `Cover` is always first, always present
- `Brief` is always second, always present
- `Archive` is always last
- Flow pages sit between Brief and Archive
- Use one page per flow, not one page per screen
- If a file has multiple flows, repeat the `[Flow] — v[N]` pattern for each

---

## Flow naming

`[User type] — [Flow name]`

Examples:
- `Client — Add worker`
- `Client — Submit payroll run`
- `Worker — Upload document`
- `Client + Worker — Onboarding` (when both are in scope)

---

## Frame naming

`[Flow] / [Screen name] / [State]`

Examples:
- `Client — Add worker / Personal details / Default`
- `Client — Add worker / Personal details / Error — missing field`
- `Client — Submit payroll run / Review / Loading`
- `Worker — Upload document / Upload / Success`

**State suffixes (use exactly these):**
- `/ Default`
- `/ Hover`
- `/ Focus`
- `/ Active`
- `/ Disabled`
- `/ Loading`
- `/ Empty`
- `/ Error — [reason]`
- `/ Success`

---

## Layer naming

- Use descriptive names, not Figma defaults ("Frame 47", "Rectangle 12")
- Components: use the exact DS component name (e.g. `Button / Primary / Default`)
- Groups: use kebab-case (`header-section`, `form-row`)
- Text layers: name them by their content role (`label`, `body-copy`, `error-message`)

---

## Cover page template

The cover page must contain:
- Project name (large, prominent)
- File type tag: `Design` / `Design System` / `Prototype`
- Owner name
- Last updated date
- Status tag: `In progress` / `Ready for dev` / `Archived`
- Link to Jira epic or ticket (as a text annotation)

Use the Cover component from the Design System file.

---

## Versioning approach

- Version numbers go on the page name: `Client — Add worker — v2`
- When a version is superseded, rename it `[Flow] — v[N] — Archived` and move to the Archive page
- The `Ready for dev` page always reflects the current final state — update it in place, don't version it
- Never delete frames — move to Archive instead

---

## Component usage rules (redesign only)

- Use DS components exclusively — no detached instances, no custom overrides that bypass tokens
- If a needed component doesn't exist in the DS, flag it to Nourdine before building a custom version
- All fills, strokes, and text must use semantic tokens — no raw hex values or hardcoded numbers
- Spacing must use spacing tokens from the DS, not arbitrary values

---

*Applies from: 2026-03-23 (redesign start)*
*Does not apply to existing files built with old components*

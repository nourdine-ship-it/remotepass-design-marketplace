# RemotePass — Design System Conventions

## Token tiers
1. **Primitive** — raw values (colors, spacing, radius, type scales)
2. **Semantic** — purpose-based aliases (e.g. `color.text.primary`, `color.bg.danger`)
3. **Component** — component-specific tokens (e.g. `button.bg.primary`)

Semantic tokens reference Primitive tokens. Component tokens reference Semantic tokens.
Never skip a tier (e.g. a component token should not reference a Primitive directly).

## Naming convention
`[tier].[category].[variant].[state]`
Examples: `color.text.secondary`, `color.bg.danger.hover`, `spacing.inset.md`

## Inspect before you write
Always inspect the actual Figma component before writing spacing or structural guidelines.
Do not rely on memory — component details change.

## Component structure (Figma)
- Use Auto Layout for all components
- Variants: use Figma's variant system, not duplicate frames
- States: use interactive components where applicable (hover, focus, disabled, etc.)
- Token coverage: all fills, strokes, and text must use semantic tokens — no raw values

## Notion documentation structure (per component)
1. Overview
2. Anatomy
3. Variants
4. Usage guidelines (when to use / when not to use)
5. Content guidelines
6. Accessibility
7. Related components
8. Changelog

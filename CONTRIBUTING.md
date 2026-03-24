# Contributing to the RP Design Skills Library

This guide explains how to propose a new skill, improve an existing one, and get your changes merged.

---

## The golden rule

**Don't change a skill based on one good prompt.** Test it at least 3 times across different contexts, compare the outputs, and only then propose it as a change. We're building shared taste — that takes more than one data point.

---

## Proposing a new skill

1. **Check it doesn't exist already.** Browse the `/skills` folder. If something similar exists, consider improving it instead.
2. **Use the template.** Copy [`skills/_template.md`](./skills/_template.md) and fill it out completely. Incomplete submissions won't be merged.
3. **Include at least one real example.** Add your example output to the matching `/examples` subfolder. Name it `[skill-name]-example-[your-initials]-[YYYY-MM].md`.
4. **Open a PR** with the title: `[New Skill] Skill name here`
5. **Tag @Nourdine** for review.

---

## Improving an existing skill

1. **Explain what you changed and why** in the PR description. "Updated the prompt" is not enough — say what was wrong with the old version and what evidence you have that the new version works better.
2. **Bring a before/after example.** Add both to `/examples` or link to them in your PR.
3. **Update the `## Changelog` section** in the skill file itself.
4. **Open a PR** with the title: `[Update] Skill name — short description of change`
5. **Tag @Nourdine** for review.

---

## What makes a skill mergeable

- [ ] Template is complete (all sections filled in)
- [ ] At least one real example output is included
- [ ] "Why it works" section explains the reasoning, not just the mechanics
- [ ] Changelog entry is added (for updates)
- [ ] The skill has been tested 3+ times across different contexts

---

## What happens after you open a PR

Nourdine will review within 48 hours. He may:
- **Merge it** — great, the skill goes live for the whole team
- **Request changes** — he'll leave specific comments
- **Decline it** — rare, but he'll explain why and suggest an alternative path

If your PR sits without feedback for more than 48 hours, ping in the team channel.

---

## Skill lifecycle

```
Draft → Review → Merged → Active → Deprecated
```

Skills can be deprecated if a better approach replaces them. Deprecated skills are moved to `/archive` and kept for reference, never deleted.

---

## File naming conventions

```
skills/[category]/[skill-name].md          ← skill files
examples/[category]/[skill-name]-[initials]-[YYYY-MM].md  ← example outputs
```

Use lowercase and hyphens only. No spaces, no special characters.

---

## Questions?

Open a GitHub issue or ping Nourdine directly.

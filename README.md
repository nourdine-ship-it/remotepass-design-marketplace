# RP Design Skills

Claude Code plugins for the RemotePass design team. Install once — all 15 skills become available immediately in Claude Code.

---

## What you get

| Plugin | Skills |
|---|---|
| Copy | `/ux-copy` · `/microcopy` |
| Critique | `/design-review` |
| Specs | `/component-spec` |
| Design System | `/component-documentation` · `/peer-review` |
| QA | `/design-qa` · `/copy-audit` · `/a11y-check` · `/ux-audit` |
| Handoff | `/handoff` |
| Research | `/research-synthesis` · `/competitive-research` |
| Workflow | `/design-brief` · `/design-decision` |

Type `/` in Claude Code to see all available skills and trigger them with natural language.

---

## Install

### Step 1 — Add the marketplace (one-time, inside Claude Code)

Open Claude Code and run:

```
/plugin marketplace add git@github.com:nourdine-ship-it/remotepass-design-marketplace.git
```

### Step 2 — Install plugins

Still inside Claude Code, install each plugin:

```
/plugin install copy@remotepass-design-marketplace
/plugin install critique@remotepass-design-marketplace
/plugin install specs@remotepass-design-marketplace
/plugin install design-system@remotepass-design-marketplace
/plugin install qa@remotepass-design-marketplace
/plugin install handoff@remotepass-design-marketplace
/plugin install research@remotepass-design-marketplace
/plugin install workflow@remotepass-design-marketplace
```

That's it — all 15 skills are now available. Type `/` to see them.

---

## Getting updates

When Nourdine updates a skill or adds a new one, he'll let you know in Slack.

To update, open Terminal and run:

```bash
cd ~/remotepass-design-marketplace && git pull
```

Plugin updates are picked up automatically — no reinstall needed. If a brand new plugin was added, install it with `/plugin install [name]@remotepass-design-marketplace`.

---

## Skills reference

### ✍️ Copy
| Skill | What it does | Example trigger |
|---|---|---|
| `/ux-copy` | Write in-product copy — 3 variants with emotional framing | "Write copy for the empty state when a client has no workers yet" |
| `/microcopy` | Short UI strings with character counts and tone labels | "What should the submit button say on the payroll confirmation screen?" |

### 🔍 Critique
| Skill | What it does | Example trigger |
|---|---|---|
| `/design-review` | Structured critique across 5 UX dimensions with concrete fixes | "Review this design before I share it with the team" |

### 📐 Specs
| Skill | What it does | Example trigger |
|---|---|---|
| `/component-spec` | Engineering-ready component spec — props, states, interactions | "Write the spec for this component so I can hand it off" |

### 🧱 Design System
| Skill | What it does | Example trigger |
|---|---|---|
| `/component-documentation` | Full DS documentation — anatomy, variants, usage, accessibility | "Document the Checkbox component for the design system" |
| `/peer-review` | Peer review DS docs — gaps, clarity, verdict + top 3 fixes | "Review these component docs before I post them to Notion" |

### 🔎 QA (new redesign work only)
| Skill | What it does | Example trigger |
|---|---|---|
| `/design-qa` | DS compliance — tokens, components, layout, naming, states | "QA this frame against the design system guidelines" |
| `/copy-audit` | Check all UI text against RemotePass copy standards | "Audit the copy on this screen" |
| `/a11y-check` | WCAG 2.1 AA — contrast, touch targets, focus order | "A11y check this screen before handoff" |
| `/ux-audit` | Nielsen heuristics scored report + RP-specific checks | "UX audit this flow" |

### 📦 Handoff
| Skill | What it does | Example trigger |
|---|---|---|
| `/handoff` | Consistent dev spec — same sections every time, posts to Notion on request | "Prepare the handoff for this flow" |

### 🔬 Research
| Skill | What it does | Example trigger |
|---|---|---|
| `/research-synthesis` | Interview notes → themes, pain points, insights | "Synthesise these interview notes" |
| `/competitive-research` | How competitors handle a pattern — comparison table + synthesis | "How do competitors handle payroll approval?" |

### ⚙️ Workflow
| Skill | What it does | Example trigger |
|---|---|---|
| `/design-brief` | Jira ticket → structured design brief | "Write a design brief for RP-1234" |
| `/design-decision` | Document a design decision with rationale and alternatives | "Document why we chose this approach" |

---

## Some skills need extra setup

Skills marked with `requires: figma-bridge` need the Figma CLI bridge running before you use them. These are: `/design-qa`, `/a11y-check`, `/handoff`.

Run `/connect-figma` in Claude Code first. See [docs/setup.md](./docs/setup.md) for full setup instructions.

---

## Need help?

Ping Nourdine on Slack. For full setup details see [docs/setup.md](./docs/setup.md). To contribute a skill see [CONTRIBUTING.md](./CONTRIBUTING.md).

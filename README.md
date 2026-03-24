# remotepass design marketplace

Claude Code plugins for the RemotePass design team. Install once — all skills become available immediately in Claude Code.

---

## What you get

| Plugin | Skills |
|---|---|
| Critique | `/design-review` |
| Design System | `/component-documentation` · `/peer-review` |
| QA | `/design-qa` · `/copy-audit` · `/a11y-check` · `/ux-audit` |

Type `/` in Claude Code to see all available skills and trigger them with natural language.

---

## Install

### Step 1 — Add the marketplace (one-time, inside Claude Code)

Open Claude Code and run:

```
/plugin marketplace add https://github.com/nourdine-ship-it/remotepass-design-marketplace.git
```

### Step 2 — Install plugins

Still inside Claude Code, install each plugin:

```
/plugin install critique@remotepass-design-marketplace
/plugin install design-system@remotepass-design-marketplace
/plugin install qa@remotepass-design-marketplace
```

That's it — all skills are now available. Type `/` to see them.

---

## Getting updates

When you update a skill or add a new one, inform the team in Slack.

To update, open Terminal and run:

```bash
cd ~/remotepass-design-marketplace && git pull
```

Plugin updates are picked up automatically — no reinstall needed. If a brand new plugin was added, install it with `/plugin install [name]@remotepass-design-marketplace`.

---

## File structure

```
remotepass-design-marketplace/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace metadata & plugin registry
├── plugins/
│   ├── SKILL_TEMPLATE.md         # Template for creating new skills
│   └── [plugin-name]/            # One folder per plugin (critique, design-system, qa)
│       ├── .claude-plugin/
│       │   └── plugin.json       # Plugin metadata, name, version
│       ├── hooks/
│       │   ├── hooks.json        # Hook definitions (when hooks fire)
│       │   └── [name]-hooks.sh   # Hook logic
│       └── skills/
│           └── [skill-name]/
│               └── SKILL.md      # The skill prompt & instructions
├── docs/
│   └── setup.md                  # Full setup instructions
├── CLAUDE.md                     # Shared team context, auto-loaded by Claude
├── CONTRIBUTING.md               # How to add a skill or plugin
├── install.sh                    # Install helper script
└── README.md
```

---

## Skills reference

### 🔍 Critique
| Skill | What it does | Example trigger |
|---|---|---|
| `/design-review` | Structured critique across 5 UX dimensions with concrete fixes | "Review this design before I share it with the team" |

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

---

## Some skills need extra setup

Skills marked with `requires: figma-bridge` need the Figma CLI bridge running before you use them. These are: `/design-qa`, `/a11y-check`.

Run `/connect-figma` in Claude Code first. See [docs/setup.md](./docs/setup.md) for full setup instructions.

---

## Need help?

Ping Nourdine on Slack. For full setup details see [docs/setup.md](./docs/setup.md). To contribute a skill see [CONTRIBUTING.md](./CONTRIBUTING.md).

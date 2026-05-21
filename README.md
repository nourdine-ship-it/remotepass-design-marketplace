# remotepass design marketplace

Claude Code plugins for the RemotePass design team. Install once — all skills become available immediately in Claude Code.

---

## What you get

| Plugin | Skills |
|---|---|
| Design System | `/component-documentation` · `/component-peer-review` |
| Design Prep | `/design-decisions` |
| Design Review | `/qa` · `/copy` |
| Design Handoff | `/readiness` |

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
/plugin install design-system@remotepass-design-marketplace
/plugin install design-prep@remotepass-design-marketplace
/plugin install design-review@remotepass-design-marketplace
/plugin install design-handoff@remotepass-design-marketplace
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
│   └── [plugin-name]/            # One folder per plugin (design-system, design-prep, design-review, design-handoff)
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

### 🧱 Design System
| Skill | What it does | Example trigger |
|---|---|---|
| `/component-documentation` | Full DS documentation — anatomy, variants, usage, accessibility | "Document the Checkbox component for the design system" |
| `/component-peer-review` | Peer review DS docs — gaps, clarity, verdict + top 3 fixes | "Review these component docs before I post them to Notion" |

### 🗂 Design Prep
| Skill | What it does | Example trigger |
|---|---|---|
| `/design-decisions` | Look up the team's shared design decisions for a topic, optionally audit a Figma frame or screenshot against them, and log new decisions to Notion | "What do we do for empty states?" |

### 🔍 Design Review
| Skill | What it does | Example trigger |
|---|---|---|
| `/qa` | Structured critique across 4 UX dimensions plus a check against the team's active design decisions — extracts Figma layer data, delivers actionable feedback sorted by severity | "Review this design before I share it with the team" |
| `/copy` | UX writing review against RemotePass UX Writing Guidelines — extracts text layers, applies rule IDs by element type, delivers findings with corrected versions | "Review the copy on this screen" |

### 📋 Design Handoff
| Skill | What it does | Example trigger |
|---|---|---|
| `/readiness` | Pre-handoff checklist — breakpoints, use cases, system states, DS compliance, changelog | "Is this design ready for dev?" |

---

## Need help?

Ping Nourdine on Slack. For full setup details see [docs/setup.md](./docs/setup.md). To contribute a skill see [CONTRIBUTING.md](./CONTRIBUTING.md).

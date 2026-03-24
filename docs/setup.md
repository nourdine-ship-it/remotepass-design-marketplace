# Setup Guide

Everything you need to install once. After this, day-to-day use requires no setup at all.

---

## 1. Install plugins

Open Claude Code and run:

```
/plugin marketplace add https://github.com/nourdine-ship-it/remotepass-design-marketplace.git
```

Then install each plugin:

```
/plugin install critique@remotepass-design-marketplace
/plugin install design-system@remotepass-design-marketplace
/plugin install qa@remotepass-design-marketplace
```

Type `/` to confirm all skills are available.

---

## 2. Figma access token (required for most skills)

Most skills read Figma data via the REST API. They need a personal Figma access token set as an environment variable.

**Get your token:**
Figma → Profile → Settings → Personal Access Tokens → Generate new token. Grant `files:read` scope only.

**Set the environment variable:**
```bash
# Add to your ~/.zshrc or ~/.bash_profile
export FIGMA_ACCESS_TOKEN="your-token-here"
```

Then restart your terminal (or run `source ~/.zshrc`).

---

## 3. MCP servers (required for some skills)

MCP servers let Claude read/write to Notion and Jira. They're configured once in Claude Code settings.

Ask Nourdine for the MCP config block — it's a few lines that go into `~/.claude/settings.json`. He'll send it over Slack. Do not share MCP tokens publicly. Each person uses their own.

### Which skills need what

| Skill | Requires |
|---|---|
| `/ux-audit`, `/copy-audit` | Nothing extra — works out of the box |
| `/design-review`, `/a11y-check` | `FIGMA_ACCESS_TOKEN` |
| `/design-qa`, `/component-documentation`, `/peer-review` | `FIGMA_ACCESS_TOKEN` + Notion MCP |

---

## 4. Getting updates

When a skill is updated or a new one is added:

```bash
cd ~/remotepass-design-marketplace && git pull
```

Plugin updates are picked up automatically — no reinstall needed. If a new plugin was added, install it with `/plugin install [name]@remotepass-design-marketplace`.

---

## Troubleshooting

**A skill isn't showing up in Claude**
→ Make sure you ran all three `/plugin install` commands. Type `/` to see available skills.

**Figma tools aren't working**
→ Check that `FIGMA_ACCESS_TOKEN` is set (`echo $FIGMA_ACCESS_TOKEN`). If empty, add it to your shell profile and restart.

**Notion/Jira tools aren't working**
→ Your MCP config may be missing or your token expired. Ping Nourdine.

**Something broke after `git pull`**
→ Check the repo changelog or ping Nourdine.

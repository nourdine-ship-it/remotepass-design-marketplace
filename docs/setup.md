# Setup Guide

Everything you need to install once. After this, day-to-day use requires no setup at all.

---

## 1. Clone the repo and install skills

```bash
git clone git@github.com:nourdine-ship-it/remotepass-design-marketplace.git
bash remotepass-design-marketplace/install.sh
```

This links all skills to Claude Code so `/ux-copy`, `/design-review`, etc. become available immediately.

---

## 2. MCP servers (required for some skills)

MCP servers are integrations that let Claude read/write to tools like Figma, Notion, and Jira. They're configured once in Claude Code settings.

Skills that need MCPs will tell you at runtime if something is missing.

### Which skills need which MCP

| Skill | Requires |
|---|---|
| `/design-review`, `/ux-copy`, `/microcopy`, `/component-spec`, `/component-documentation`, `/peer-review` | Nothing extra — works out of the box |
| `/handoff`, `/document-component`, `/peer-review-component`, `/sync-ds-change` | Figma bridge + Notion MCP + Jira MCP |
| `/task`, `/daily-brief` | Notion MCP + Jira MCP |
| `/connect-figma` | Figma bridge |

### How to configure MCPs

Ask Nourdine for the MCP config block — it's a few lines that go into your Claude Code settings file (`~/.claude/settings.json`). He'll send it over Slack.

Do not share MCP tokens publicly. Each person uses their own.

---

## 3. Figma bridge (required for Figma skills)

The Figma bridge is a local server that lets Claude read your Figma files directly.

**Install:**
```bash
git clone https://github.com/[org]/figma-mcp-server.git ~/figma-mcp-server
cd ~/figma-mcp-server
npm install && npm run build
```

**Configure your Figma token:**
```bash
cp .env.example .env
# Open .env and paste your Figma Personal Access Token
```

Get your Figma PAT: Figma → Profile → Settings → Personal Access Tokens → Generate.

**Start the bridge:**
The bridge starts automatically when you run `/connect-figma` in Claude. You don't need to start it manually.

---

## 4. Personal config file (required for workflow skills)

Some skills need your personal IDs (Notion user ID, Jira account ID) to assign tasks and log work correctly.

Create this file:

```
~/.claude/design-team-config.md
```

With this content (fill in your own values):

```markdown
# My Design Team Config

## Notion
- My user ID: [get from Nourdine]
- Workload database: a586a2bd-cfb5-4104-8e42-6e348c9ce673

## Jira
- My account ID: [get from Nourdine]
- Cloud ID: 425566cf-c493-463f-b66e-0b019c72b5b9

## Timezone
- America/Toronto (Eastern Time)
```

This file lives only on your machine — never commit it to the repo.

---

## 5. Getting updates

When a skill is updated or a new one is added:

```bash
cd ~/remotepass-design-marketplace
git pull
```

If a new skill was added, run `bash install.sh` once more to link it.

---

## Troubleshooting

**A skill isn't showing up in Claude**
→ Make sure you ran `install.sh`. Check `~/.claude/skills/` — the skill file should be there as a symlink.

**Figma tools aren't working**
→ Run `/connect-figma` first. If that fails, check that your `.env` file has a valid Figma token.

**Notion/Jira tools aren't working**
→ Your MCP config may be missing or your token expired. Ping Nourdine.

**Something broke after `git pull`**
→ Check the repo's changelog or ping Nourdine. Nothing in a `git pull` can break your local Claude setup permanently — the worst case is a skill file has a typo.

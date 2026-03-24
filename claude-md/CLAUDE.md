# RemotePass Design Team — Shared Claude Context

This file is the single-source team-level context for the RemotePass design team. It is automatically loaded into Claude when working in any project that references this repository. Keep it short, factual, and up to date.

---

## Product

B2B HR and payroll platform for remote teams.

**Two user types:**
- **Client** — the company (HR admin, finance). Manages contracts, payroll runs, documents.
- **Worker** — the remote employee. Receives payments, manages documents, tracks time.

**Client navigation:** Activity · People · Payroll · Invoices · Bill Pay · Reports · Time Tracking · Documents · Transactions · SpendCards

**Key concepts:** EOR (Employer of Record), Contractor, Payroll run, Bill Pay, SpendCards

---

## Voice & tone

- Clear, warm, direct — knowledgeable colleague, not a corporate tool
- No jargon, no passive voice, no filler: "seamlessly", "powerful", "robust", "leverage"
- Placeholders: free text → `e.g. [realistic example]` · selects → `Select [noun]`
- Never repeat the label in a placeholder

---

## Design system

- Built in Figma. Components documented in Notion.
- Token tiers: Primitive → Semantic → Component
- Always inspect the actual Figma component before writing spacing or structural guidelines
- Never hardcode values — all fills, strokes, and text must use semantic tokens

---

## File & naming conventions

- Figma files: `[Project key] — [Feature]` e.g. "EOR — Compensation & Benefits"
- Pages: `In progress` / `Ready for dev` / `Archive`
- Flows: `[User type] — [Flow name]` e.g. "Client — Add compensation"
- Frames: `[Flow] / [Screen name] / [State]`

---

## MCP tools available

- **Figma:** `mcp__figma-mcp-server__*` — read structure, search nodes, get components, post comments
- **Notion:** `mcp__claude_ai_Notion__*` — read/write pages, search, create tickets
- **Jira:** `mcp__claude_ai_Atlassian__*` — get/update/transition issues, add worklogs
- **Google Calendar:** `mcp__claude_ai_Google_Calendar__*`
- **Gmail:** `mcp__claude_ai_Gmail__*`

---

## Hard rules

- Timezone: always Eastern Time (America/Toronto)
- NEVER add Jira comments unless explicitly asked
- NEVER guess or fabricate Figma node IDs — always fetch them
- Skills that post to Notion, Jira, or Figma must confirm with the user before writing
- Verify URLs before flagging them as broken
- Do not paste production user data — use anonymized or mock data only

---

## Contacts

- Lead designer: nourdine@remotepass.com
- Team: Nourdine, Moustapha, Anam

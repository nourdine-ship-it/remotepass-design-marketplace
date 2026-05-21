---
title: Design Decisions
description: Look up the RemotePass design team's shared decisions for a topic the designer is asking about, optionally audit a Figma frame or screenshot against the rules in that topic, and log new decisions to the team's Notion database
version: 1.0.0
requires: |
  - Topic from the prompt (required) — what the designer is asking about (icons, spacing, button alignment, confirmation patterns, etc.)
  - Figma frame URL or attached image (optional) — only needed for a visual audit; without one, the skill just returns what the team has decided on that topic
  - FIGMA_ACCESS_TOKEN (required only if a Figma URL is provided — set as env var with files:read scope)
  - Notion MCP (required — for reading and writing the Design Decisions database)
allowed-tools: WebFetch, Bash, Edit, Write, Read, mcp__claude_ai_Figma__get_design_context, mcp__claude_ai_Figma__get_metadata, mcp__claude_ai_Figma__get_screenshot, mcp__claude_ai_Notion__notion-fetch, mcp__claude_ai_Notion__notion-search, mcp__claude_ai_Notion__notion-create-pages
argument-hint: "[your question, optionally with a figma url or image]"
---

## What is this about?

A shared memory for the design team. Ask *"what do we do for this case?"* from anywhere — a Figma frame, a prod screen, a hallway discussion — and the skill pulls the team's decision log in Notion for that topic and reports what's been decided. If you also give a Figma URL or attach a screenshot, it audits that visual against the team's active rules **for the topic you asked about**, and only that topic. When a designer makes a new decision, the skill logs it to the same database for the team to review.

## What is the value?

Design decisions get forgotten. New work — in Figma or in production — ends up contradicting choices the team already made. This skill puts the team's reasoning one prompt away: ask about a topic from any context, and you get the active rule plus anything that's still being debated. The audit is strictly scoped to what the designer asked about — no out-of-scope noise, even if the visual contains mismatches in other categories.

## What does it do?

- Reads the topic from the designer's prompt
- Maps it to a category in the Design Decisions database
- Lists every active rule the team has decided in that category — deterministic, not a keyword search
- If a Figma URL or image is provided, audits that visual against those rules **for the asked topic only**
- When the designer agrees on a new decision, writes a row to the database in the **Proposed** section for the team to review

## When to call it?

- "What's our rule for [empty states / confirmation dialogs / delete icons / spacing in cards]?"
- "I saw [X] on prod — has the team decided anything about [topic]?"
- "Check this frame's icons against our rules" *(with Figma URL)*
- "Check this screenshot for button alignment" *(with image)*
- "Log a new decision — [decision]"
- "We just agreed on [decision]. Save it."
- "What's pending review?" · "Any Proposed decisions rotting?"

## What is needed?

- **A topic or question from the prompt** — the thing the designer wants to check. If absent, the skill asks.
- **Figma frame URL *or* attached image** — optional. Without one of these, the skill returns the team's rules for the topic and stops; with one, it also audits the visual.
- **`FIGMA_ACCESS_TOKEN`** — required only if a Figma URL is provided. Set in environment with `files:read` scope only (no write or delete permissions). If missing, a friendly setup flow will guide you through saving it — you won't need to do this again. If present but invalid, the skill stops and tells you what to fix.
- **Notion MCP** — must be configured to access the RemotePass workspace. Used to read the Design Decisions database and write new proposed decisions.

## Fixed resources

These are always referenced — do not ask the user for them:

- **Design Decisions database:** `https://www.notion.so/0487cda407694b00b6b2db0fc4c9a112`
- **Design Decisions data source ID:** `collection://2addba54-3988-4a1e-bed0-c191b566018c`
- **Skill documentation page:** `https://www.notion.so/35fc5c4e3150807d9215c23a29eb4943`
- **Where the team finds it in Notion:** Product → Design → **Frameworks** callout → *Design Decisions*. The skill itself always reads/writes via the data source ID above — the team-facing path is informational, in case a designer asks where to open the database manually.

The database has these fields:

| Field | Type | Notes |
|---|---|---|
| `Title` | Title | Short, scannable name for the decision |
| `Decision` | Text | The rule itself, one sentence |
| `Applies when` | Text | Plain-language trigger condition — *when does this decision apply?* Used by the audit step to filter relevant rules before judging. E.g. *"any view that contains a button group (2+ actions side by side)"*. Required for every decision |
| `Person` | Person | Who added the decision |
| `Status` | Select | `Active` (the team follows it) or `Proposed` (awaiting team review) |
| `Category` | Select | Bucket the decision belongs to. Fixed options: **Hierarchy**, **Patterns**, **Iconography**, **Spacing**, **System states**. Pick the closest fit — do not add new options. Copy, Clarity, DS compliance, and Accessibility are intentionally out of scope here and covered by other skills (`/copy`, `/qa`, `/readiness`). **Patterns** covers container and interaction choices (modal vs drawer, confirmation patterns, navigation behavior) |
| `Design reference` | URL | Link backing the decision — Figma frame, doc, Slack thread, image. **Left empty on creation by this skill** — the team populates it manually in Notion after the decision is logged |
| `Date of creation` | Date | Date the decision was logged. Auto-filled with today's date by the skill |

Approval is handled outside this skill — the team discusses each proposed row in its Notion comments, then flips `Status` from `Proposed` to `Active` manually. If a rule becomes wrong, edit the row directly in Notion or delete it — at this team size, there's no need for formal supersession.

## How does it work?

### Path A — Look up decisions for a topic

1. **Parse the topic from the prompt**

   The designer's prompt is the question. Pull out what they want to check — icons, spacing, button alignment, confirmation pattern, empty states, etc. If the prompt has no clear topic, ask:
   > "What do you want me to check?"

   Do not proceed without a topic. The skill is scoped to one topic per call. **Strictly.**

2. **Check inputs (Figma URL / image / neither)**

   - **If a Figma URL is provided →** run the token flow:
     - **If `FIGMA_ACCESS_TOKEN` is not set:** show the friendly collection flow —
       > "Don't worry, Nourdine thought of this 👋 I need a Figma access token to read the file. Two options:
       > **A** — Paste your token here and I'll save it automatically. You won't need to do this again.
       > **B** — Save it yourself: open `~/.claude/settings.local.json` and add `"FIGMA_ACCESS_TOKEN": "your-token-here"` under the `"env"` key."

       If the user chooses A: write the token to `~/.claude/settings.local.json` under `env.FIGMA_ACCESS_TOKEN`, then continue.
     - **If `FIGMA_ACCESS_TOKEN` is set:** call `GET /v1/me` to verify it is valid —
       ```bash
       curl "https://api.figma.com/v1/me" -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
       ```
       If the response is not 200, stop and tell the user their token is invalid or expired — they need to generate a new one.
   - **If an image is attached →** no token needed. Skip to step 3.
   - **If neither →** this is a lookup-only call. Skip to step 4 (database fetch), then output the team's rules for the topic without any audit.

3. **Read the visual** *(only if URL or image was provided)*

   - **Figma URL:** pass the URL directly to:
     - `mcp__claude_ai_Figma__get_metadata` — returns frame name, component names, text layers, variants, visibility flags
     - `mcp__claude_ai_Figma__get_design_context` — returns the richer node tree when more structure is needed
     - `mcp__claude_ai_Figma__get_screenshot` — call when the audit needs to judge visual hierarchy (e.g. "primary action" rules in step 6)

     The MCP handles URL parsing, auth, and pagination. Do not extract `fileKey`/`nodeId` manually — let the MCP do it. **Only fall back to REST `curl`** when the MCP does not expose what you need (specifically: `boundVariables` per layer for token audits — not relevant to this skill in most cases). When falling back, the token verification flow in step 2 still applies.

     From the MCP response, extract only what's relevant to the asked topic (e.g. icons if the topic is Iconography; spacing values if Spacing). Skip any node where `visible === false`.

   - **Image:** read the attached image directly. Inspect only the aspect relevant to the topic.

4. **Identify the visual's subject** *(only if URL or image was provided)*

   Before judging, decide *what this visual is about*. The audit runs against the **subject**, not every layer. A frame can contain a full page of background context whose only purpose is to set the scene for one modal, one toast, one empty state — auditing the background as if it were the subject produces noise.

   Use a layered approach. Stop at the first layer that gives a clear answer:

   1. **Structural cues from metadata** (Figma only):
      - **Overlay/scrim node** (a full-bleed rectangle near the top of z-order) + an elevated component on top → the elevated component (Dialog / Sheet / Drawer / Modal) is the subject; everything beneath is background context.
      - **Fixed-position floating element** (Toast in a corner, Tooltip near an anchor, Popover) → the floating element is the subject.
      - **Single component in isolation** (one component instance on an otherwise empty frame, or a grid of variants of the same component) → that component is the subject.
      - **No structural signal** (a full page with no overlay / no floating element / no isolation) → the main content area is the subject; the whole page is in scope.
   2. **Frame name as case label** (Figma only). The last slashed segment often names the case (*"Empty"*, *"Error"*, *"Loading"*, *"Hover"*). Use it to confirm or disambiguate what structure suggested — not as the primary source, since names can be sloppy.
   3. **Screenshot / image as arbiter.** When structure and name disagree (or both are ambiguous), render the frame with `get_screenshot` (or use the attached image directly) and judge visually: where's the focal point? What's elevated, centered, or stylistically distinct?
   4. **Ask the user when still ambiguous.** *"What's this about — the [X] or the [Y]?"*

5. **Fetch the database**

   Pull the entire data source — do not semantic-search.

   ```
   mcp__claude_ai_Notion__notion-fetch
     id: "collection://2addba54-3988-4a1e-bed0-c191b566018c"
   ```

   Read each row's `Title`, `Decision`, `Applies when`, `Status`, `Category`, `Person`, `Date of creation`. **Resolve `Person` to a readable name** using the reverse of the hardcoded team mapping in Path B (Notion user ID → display name). If a Person ID isn't in the table, fall back to the Notion user's display name from the API response. Format `Date of creation` as `MM/DD/YYYY` for display.

6. **Filter by topic, then by `Applies when`, then audit**

   **Strict topic scope.** First filter the rows to those whose `Category` matches the asked topic. Map the topic to a category: *icons* → Iconography, *button placement / modal vs drawer* → Patterns, *padding / sizing* → Spacing, *visual weight / primary action* → Hierarchy, *empty / loading / error* → System states. If the topic doesn't map to any category, ask the designer which fits.

   **Rules in any other category are out of scope for this call. Never surface them, even if the visual contains an obvious mismatch in another category.** The designer asked one question; answer that one.

   Within the topic, treat `Active` rows as rules and `Proposed` rows as context only (never enforced).

   **If no Figma URL / image was provided (lookup-only mode):**
   - List the `Active` rules in the topic — no `Applies when` filter, no audit.
   - List the `Proposed` rules in the topic for context.
   - Output as State 4 (see below).

   **If a Figma URL or image was provided:**
   - For each `Active` rule in the topic, decide *does this rule apply to the subject?* by matching the rule's `Applies when` against the subject and its child layers.
   - If `Applies when` is empty (legacy rows) → fall back to treating the rule as universally applicable for the topic and flag it in the output as *needs scoping*.
   - If `Applies when` is set but no match → silently skip the rule.
   - If `Applies when` matches → audit the design against the rule.

   For each applying `Active` decision, compare the rule against the design:
   - **Follows** — the design respects the decision. No flag.
   - **Breaks** — the design contradicts the decision. Flag with the specific fix.

   **Read decisions for intent, not literally.** Rules describe design behavior, not Figma metadata. When a decision uses a word that has both a design meaning and a component-property meaning, the design meaning wins. In particular:

   - **"Primary action"** = the dominant action in the view (where the eye lands, where the visual weight sits). It is **not** the same as `Variant: Primary` in Figma. A button can be the primary action without being the `Primary` variant, and a `Primary` variant button can fail to be the primary action of a group if hierarchy is off. Always render the frame (via `get_screenshot`) and judge weight from the screenshot, not from the variant string.
   - **"Secondary / tertiary action"** = lower-emphasis actions in the same group, judged visually — again, not the `Secondary` variant specifically.
   - Same principle applies to any other rule that names a role rather than a token (e.g. "destructive", "dominant", "lead"). Treat the words as intent, then verify against the rendered design.

   If a rule's literal-variant reading conflicts with the rendered design's visual hierarchy, **flag the visual hierarchy**, not the variant match.

7. **Output**

   Lead with counts on the first line. Use plain language throughout — **never the words `conflict`, `violation`, `fail`, `error`, `expected`, `found`** (as verdicts). **Every decision row shows the same four fields: Title · Decision · Designer · Date.** Designer and date give the team attribution and rough freshness signal; Active rules still stand until explicitly retired, so the date is informational only — never a basis for ignoring a rule.

   **Strict scope rule.** Output is about the asked topic only. Even if the visual contains mismatches in other categories — wrong button alignment when the topic is Iconography, wrong icon when the topic is Spacing — do not mention them. One question, one answer.

   The format below applies to all four states.

   **State 1 — Nothing to check** (no Active decisions in the topic, or the topic has no rule that applies to the subject):

   > Nothing to check — the team hasn't decided anything for [topic] in views like this.

   Optionally append one short sentence saying what was looked for.

   **State 2 — All aligned** (Active decisions apply and the design matches all of them):

   > **All aligned · N checked**
   >
   > **Aligned**
   > • **[Title]** — [Decision]
   >   Added by [Designer] · [MM/DD/YYYY]
   > • **[Title]** — [Decision]
   >   Added by [Designer] · [MM/DD/YYYY]

   **State 3 — Mixed** (Active decisions apply and the design is off on one or more):

   > **N worth reviewing · M aligned**
   >
   > **Worth reviewing**
   > • **[Title]** — [Decision]
   >   Added by [Designer] · [MM/DD/YYYY] · [Category]
   >   → [imperative fix in plain language] (currently [what the design does])
   > • **[Title]** — [Decision]
   >   Added by [Designer] · [MM/DD/YYYY] · [Category]
   >   → [imperative fix in plain language] (currently [what the design does])
   >
   > **Aligned**
   > • **[Title]** — [Decision]
   >   Added by [Designer] · [MM/DD/YYYY]

   - Sort *Worth reviewing* items by how visible the mismatch is — most prominent first.
   - Omit the *Aligned* section if M = 0.
   - **The arrow line is the fix, not the diagnosis.** Lead with what to change, in imperative voice; put the current state in parens after. The Decision already carries the rule.
   - Examples of the right shape:
     - `move primary action to the right (currently on the left)`
     - `add a CTA to the empty state (illustration and text present, button missing)`
     - `swap the back icon to chevron-left (currently arrow-left)`
     - `move the toast to top-right (currently bottom-center)`
   - Banned shapes: `primary on left` (only diagnosis, no fix), `should be primary on right` (passive, indirect).

   **State 4 — Lookup only** (no Figma URL / image provided):

   > **What we've decided about [topic]**
   >
   > • **[Title]** — [Decision]
   >   Added by [Designer] · [MM/DD/YYYY]
   > • **[Title]** — [Decision]
   >   Added by [Designer] · [MM/DD/YYYY]

   If nothing in the category yet:
   > The team hasn't decided anything about [topic] yet. If you want to make a call here, ask me to save it.

   **Proposed decisions** (append at the very end, only if any apply):

   In audit mode (states 2 / 3): filter Proposed rules by `Applies when` the same way Active rules are filtered — only relevant Proposed rules appear. If a Proposed rule doesn't apply, skip it silently.

   In lookup mode (state 4): list all `Proposed` rules in the topic, no `Applies when` filter.

   > **Still being discussed** (not yet team rules)
   > • **[Title]** — [Decision] · [Category]
   >   Added by [Designer] · [MM/DD/YYYY] — [alignment note]
   > • **[Title]** — [Decision] · [Category]
   >   Added by [Designer] · [MM/DD/YYYY] — [alignment note]

   In audit mode, add an **alignment note** telling the designer whether their current design would be affected if the rule passes:
   - If the design already follows the proposed rule: *"your design already does this"*
   - If the design would need to change: *"your design [what it currently does], would need to change if this passes"*

   In lookup mode, omit the alignment note — there's no design to compare against.

   If no Proposed rules apply, omit the *Still being discussed* section entirely.

### Path C — List pending decisions

Use when the designer asks *"what's waiting for review?"* or *"any rotting Proposed decisions?"*. Read-only — never writes.

1. **Fetch all `Status = Proposed` rows** from the Design Decisions database.

   ```
   mcp__claude_ai_Notion__notion-fetch
     id: "collection://2addba54-3988-4a1e-bed0-c191b566018c"
   ```

   Filter the result client-side: keep only rows where `Status == "Proposed"`.

2. **Sort** alphabetically by Category, then by Title. **Do not sort by age** — a decision's age doesn't change its relevance at this team scale.

3. **Output**

   **If nothing is Proposed:**
   > Nothing pending. The team is caught up.

   **If there are Proposed rows:**
   > **N pending review**
   >
   > • **[Title]** — [Decision] · [Category]
   >   Added by [Designer] · [MM/DD/YYYY]
   > • **[Title]** — [Decision] · [Category]
   >   Added by [Designer] · [MM/DD/YYYY]

   Sorted alphabetically by Category, then by Title.

### Path B — Log a new decision

When the designer makes a new decision and asks to save it:

1. **Pre-flight: check for duplicates and conflicts**

   Before collecting anything, fetch the full database (same call as Path A step 5). Compare the user's stated decision against existing rows by *intent*, not exact text:

   - **Near-duplicate of an `Active` row** (same `Applies when` + same effective rule) → stop and tell the user: *"This already exists as an Active rule — [Decision]. Skip, or edit the existing row in Notion if it needs refining."* Don't write a near-duplicate.
   - **Conflicts with an `Active` row** (same `Applies when` but contradictory rule) → stop and tell the user: *"This contradicts an existing Active rule — [Decision]. Discuss with the team first, then either edit the existing row or log this as a fresh decision once the team's aligned."* Don't write a contradicting rule without team alignment.
   - **No overlap** → proceed normally to step 2.

   Never silently let a user create a duplicate or a contradicting rule.

2. **Collect the decision**

   Ask plainly for what's missing:
   - **Title** — short, scannable name (max ~8 words)
   - **Decision** — the rule itself in one sentence
   - **Applies when** — one-line plain-language trigger: *when does this rule fire?* Be specific about the case (e.g. *"any view with a button group of 2+ side-by-side actions"*, not *"forms"*). Without this, audits get noisy. Required.
   - **Category** — pick from the fixed list: **Hierarchy**, **Patterns**, **Iconography**, **Spacing**, **System states**. Never add new options. Use **Patterns** for container/interaction choices (modal vs drawer, confirmation patterns, navigation behavior). If the decision doesn't fit any of these, it belongs in another skill (`/copy` for copy, `/qa` for clarity, `/readiness` for DS compliance and accessibility) — say so and stop, rather than forcing a bad fit.

   **Design reference** — never asked, never auto-filled by this skill. Left empty on creation. The team populates it manually in Notion after the decision is logged. For Iconography decisions, the manual fill should be the **DS icon component URL**, not a usage frame URL — frame URLs rot when screens change, the icon-component URL stays valid as long as the icon exists.

   **Date of creation** — never asked. Auto-fill with today's date in ISO format (`YYYY-MM-DD`). Display back to the user as `MM/DD/YYYY`.

   **Person — always pulled from the active session, never asked.** The team's Notion user IDs are hardcoded below — match the session identity against this table first and use the matched ID directly. Do not rely on Notion user search (which can match wrong people across the workspace) unless the session identity is genuinely unknown.

   **Team mapping (single source of truth):**

   | Email | Name | Notion user ID |
   |---|---|---|
   | `nourdine@remotepass.com` | Nourdine | `6458850a-9434-4123-90d5-d68d87f2d878` |
   | `moustapha@remotepass.com` | Moustapha | `d1ab450f-2929-4821-abca-ddef2e1f3dd0` |
   | `anam@remotepass.com` | Anam Shahzadi | `226d872b-594c-8199-b9fe-00021f0e373a` |

   Resolution order (take the first match against the table above):
   1. The user's email from the global Claude config (`userEmail` in the auto-memory context or `~/.claude/CLAUDE.md`)
   2. `git config user.email`

   **Fail loud, never silently:**
   - If the resolved email is in the table → use the mapped ID directly.
   - If the resolved email is **not** in the table (e.g. a teammate joined and their ID hasn't been added yet) → **stop and ask the user before writing**: *"I don't have a Notion user ID mapped for `<email>`. Paste it and I'll save it for next time, or tell me to skip and I'll leave Person blank."* Never write a row with a blank or guessed Person.
   - If no email resolves at all from steps 1–2 → stop and ask *"Who's making this call?"* before writing.

   When a new team member's ID gets added, update the table above in this file — don't rely on Notion user search at write time.

3. **Confirm before writing**

   Per the team rule, never write to Notion silently. Show the row back:

   > I'll add this to the Design Decisions database under **Proposed**:
   >
   > - **Title:** [title]
   > - **Decision:** [decision]
   > - **Applies when:** [applies when]
   > - **Category:** [category]
   > - **Date of creation:** [MM/DD/YYYY]
   > - **Person:** [name]
   >
   > `Design reference` will be left empty — add the link or screenshot in Notion when you're ready.
   >
   > Confirm and I'll save it.

   Wait for explicit confirmation.

4. **Write the row**

   ```
   mcp__claude_ai_Notion__notion-create-pages
     parent: { type: "data_source_id", data_source_id: "2addba54-3988-4a1e-bed0-c191b566018c" }
     pages: [{
       properties: {
         "Title": "<title>",
         "Decision": "<decision>",
         "Applies when": "<applies when>",
         "Person": "<person-id-or-name>",
         "Status": "Proposed",
         "Category": "<category>",
         "Date of creation": "<YYYY-MM-DD>"
       }
     }]
   ```

   `Design reference` is intentionally omitted — the team adds it manually in Notion.

5. **Output**

   > Saved as **Proposed**. The team will see it in the Design Decisions database — once it's discussed and agreed, anyone on the team can flip its status to Active.

## Conventions

- **Strict topic scope** — output is about the asked topic only. Never surface rules outside the topic, even if the visual contains an obvious mismatch in another category. One question, one answer.
- **Every decision row carries the same four fields** — Title · Decision · Designer · Date. Applies everywhere a decision is listed (Path A states 2, 3, 4, *Still being discussed*, Path C). Format dates as `MM/DD/YYYY`. Resolve `Person` to a readable display name, not the raw Notion user ID.
- **Date as context, not a verdict** — designer and date give attribution and rough freshness, but Active rules still stand until the team explicitly retires them. Never use age as a reason to soften or skip a rule.
- **Language** — plain, no jargon. Don't surface internal field names, statuses (`Active`/`Proposed` is fine in the database, but in conversation say *"team rule"* or *"still being discussed"*), or skill mechanics in the output.
- **Severity** — when surfacing mismatches, lead with the most visually prominent. If several items are off, sort by how obvious each one would be on the screen.

## Changelog

- **3.1.4 — 05/21/2026** — Database moved out of its old home (under Q2 2026 Roadmap → OKR → plugin page) and into the **Frameworks** callout on the Design page, next to Design Brief Framework and Our Design Process. Operational data now lives on the operational shelf — the team no longer has to drill through OKR tracking to find it. *Where the team finds it in Notion* line in Fixed resources updated accordingly. No behavior change — the data source ID is unchanged, so the skill works identically.
- **3.1.3 — 05/21/2026** — Fixed resources section corrected and expanded. The earlier "Design Decisions database page" URL was actually the skill documentation page, not the database itself — split into two distinct entries (`Design Decisions database` and `Skill documentation page`). Added a *Where the team finds it in Notion* line pointing at Product → Design → Frameworks → Design Decisions, so anyone reading the skill knows the team-facing path without having to dig. No behavior change — the skill always reads/writes via the data source ID, which is unchanged.
- **3.1.2 — 05/19/2026** — Plugin housing this skill renamed from `design-decisions` to `design-prep` (`plugin.json` v4.0.0), opening room for more pre/during-design skills alongside it. The skill itself, slash command (`/design-decisions`), Notion DB, and behavior are all unchanged.
- **3.1.1 — 05/19/2026** — Refreshed `plugin.json` description to match v3.1.x behavior — mentions topic scope, optional visual audit, and logging. No behavior change.
- **3.1.0 — 05/19/2026** — Output format expanded: every decision row now carries Title · Decision · Designer · Date in a block layout (multi-line per row). Applies across Path A states 2, 3, 4, *Still being discussed*, and Path C. Path A step 5 now reads `Person` and `Date of creation` from the database and resolves the Person ID to a display name using the reverse of the hardcoded team mapping. Reverses two earlier choices: the v1.0.2 "no names in output" rule and the v2.6.0 "no dates in informational output" rule. Rationale: attribution helps the team remember who's championing what, and a creation date gives a rough freshness signal — though Active rules still stand until the team explicitly retires them, regardless of age.
- **3.0.0 — 05/19/2026** — **Breaking, two changes:**
  - **Strict topic scope.** The audit is now driven by the topic in the designer's prompt and scoped to that topic only. The skill maps the topic to a `Category` (Iconography, Patterns, Spacing, Hierarchy, System states), filters rules by that category, then runs the `Applies when` check inside the filter. Rules in other categories are never surfaced — even if the visual contains an obvious mismatch elsewhere. Reverses v2.4.1, which audited every applicable rule regardless of prompt. The rationale flipped: designers want a precise answer to the question they asked, not a frame-wide audit dressed up as one.
  - **Figma URL / image now optional.** The skill no longer requires a frame to answer. With a URL or image, it audits the visual against the topic (same as before, but scoped). Without one — pure lookup mode — it just returns the team's rules for the topic and stops. Image attachments are accepted as an alternative to a Figma URL, so prod screenshots and design references outside Figma also work. Token check only runs when a Figma URL is provided.
  - **Path B no longer collects `Design reference`.** The field is left empty on creation and populated manually in Notion. The Iconography-specific URL guidance moves to the field description so it surfaces when the team adds the reference in Notion.
- **2.7.0 — 05/15/2026** — New Path A step 3: identify the frame's subject before filtering rules. Layered approach — structural cues (overlay+elevated, floating element, isolated component) first, frame name second, screenshot third, ask the user when still ambiguous. Step 5 now audits against the subject, not the full layer tree — background context (the page behind a dialog, the state behind a hover) is out of scope unless a rule's `Applies when` explicitly targets it. Fixes the case where a Modal/Dialog frame got audited as a multi-step form because the background wizard was still in the layer tree.
- **2.6.1 — 05/15/2026** — *Still being discussed* now filters Proposed rules by `Applies when` the same way Active rules are filtered — only relevant Proposed rules appear. Dropped the *"doesn't apply to this frame"* alignment note; non-applicable rules are skipped silently.
- **2.6.0 — 05/15/2026** — Dates removed from all informational output. Active rules stand until the team retires them — a decision's age isn't relevant. Path A *Worth reviewing* items no longer show the rule's creation date. Path C simplified: no age-based grouping, no *"Needs attention"* / *"Recent"* split, no *"N days ago"* labels — just a single sorted list of pending review items.
- **2.5.3 — 05/15/2026** — *Still being discussed* items now include an alignment note telling the designer whether their current design would be affected if the proposed rule passes (*"your design already does this"* / *"would need to change if this passes"*).
- **2.5.2 — 05/15/2026** — *Worth reviewing* items now lead with the **fix**, not the diagnosis. Format is imperative-first (*"move primary action to the right"*) with the current state in parens. Tells the designer what to change, not just what's off.
- **2.5.1 — 05/15/2026** — *Still being discussed* now shows the full Decision text, not just the Title. A topic label alone (e.g. *"Back navigation icon"*) didn't tell the designer what was being proposed.
- **2.5.0 — 05/15/2026** — Rewrote Path A output in a calmer Linear-style voice. Counts at the top (*"N worth reviewing · M aligned"*), no more *"Conflicts"* / *"No conflicts found"* / *"Expected / Found"* framing. Titles do the headline work; aligned items are listed compactly with middle dots. Output uses plain language only — banned the words *conflict*, *violation*, *fail*, *error*, *expected*, *found* as verdicts.
- **2.4.1 — 05/15/2026** — Explicit instruction in Path A step 5: always audit every applicable rule, never narrow to the user's prompt. The value of the skill is catching what the designer didn't notice. *(Superseded by 3.0.0 — strict topic scope reinstates prompt-driven narrowing.)*
- **2.4.0 — 05/15/2026** — 3-person sanity trim. Removed `Supersedes` (self-relation), `Deprecated` Status option, and the append-only Active convention. At this team scale, if a rule becomes wrong you edit the row or delete it — formal supersession is bureaucracy without a payoff. Schema goes from 9 fields to 8. Statuses go from 3 to 2 (Active / Proposed). Path B dedup/conflict check stays but now points users at "edit the row in Notion" instead of "log a supersession candidate".
- **2.3.1 — 05/15/2026** — Removed `Last verified` field and the staleness auto-flag. Time-based decay is paternalistic at a 3-designer scale — Active means Active until the team explicitly flips a rule to Deprecated.
- **2.3.0 — 05/15/2026** — Six fixes from the v2.2.x technical review:
  - **Audit precision (Batch 1).** New `Applies when` field on every decision — plain-language trigger condition that the audit step uses to filter applicable rules before judging. Path A step 4 now fetches the full database (not semantic search) and filters in-memory; step 5 only audits rules whose `Applies when` matches the frame. Kills the vibes-match problem.
  - **Lifecycle (Batch 2).** Added `Supersedes` (self-relation) and a new `Deprecated` Status option. Path B runs a pre-flight check for near-duplicates and contradictions against Active rules and offers a supersession flow when one's found. Active rows are now append-only by convention.
  - **Person resolution (Batch 3).** Replaced live Notion user search with a hardcoded team mapping table. Resolution is email-first, fails loudly when an email isn't mapped, never writes a blank Person.
  - **Figma MCP (Batch 4).** Path A step 2 now uses `mcp__claude_ai_Figma__get_metadata` / `get_design_context` / `get_screenshot` instead of `curl /v1/files/{key}/nodes`. REST `curl` kept as fallback for `boundVariables` only.
  - **Iconography simplification (Batch 5).** Dropped the 5-step `componentId` → `/v1/components/{key}` resolution. For Iconography decisions, the designer pastes the DS icon URL directly.
  - **Path C — pending review (Batch 6).** New read-only path that lists `Proposed` decisions, sorted by age, surfacing anything older than 7 days as *needs attention*.
- **2.2.0 — 05/15/2026** — Audit step now reads decisions for intent, not literally. "Primary action" means the dominant action in the view (visual weight), not `Variant: Primary` in Figma. The skill always renders the frame and judges hierarchy from the screenshot — a `Variant: Secondary` button styled as the dominant action still counts as the primary action for the audit.
- **2.1.0 — 05/15/2026** — Iconography decisions now resolve the Design reference to the DS icon component (via `/v1/components/{key}`) instead of the usage frame the user provided. A frame URL rots when the screen changes; the icon-component URL stays valid as long as the icon exists.
- **2.0.0 — 05/15/2026** — **Breaking:** slash command renamed from `/decisions` to `/design-decisions`. The old name was too generic — `decisions` could mean architecture, product, or anything else. The new name makes the design scope explicit and matches the plugin name. Skill folder renamed accordingly.
- **1.3.0 — 05/15/2026** — Added **Patterns** as a fifth category to cover container and interaction choices (modal vs drawer, confirmation patterns, navigation behavior) — closed a gap in the v1.2.0 narrowed list.
- **1.2.0 — 05/15/2026** — Category options narrowed to **Hierarchy**, **Iconography**, **Spacing**, **System states**. Copy, Clarity, DS compliance, and Accessibility removed — covered by `/copy`, `/qa`, and `/readiness`. Schema and Path B updated to enforce the fixed list.
- **1.1.0 — 05/14/2026** — Path B now collects `Category` and `Design reference` from the designer and auto-fills `Date of creation` with today's date. Schema in "Fixed resources" updated to match.
- **1.0.2 — 05/14/2026** — Output now leads with the verdict. Dropped the "what the team has decided" preamble and removed all names from the output — only decision text is shown.
- **1.0.1 — 05/14/2026** — Tightened Person resolution in Path B. The skill now pulls the active session user from the global Claude config / git config / `$USER` and looks up the matching Notion user automatically — no more asking *"who's making this call?"* on every log.
- **1.0.0 — 05/14/2026** — Initial release. Path A (look up decisions for a Figma frame, flag conflicts against Active rules) and Path B (log a new Proposed decision to Notion).

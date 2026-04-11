---
name: brain-absorb
description: Absorb the current conversation into the Obsidian brain — extract decisions, beliefs, and patterns, route them to the right domain agent (creating a new one if needed), and finish with an optional consolidation sweep. Invoke when the user asks to "全部吸わせて" / "今の会話を記憶に取り込んで" / "brain-absorb" / "absorb" / or similar one-shot capture requests.
---

# brain-absorb

One-shot pipeline that turns the *current conversation* into persistent brain state. This skill is the inverse of `/brain-search`: instead of *recalling* knowledge, it *deposits* knowledge — and it does the whole deposit in one call, including agent routing and optional cleanup.

It is NOT a passive hook. It runs only when the user explicitly asks Claude to absorb / capture / ingest the conversation.

## When to use

Invoke this skill when:

- The user says "今の会話を記憶して" / "全部吸わせて" / "absorb" / "brain-absorb" / "取り込んで"
- A long design / planning / decision-making conversation just wrapped up and the user wants a one-shot capture
- The user says "この会話から拾えるもの全部ブレインに入れて" or any equivalent phrasing
- After a deep exploration where many judgments, preferences, or new domains surfaced

## When NOT to use

- The user wants to look up what's already stored — use `/brain-search`
- The user wants to clean up bloat without adding new knowledge — use `/brain-consolidate`
- The user only wants to record a single fact — call `record_decision` / `evolve_belief` / `promote_pattern` directly, don't run the whole pipeline
- The user explicitly said "まだ記録しないで" / "draft だけ" — respect that and stop

## Pipeline overview

```
conversation
     │
     ▼
1. extract candidates   ← you do this in your head, not via a tool
     │
     ▼
2. list_agents()        ← know the current roster
     │
     ▼
3. route each candidate
     │
     ├── fits existing agent  →  record_decision / evolve_belief / promote_pattern
     │
     └── new domain          →  suggest_agents  →  (confirm)  →  create_agent  →  record_*
     │
     ▼
4. (optional) consolidate_memory per touched agent
     │
     ▼
5. report: what went where, what was created, what was skipped
```

## How to run

### Step 1 — Extract candidates from the conversation

Re-read the current conversation in your head and pull out every item that matches one of these categories. **You are the extractor — there is no tool for this.**

| Category | What to catch | Target tool |
|---|---|---|
| **Decision** | "〜にする" / "〜でいく" / "〜はやめる" / "A より B を選ぶ" — a choice with a rationale | `record_decision` |
| **Belief / value** | "〜が好き" / "〜は嫌い" / "〜が大事" / "〜は美しくない" — a preference, aesthetic, or policy statement, especially if it updates an earlier stance | `evolve_belief` (usually on `master`) |
| **Pattern** | A rule or habit that appeared ≥2 times, or a workflow the user confirmed works | `promote_pattern` |
| **New domain** | A brand-new project / hobby / role that no existing agent owns | `suggest_agents` → `create_agent` |
| **Correction** | The user explicitly told Claude "don't do X / do Y instead" — goes under the domain it corrected | `promote_pattern` (as a rule) or `evolve_belief` |

**Skip**:
- Jokes, small talk, empty affirmations ("ok", "thanks")
- Things already captured earlier in the same conversation (don't double-record)
- Ephemeral task state (current TODOs, in-progress files)
- Anything that would be more embarrassing than useful if recalled later

For each candidate, decide:
1. Which **category** it is
2. Which **target agent** it belongs to (match by domain — `master` for personality/values, other agents for their scope)
3. A **one-line rationale** so future-you can judge the edge case

Keep the candidates in a list you'll walk through in step 3.

### Step 2 — Get the agent roster

```
mcp__obsidian-brain__list_agents()
```

Use the result to:
- See which agents already exist (so you don't create duplicates)
- Match each candidate to an existing agent by scope
- Flag candidates that don't fit any existing agent as "new domain" items

### Step 3 — Route and write

Walk through the candidate list **sequentially** (parallel writes can race on the Vault):

#### 3a. Existing-agent candidates

```
mcp__obsidian-brain__record_decision({
  agent: "<agent_name>",
  decision: "<the decision itself>",
  context: "<why — the rationale from the conversation>",
  alternatives: ["<what was considered and rejected>", ...]  // optional
})
```

```
mcp__obsidian-brain__evolve_belief({
  agent: "<agent_name, usually master>",
  belief: "<the new or updated belief>",
  reason: "<what in the conversation triggered this update>",
  supersedes: "<earlier belief if this replaces one>"  // optional
})
```

```
mcp__obsidian-brain__promote_pattern({
  agent: "<agent_name>",
  pattern: "<the pattern/rule>",
  evidence: "<the 2+ instances or the confirmation>"
})
```

Use the tool that matches the category you assigned in step 1. Don't force one tool to do another's job — if in doubt, `evolve_belief` is the safest for value-statements, `record_decision` for choices, `promote_pattern` for repeated rules.

#### 3b. New-domain candidates

Before creating a new agent, always propose first:

```
mcp__obsidian-brain__suggest_agents({
  topic: "<the new domain>",
  context: "<why a new agent is needed — what the existing roster can't cover>"
})
```

Show the suggestion to the user and **wait for confirmation** before calling `create_agent`. Creating agents is a structural change to the brain — never do it silently.

On confirmation:

```
mcp__obsidian-brain__create_agent({
  name: "<short name>",
  scope: "<what this agent owns>",
  personality: "<tone/voice if relevant>",  // optional
  initial_beliefs: ["<seed belief 1>", "<seed belief 2>"]  // optional
})
```

Then immediately run the matching `record_*` calls against the new agent for any candidates that belong to it.

### Step 4 — Optional consolidation sweep

If step 3 added **≥10 entries to a single agent**, or if any touched agent was already close to its soft-cap, run consolidation on *just the touched agents* (not the whole brain — that's `/brain-consolidate`'s job):

```
mcp__obsidian-brain__consolidate_memory({
  agent: "<touched_agent>",
  dry_run: false
})
```

Run sequentially. Skip this step if fewer than 10 entries were added or nothing feels bloated — small deposits don't need cleanup.

### Step 5 — Report

Print a compact summary showing exactly what happened. Use this shape:

```
## Absorb summary (2026-04-12)

**Routed to existing agents**
- master: 2 beliefs (aesthetics, product direction)
- uibuilder: 1 decision (preview priority), 1 pattern (slot-based composition)
- love-machine: 1 decision (TS + Claude Agent SDK + Railway)

**New agents created**
- mobile-automation — scope: MobAI / device automation workflows
  - seeded with 2 beliefs, 1 decision

**Consolidated** (only agents that crossed threshold)
- uibuilder: 3 archived, 1 merged

**Skipped**
- 4 items judged as ephemeral task state
- 2 items already recorded earlier this session

Total written: 7 entries across 4 agents.
```

Keep the tone honest: if nothing was worth absorbing, say so. If a candidate was skipped, say *why* in one line. The user should trust the filter.

## Guardrails

- **Never create a new agent without confirmation.** `suggest_agents` first, wait, then `create_agent`.
- **Never write in parallel.** Vault writes can race. Sequential only.
- **Never record jokes, small talk, or session-local task state.** The `master` agent is not a diary.
- **Never duplicate.** If a candidate was already captured earlier in the same conversation (you saw yourself call `record_decision` for it, or `brain-search` returned an exact match), skip it and note the skip.
- **Master agent is the personality layer.** Only put values / aesthetics / identity-level things there. Operational rules go to the domain agent that owns them.
- **Honor "まだ記録しないで".** If the user adds a disclaimer mid-pipeline, stop immediately and show what you *would* have written as a draft.

## Example interaction

> **User:** この会話から拾えるもの全部 brain に入れといて
>
> **You (invoking this skill):**
>
> 1. Extract → 6 candidates: 2 beliefs for `master`, 1 decision for `uibuilder`, 1 pattern for `uibuilder`, 2 candidates for a new `mobile-automation` domain
> 2. `list_agents()` → master, uibuilder, love-machine (no mobile-automation)
> 3. Write 2 `evolve_belief` on master, 1 `record_decision` + 1 `promote_pattern` on uibuilder
> 4. `suggest_agents({ topic: "mobile automation / MobAI" })` → show proposal, ask user
> 5. On confirm: `create_agent({ name: "mobile-automation", ... })` then the 2 writes
> 6. No consolidation needed (all agents well under cap)
> 7. Print the summary table

## Notes

- このスキルは **書き込みを行う**。dry-run モードはない — extract 段階で厳しく絞るのが唯一のフィルタ
- 迷ったら記録せよ、ではなく **迷ったら skip せよ**。過剰蓄積は `/brain-consolidate` で後から回収できるが、誤記録は「嘘の記憶」として残り続ける
- 1会話に1回が健全。同じ会話で2回目を走らせるとほぼ確実に重複が出る
- 新エージェント作成は構造変更。必ず確認を取ってから `create_agent` を叩け
- 会話が長い場合、extract 段階で候補が20件を超えたら、まずユーザーに「このあたりを記録する予定だけどいい？」とリストを見せてから step 3 に進むのが親切

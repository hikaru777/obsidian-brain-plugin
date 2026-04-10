---
name: brain-consolidate
description: Consolidate and archive old memories across every domain agent. Invoke when the user asks to clean up the brain, when the SessionStart hook nudges it, or when an agent shows signs of bloat.
---

# brain-consolidate

Run memory consolidation across every domain agent so that old, redundant, or superseded entries are archived and the active knowledge base stays focused. This is how the brain stays "young" instead of collapsing under its own weight.

## When to use

Invoke this skill when:

- The user asks to clean up / consolidate / archive old memories ("整理して", "古いの片付けて")
- The SessionStart hook reminds the user to run it (typical: first session of the day)
- `/brain-status` showed a bloated agent (> 200 entries) or very stale entries
- The user just imported a large batch of notes with `import_notes` and wants deduplication

## When NOT to use

- The user is asking about specific knowledge — use `/brain-search`
- The user wants to create new knowledge — use `record_decision` / `evolve_belief` / `promote_pattern` directly
- The user explicitly said "keep everything" — consolidation archives, it does not delete, but respect the intent and confirm first

## How to run

1. **Get the agent roster**

   ```
   mcp__obsidian-brain__list_agents()
   ```

   Use this to know which agents to sweep, and to compare before/after counts.

2. **Optional: dry-run first for high-value agents**

   If any agent has > 100 entries or the user is nervous, do a dry-run pass first:

   ```
   mcp__obsidian-brain__consolidate_memory({
     agent: "<agent_name>",
     dry_run: true
   })
   ```

   Show the user what *would* be consolidated before touching anything. For small/default agents, skip straight to step 3.

3. **Run real consolidation per agent**

   Iterate over every agent and call:

   ```
   mcp__obsidian-brain__consolidate_memory({
     agent: "<agent_name>",
     dry_run: false
   })
   ```

   **Important:** run them sequentially, not in parallel — each pass may write to the Vault and you don't want racing writes.

4. **Aggregate and report**

   Show the user a per-agent summary:

   ```
   ## Consolidation summary (2026-04-11)

   | Agent   | Archived | Merged | Kept active |
   |---------|----------|--------|-------------|
   | master  |        2 |      1 |          14 |
   | tech    |       11 |      5 |          58 |
   | craft   |        0 |      0 |          11 |
   | default |        0 |      0 |           0 |

   Total: 13 archived, 6 merged. Brain is lighter by ~19 entries.
   ```

   If a run returned nothing to consolidate, say so — it's a good sign, not a failure.

5. **Post-consolidation check**

   After the sweep, offer to re-run `/brain-status` so the user can see the new shape of the brain.

## Special: SessionStart hook invocation

When this skill is triggered by the SessionStart hook rather than a direct user request, behave *less aggressively*:

- Do **not** run consolidation automatically. The hook only *reminds* the user.
- Output a single line: "古い記憶がたまってるよ。`/brain-consolidate` で整理する？" and wait.
- Only run it if the user confirms.

## Example interaction

> **User:** brain の掃除しといて
>
> **You (invoking this skill):**
> 1. `list_agents()` → 4 agents
> 2. Sequential `consolidate_memory({ agent: <name>, dry_run: false })` for each
> 3. Aggregate into the summary table
> 4. Offer to re-run `/brain-status`

## Notes

- このスキルは **書き込みを行う**。dry-run なしで走らせる前に、巨大な変更になりそうなら必ず一言確認を入れよ
- 消えるわけではなく「アーカイブされる」だけ。ユーザーにもそう伝えよ — 「消えちゃうの？」という不安を先に潰す
- 並列実行は禁止。Vault 書き込みが競合する
- master エージェントは特に慎重に。master は人格層なので、雑にアーカイブすると「AI の自己像」が薄まる

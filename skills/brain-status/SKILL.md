---
name: brain-status
description: Show an overview of all domain agents in the user's Obsidian brain — their knowledge counts, last-updated timestamps, and health signals. Invoke when the user wants to see what agents exist and how populated they are.
---

# brain-status

Give the user a one-shot status report of their entire Obsidian brain: every agent, how much it knows, when it was last updated, and which ones look unhealthy (empty, stale, or conflicted).

## When to use

Invoke this skill when:

- The user asks "what agents do I have?" / "今どのエージェントが生きてる？"
- The user wants a brain overview / health check / "ちゃんと育ってる？"
- The user is about to create a new agent and wants to see overlap with existing ones
- The first session of the day — as a quick sanity check of the state

## When NOT to use

- The user wants to search for specific knowledge — use `/brain-search`
- The user wants to create a new agent — use `mcp__obsidian-brain__create_agent` (or `suggest_agents` first if unsure of the domain)
- The user wants to consolidate / archive old memories — use `/brain-consolidate`

## How to run

1. **Fetch the agent roster with statistics**

   ```
   mcp__obsidian-brain__list_agents()
   ```

   The response includes each agent's name, description, and counts for beliefs / decisions / patterns (and possibly last-updated timestamps).

2. **Render as a formatted table**

   ```
   | Agent    | Description              | Beliefs | Decisions | Patterns | Last updated |
   |----------|--------------------------|---------|-----------|----------|--------------|
   | master   | 人格・価値観の統合層     |      12 |         3 |        5 | 2026-04-10   |
   | tech     | エンジニアリング判断     |      24 |        41 |        9 | 2026-04-11   |
   | craft    | 創作の美意識             |       8 |         2 |        1 | 2026-03-20   |
   | default  | 汎用ドメイン             |       0 |         0 |        0 | —            |
   ```

   Sort by "most active" (highest total counts or most recent update) so the user sees the healthy agents first.

3. **Add a totals line**

   ```
   **Total:** 4 agents / 44 beliefs / 46 decisions / 15 patterns
   ```

4. **Highlight health signals**

   Below the table, call out anything that needs attention:

   - **Empty agents** — zero knowledge across all three types. Suggest populating or deleting.
   - **Stale agents** — not updated in > 30 days. Suggest consolidation or a check-in.
   - **Bloated agents** — > 200 total entries. Suggest running `/brain-consolidate`.
   - **Missing master** — if `master` doesn't exist, nudge the user to create it (master holds the persona layer across domains).

   Example:

   > - `default` は空だよ。使ってないなら削除するか、最初の `record_decision` を走らせて中身を作ろう
   > - `craft` は3週間更新されてないね。最近の創作活動を `evolve_belief` で入れてあげる？

5. **Follow-up**

   End with one natural next action based on what you saw — don't list all options, pick the most relevant one.

## Example interaction

> **User:** 今どんな感じ？
>
> **You (invoking this skill):** `list_agents()` → 4 エージェント・総計 105 エントリ → テーブル表示 → `default` が空なことを指摘 → 「`default` は消す？」と聞く。

## Notes

- このスキルは read-only。副作用はない
- ユーザーが「status」と言っても、コードベースの git status を意図している場合は invoke しないこと
- 数字だけ並べず、必ず「何を意味するか」の一行を添える。ユーザーは数字を見たいのではなく健全性を知りたい

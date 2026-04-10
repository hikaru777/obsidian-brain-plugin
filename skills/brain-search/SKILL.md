---
name: brain-search
description: Search knowledge across all domain agents in your Obsidian brain. Invoke when the user asks what the brain knows about a topic, wants cross-domain discovery, or asks you to recall something that was recorded earlier.
---

# brain-search

Search beliefs, decisions, and patterns across every domain agent stored in the user's Obsidian brain, and present the results grouped by agent so the user sees which "mind" contributed what.

## When to use

Invoke this skill when:

- The user asks "what do my agents know about X?" / "何か記録してたっけ？"
- The user wants a cross-domain scan — they don't know *which* agent holds the answer
- The user is recalling a past decision or belief and wants the raw record, not just Claude's paraphrase
- An agent (e.g. master) needs to look up what a sibling agent thinks before answering

## When NOT to use

- The user asks about code in the current project — use `Grep` instead
- The user wants to **create or modify** knowledge — call the MCP tools (`record_decision`, `evolve_belief`, etc.) directly, not this skill
- The user wants a single-agent lookup and already knows which agent — use `mcp__obsidian-brain__query_agent`
- The user wants to see *all* agents as an overview — use `/brain-status`

## How to run

1. **Call the MCP tool**

   ```
   mcp__obsidian-brain__search_across_agents({
     query: "<the user's query, as close to their words as possible>",
     limit: 20    // optional, default tends to be reasonable
   })
   ```

   Keep the query in the user's natural language — do NOT pre-rewrite it. The search is designed to match semantic intent.

2. **Group results by agent**

   Present output as one section per agent that had a hit:

   ```
   ## tech (3 hits)
   - [decision] Postgres を選んだ理由: ... (2026-02-14)
   - [belief] ORM は薄いほどいい (last evolved 2026-03-02)
   - [pattern] migrations は常に up/down 両方書く

   ## craft (1 hit)
   - [belief] 余白は構造の一部だ (2026-01-20)
   ```

   Include the knowledge type (`decision` / `belief` / `pattern`), a short summary, and the date if available.

3. **Handle empty results**

   If nothing matches:

   - First suggest broadening the query (drop adjectives, try the core noun)
   - Then offer to run `mcp__obsidian-brain__list_agents` to show what agents exist — maybe the user expects knowledge in a domain that was never created

4. **Follow-up**

   After showing results, offer the natural next action:

   - "関連するものを記録する？" → `record_decision` / `evolve_belief`
   - "矛盾してないかチェックする？" → `detect_conflicts`
   - "別のエージェントにも聞く？" → `query_agent`

## Example interaction

> **User:** 過去にどのデータベースを選んだか記録あったっけ？
>
> **You (invoking this skill):** `search_across_agents({ query: "データベース選定" })` を実行 → tech エージェントから 2 件ヒット → グループ化して提示。

## Notes

- 日本語クエリでも英語クエリでも動く。ユーザーの言語に合わせよ
- 結果が多すぎる場合は `limit` を絞るのではなく、クエリを具体化するよう促す — 絞ると見落としが出る
- このスキルは read-only。副作用はない

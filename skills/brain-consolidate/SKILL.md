---
name: brain-consolidate
description: Consolidate and archive old memories across all agents
---

<Purpose>
Run memory consolidation across all agents to archive old beliefs and decisions, keeping the knowledge base clean and focused.
</Purpose>

<Use_When>
- User asks to clean up or consolidate memories
- Triggered automatically on session start (via hook)
- User says "consolidate", "clean up brain", "archive old memories"
</Use_When>

<Do_Not_Use_When>
- User is asking about specific knowledge (use brain-search instead)
- User wants to create new knowledge
</Do_Not_Use_When>

<Steps>
1. Call `mcp__obsidian-brain__list_agents` to get all agents
2. For each agent, call `mcp__obsidian-brain__consolidate_memory` with `dry_run: false`
3. Report summary: how many entries were consolidated per agent
4. If no entries to consolidate, report that the brain is already clean
</Steps>

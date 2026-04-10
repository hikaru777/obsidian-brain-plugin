---
name: brain-search
description: Search knowledge across all agents in your Obsidian brain
---

<Purpose>
Search across all domain agents' knowledge (beliefs, decisions, patterns) using keywords.
</Purpose>

<Use_When>
- User asks "what do my agents know about X?"
- User wants to find information across multiple domains
- User asks to search their brain/knowledge base
</Use_When>

<Do_Not_Use_When>
- User is asking about code in the current project (use Grep instead)
- User wants to create or modify knowledge (use the MCP tools directly)
</Do_Not_Use_When>

<Steps>
1. Use the `mcp__obsidian-brain__search_across_agents` tool with the user's query
2. Present the results grouped by agent
3. If no results, suggest broadening the search terms or checking available agents with `mcp__obsidian-brain__list_agents`
</Steps>

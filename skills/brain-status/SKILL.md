---
name: brain-status
description: Show the status of your Obsidian brain — all agents, their knowledge counts, and health
---

<Purpose>
Display an overview of all domain agents and their knowledge statistics.
</Purpose>

<Use_When>
- User asks "what agents do I have?"
- User wants a brain overview or status check
- User asks "how's my brain?"
</Use_When>

<Do_Not_Use_When>
- User wants to search for specific knowledge
- User wants to create a new agent
</Do_Not_Use_When>

<Steps>
1. Call `mcp__obsidian-brain__list_agents` to get all agents with statistics
2. Present as a formatted table: Agent Name | Description | Beliefs | Decisions | Patterns
3. Highlight any agents with zero knowledge (suggest populating them)
4. Show total counts across all agents
</Steps>

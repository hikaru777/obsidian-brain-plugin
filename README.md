# obsidian-brain — Claude Code Plugin

A Claude Code plugin that turns your Obsidian vault into a domain-specific AI brain with dynamic agent creation, knowledge management, and cross-agent intelligence.

## Installation

### Prerequisites

Set your Obsidian vault path:

```bash
export OBSIDIAN_BRAIN_VAULT_PATH="/path/to/your/obsidian-vault/AI Brain"
```

### Install the plugin

Add to your `~/.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "obsidian-brain": {
      "source": {
        "source": "github",
        "repo": "AtsushiHosaka/obsidian-brain-plugin"
      }
    }
  }
}
```

Then run:
```
claude plugin install obsidian-brain@obsidian-brain
```

## Skills

| Skill | Description |
|-------|-------------|
| `/brain-search` | Search knowledge across all agents |
| `/brain-consolidate` | Consolidate and archive old memories |
| `/brain-status` | Show brain overview and agent statistics |

## Features

- **14 MCP Tools** — Full agent knowledge management via Model Context Protocol
- **3 Skills** — Quick access to common operations via slash commands
- **Session Hook** — Reminder to consolidate memories on startup
- **Automatic** — Claude invokes tools contextually without manual commands

## Powered by

[obsidian-brain-mcp](https://github.com/AtsushiHosaka/obsidian-brain-mcp) — the core MCP server.

## License

MIT

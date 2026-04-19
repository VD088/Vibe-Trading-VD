# Vibe-Trading-VD — Agent Ownership

**Parent workspace:** `/Users/vd8/Documents/Claude/Trading/`
**Fork:** `VD088/Vibe-Trading-VD`

## Owned Files

| File | Purpose |
|------|---------|
| `vt.sh` | Headless CLI wrapper — primary interface |
| `agent/.env` | LLM provider config (Gemini default) |
| `agent/cli.py` | Core CLI entry point |
| `agent/src/providers/llm.py` | LLM factory with multi-provider support |
| `agent/src/agent/loop.py` | ReAct agent core loop |
| `agent/src/skills/` | 71 skill modules |
| `agent/config/swarm/` | 29 swarm preset YAMLs |
| `.mcp.json` | MCP server config for Claude Code |
| `CLAUDE.md` | Agent instructions |

## Responsibilities

- Provide AI swarm analysis via CLI (`vt.sh`)
- Maintain LLM provider configs (Gemini / Claude / DeepSeek)
- Keep skills and swarm presets updated
- Sync upstream changes from `HKUDS/Vibe-Trading`

## Key Entry Points

| Entry Point | Command | Purpose |
|-------------|---------|---------|
| Single run | `./vt.sh run "prompt"` | One-shot agent task |
| Swarm run | `./vt.sh swarm <preset> "prompt"` | Multi-agent team |
| MCP server | `./vt.sh mcp` | Claude Code tool provider |
| API server | `./vt.sh serve` | FastAPI for programmatic access |

## Dependencies

- Python 3.11+ with venv at `agent/.venv/`
- Gemini API key (primary)
- Anthropic API key (optional, for Claude mode)
- yfinance, ccxt (market data — free, no keys)

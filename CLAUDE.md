# Vibe-Trading-VD — CLAUDE.md

**Fork:** `VD088/Vibe-Trading-VD` (upstream: `HKUDS/Vibe-Trading`)
**Root:** `/Users/vd8/Documents/Claude/Trading/Vibe-Trading/`

## What This Is

AI Swarm of **29+ expert agent teams** and **71+ financial skills** — backtesting, technical analysis, SMC, harmonic patterns, crypto, options, macro, Pine Script generation, trade journaling, and more.

**This fork bypasses the React/Vite frontend.** All interaction happens via CLI (`vt.sh`) or MCP server — designed for Antigravity / Gemini / Claude / Claude Code.

## Quick Start

```bash
# From this directory:
./vt.sh run "Analyze BTC institutional levels on 1H"
./vt.sh swarm crypto_trading_desk "BTC setup analysis"
./vt.sh swarm technical_analysis_panel "ES 15m chart"
./vt.sh skills
./vt.sh presets
```

## Architecture

```
Vibe-Trading/
├── vt.sh                    ← Headless CLI wrapper (USE THIS)
├── agent/
│   ├── cli.py               ← Core CLI (vibe-trading command)
│   ├── api_server.py        ← FastAPI backend
│   ├── mcp_server.py        ← MCP server for Claude Code
│   ├── .env                 ← LLM provider config (Gemini default)
│   ├── src/
│   │   ├── agent/loop.py    ← ReAct agent core loop
│   │   ├── providers/llm.py ← LLM factory (Gemini/Claude/DeepSeek/etc)
│   │   ├── skills/          ← 71 skill modules
│   │   ├── swarm/           ← Swarm orchestration
│   │   └── tools/           ← Tool registry
│   └── config/swarm/        ← 29 swarm preset YAMLs
├── frontend/                ← React UI (NOT USED in this fork)
└── .mcp.json                ← MCP config for Claude Code
```

## LLM Provider Switching

```bash
./vt.sh provider           # Show current provider
./vt.sh use-gemini          # Gemini 2.5 Flash (default)
./vt.sh use-claude          # Claude Sonnet
./vt.sh use-deepseek        # DeepSeek via OpenRouter
```

Or directly edit `agent/.env`:
```
LANGCHAIN_PROVIDER=gemini
LANGCHAIN_MODEL_NAME=gemini-2.5-flash
```

## Key Swarm Presets

| Preset | Use Case |
|--------|----------|
| `crypto_trading_desk` | BTC/ETH/altcoin analysis |
| `technical_analysis_panel` | Multi-TF chart analysis |
| `macro_strategy_forum` | Macro outlook & rates |
| `sentiment_intelligence_team` | News & sentiment scan |
| `equity_research_team` | Stock fundamental analysis |
| `risk_committee` | Portfolio risk assessment |
| `quant_strategy_desk` | Quant strategy development |
| `ml_quant_lab` | ML model research |

## Integration with Existing Trading System

This swarm **complements** the existing agents:

| Agent | Role | Integration |
|-------|------|-------------|
| Market Open Agent | NY Open Brief | Can use VT skills for deeper analysis |
| Market Recap Agent | NY Close Recap | Can reference VT swarm outputs |
| Pinescript Agent | ORB Pro v2 | VT can generate Pine Script too (`./vt.sh pine`) |
| Trading Journal | Trade logging | VT has `trade-journal` skill |

## Rules

- **Never commit `.env` files** — they contain API keys
- **Use `vt.sh`** — not the frontend; headless-first workflow
- **Gemini is default** — switch to Claude for complex reasoning tasks
- **Swarm presets** are in `agent/config/swarm/*.yaml` — read them before creating new ones
- **Skills are modular** — each in `agent/src/skills/<name>/` with its own `.md` + `.yaml`

#!/usr/bin/env bash
# vt.sh — Headless Vibe-Trading CLI wrapper for Antigravity / Claude / Gemini
# Usage: ./vt.sh <command> [args...]
#
# This wrapper activates the venv and routes commands to vibe-trading CLI.
# Designed for non-interactive agentic use (no UI needed).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENT_DIR="$SCRIPT_DIR/agent"
VENV="$AGENT_DIR/.venv/bin/activate"

# Activate venv
if [ -f "$VENV" ]; then
    source "$VENV"
else
    echo "ERROR: Virtual environment not found at $VENV"
    echo "Run: python3.11 -m venv $AGENT_DIR/.venv && pip install -e ."
    exit 1
fi

# Load .env from agent dir
if [ -f "$AGENT_DIR/.env" ]; then
    set -a
    source "$AGENT_DIR/.env"
    set +a
fi

CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
    # ── Core Commands ──────────────────────────────────────────────
    run)
        # Single agent run: ./vt.sh run "Analyze BTC on 1H"
        vibe-trading -p "$*" --no-rich
        ;;
    run-json)
        # JSON output mode: ./vt.sh run-json "Analyze BTC"
        vibe-trading -p "$*" --json
        ;;
    chat)
        # Interactive chat: ./vt.sh chat
        vibe-trading chat
        ;;

    # ── Swarm Commands ─────────────────────────────────────────────
    swarm)
        # Run swarm preset: ./vt.sh swarm technical_analysis_panel "BTC analysis"
        PRESET="${1:-}"
        shift 2>/dev/null || true
        if [ -z "$PRESET" ]; then
            echo "Usage: ./vt.sh swarm <preset> [prompt]"
            echo "Run './vt.sh presets' to list available presets"
            exit 1
        fi
        VARS=""
        if [ $# -gt 0 ]; then
            VARS="{\"topic\": \"$*\"}"
        fi
        vibe-trading --swarm-run "$PRESET" "$VARS"
        ;;
    presets)
        # List swarm presets: ./vt.sh presets
        vibe-trading --swarm-presets
        ;;

    # ── Run Management ─────────────────────────────────────────────
    list)
        # List past runs: ./vt.sh list
        vibe-trading --list
        ;;
    show)
        # Show run details: ./vt.sh show <run_id>
        vibe-trading --show "$1"
        ;;
    continue)
        # Continue a run: ./vt.sh continue <run_id> "follow-up prompt"
        RUN_ID="${1:-}"
        shift 2>/dev/null || true
        vibe-trading --continue "$RUN_ID" "$*"
        ;;

    # ── Code & Output ──────────────────────────────────────────────
    code)
        # Show generated code: ./vt.sh code <run_id>
        vibe-trading --code "$1"
        ;;
    pine)
        # Extract Pine Script: ./vt.sh pine <run_id>
        vibe-trading --pine "$1"
        ;;

    # ── Skills & Info ──────────────────────────────────────────────
    skills)
        # List available skills: ./vt.sh skills
        vibe-trading --skills
        ;;
    version)
        vibe-trading --version
        ;;

    # ── Server ─────────────────────────────────────────────────────
    serve)
        # Start API server: ./vt.sh serve [--port 8899]
        vibe-trading serve "$@"
        ;;
    mcp)
        # Start MCP server: ./vt.sh mcp
        python -m mcp_server
        ;;

    # ── Provider Switching ─────────────────────────────────────────
    use-gemini)
        echo "Switching provider to Gemini..."
        sed -i '' 's/^LANGCHAIN_PROVIDER=.*/LANGCHAIN_PROVIDER=gemini/' "$AGENT_DIR/.env"
        sed -i '' 's/^LANGCHAIN_MODEL_NAME=.*/LANGCHAIN_MODEL_NAME=gemini-2.5-flash/' "$AGENT_DIR/.env"
        echo "Done. Provider: gemini / Model: gemini-2.5-flash"
        ;;
    use-claude)
        echo "Switching provider to Claude..."
        sed -i '' 's/^LANGCHAIN_PROVIDER=.*/LANGCHAIN_PROVIDER=anthropic/' "$AGENT_DIR/.env"
        sed -i '' 's/^LANGCHAIN_MODEL_NAME=.*/LANGCHAIN_MODEL_NAME=claude-sonnet-4-20250514/' "$AGENT_DIR/.env"
        echo "Done. Provider: anthropic / Model: claude-sonnet-4-20250514"
        ;;
    use-deepseek)
        echo "Switching provider to DeepSeek via OpenRouter..."
        sed -i '' 's/^LANGCHAIN_PROVIDER=.*/LANGCHAIN_PROVIDER=openrouter/' "$AGENT_DIR/.env"
        sed -i '' 's/^LANGCHAIN_MODEL_NAME=.*/LANGCHAIN_MODEL_NAME=deepseek\/deepseek-v3.2/' "$AGENT_DIR/.env"
        echo "Done. Provider: openrouter / Model: deepseek/deepseek-v3.2"
        ;;
    provider)
        # Show current provider: ./vt.sh provider
        grep "^LANGCHAIN_PROVIDER=" "$AGENT_DIR/.env"
        grep "^LANGCHAIN_MODEL_NAME=" "$AGENT_DIR/.env"
        ;;

    # ── Help ───────────────────────────────────────────────────────
    help|--help|-h)
        cat <<'EOF'
╔══════════════════════════════════════════════════════════════╗
║  vt.sh — Headless Vibe-Trading CLI                         ║
║  Bypass the web UI. Drive 71 skills + 29 swarms from CLI.  ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  CORE                                                        ║
║    run <prompt>        Single agent run (text output)        ║
║    run-json <prompt>   Single agent run (JSON output)        ║
║    chat                Interactive chat mode                 ║
║                                                              ║
║  SWARM                                                       ║
║    swarm <preset> <p>  Run swarm team preset                 ║
║    presets              List available swarm presets          ║
║                                                              ║
║  RUNS                                                        ║
║    list                 List past runs                       ║
║    show <id>            Show run details                     ║
║    continue <id> <p>    Continue existing run                ║
║    code <id>            Show generated code                  ║
║    pine <id>            Extract Pine Script                  ║
║                                                              ║
║  INFO                                                        ║
║    skills               List 71+ available skills            ║
║    version              Show version                         ║
║    provider              Show current LLM provider           ║
║                                                              ║
║  PROVIDER                                                    ║
║    use-gemini            Switch to Gemini 2.5 Flash          ║
║    use-claude            Switch to Claude Sonnet             ║
║    use-deepseek          Switch to DeepSeek via OpenRouter   ║
║                                                              ║
║  SERVER                                                      ║
║    serve [--port N]      Start API server                    ║
║    mcp                   Start MCP server                    ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
        ;;
    *)
        echo "Unknown command: $CMD"
        echo "Run './vt.sh help' for usage"
        exit 1
        ;;
esac

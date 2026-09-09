#!/usr/bin/env sh
set -eu

SKIP_INSTALL=${SKIP_INSTALL:-0}
_SCRIPT_DIR="$(CDPATH= cd "$(dirname "$0")" && pwd)"
. "$_SCRIPT_DIR/setup_helpers.sh"

_python_script="$(mktemp -t dotfiles-smoke-check.XXXXXX.py)"
cleanup() {
  cleanup_run_log
  rm -f "$_python_script"
}
trap cleanup EXIT

# Hermes-side wiring is secondary (doctor only warns); the smoke still pins it.
cat >"$_python_script" <<'PY'
from pathlib import Path
import yaml

config = yaml.safe_load((Path.home() / ".hermes" / "config.yaml").read_text())
servers = config.get("mcp_servers", {})
for name in ("codebase-memory-mcp", "agentmemory"):
    assert name in servers, f"~/.hermes/config.yaml missing {name} MCP entry"
assert config.get("memory", {}).get("provider") == "agentmemory", (
    "~/.hermes/config.yaml missing memory.provider=agentmemory"
)
PY

if [ "$SKIP_INSTALL" != "1" ]; then
  echo "[1/7] Installing agentic-env CLI"
  run_cmd "uv tool install --force ."
fi

if [ "$SKIP_INSTALL" != "1" ]; then
  echo "[2/7] Running one-shot bootstrap"
  run_cmd "agentic-bootstrap"

  echo "[3/7] Verifying root script wrappers"
  run_cmd "uv run --with rich python -c 'import agentic_env.bootstrap, agentic_env.configure_agent_mcps, agentic_env.install_agents, agentic_env.install_skills_mcps, agentic_env.stack_doctor, agentic_env.update_agentic_stack'"
  run_cmd "uv run --script bootstrap.py --help"
  run_cmd "uv run --script install-agents.py --help"
  run_cmd "uv run --script install-skills-mcps.py --help"
  run_cmd "uv run --script configure-agent-mcps.py --help"
  run_cmd "uv run --script update-agentic-stack.py --help"
  run_cmd "uv run --script stack-doctor.py --help"
fi

if [ "$SKIP_INSTALL" != "1" ]; then
  echo "[6/7] Verifying installed binaries"
else
  echo "[6/7] Verifying installed binaries (SKIP_INSTALL=1)"
fi

failures=0

require_command() {
  cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "✓ command exists: $cmd"
    if "$cmd" --help >/dev/null 2>&1 || "$cmd" -h >/dev/null 2>&1 || "$cmd" --version >/dev/null 2>&1 || "$cmd" -V >/dev/null 2>&1 || "$cmd" version >/dev/null 2>&1; then
      echo "✓ smoke callable: $cmd"
    else
      echo "✗ smoke callable failed: $cmd"
      failures=$((failures + 1))
    fi
  else
    echo "✗ missing command: $cmd"
    failures=$((failures + 1))
  fi
}

if [ "$SKIP_INSTALL" != "1" ]; then
  require_command agentic-bootstrap
  require_command agentic-install-agents
  require_command agentic-install-skills-mcps
  require_command agentic-configure-agent-mcps
  require_command agentic-update-stack
  require_command agentic-stack-doctor
fi

require_command hermes
require_command omp
require_command codex
require_command claude
require_command codebase-memory-mcp
require_command agentmemory

echo "[7/7] Verifying stack wiring (agentic-stack-doctor) and Hermes config artifacts"
run_cmd "agentic-stack-doctor"
run_cmd "uv run --with pyyaml python $_python_script"

if [ "$failures" -ne 0 ]; then
  echo "Failed checks: $failures"
  exit 1
fi

echo "Smoke test complete"
exit 0

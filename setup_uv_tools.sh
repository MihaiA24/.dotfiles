#Python tools that can be installed with uv and used globally
_SCRIPT_DIR="$(CDPATH= cd "$(dirname "$0")" && pwd)"
. "$_SCRIPT_DIR/agentic-env/setup_helpers.sh"

run_cmd "uv tool install claude-monitor"

echo "setup_uv_tools complete"

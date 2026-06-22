#!/usr/bin/env bash
# setup_non_brew.sh
# Tools installed outside of Homebrew.
# Run individual sections as needed — this script is for reference/documentation,
# not intended to be executed top-to-bottom blindly.

set -euo pipefail

VERBOSE="${VERBOSE:-0}"
for arg in "$@"; do
  case "$arg" in
    -v|--verbose)
      VERBOSE=1
      ;;
    *)
      ;;
  esac
done
export VERBOSE
_run_log="$(mktemp -t dotfiles-run.XXXXXX)"
cleanup_run_log() {
  rm -f "$_run_log"
}
trap cleanup_run_log EXIT

run_cmd() {
  : >"$_run_log"
  if [ "$VERBOSE" != "1" ]; then
    echo "Running: $*"
  fi
  if [ "$VERBOSE" = "1" ]; then
    sh -c "$*"
    return
  fi

  if ! sh -c "$*" >"$_run_log" 2>&1; then
    echo "Command failed: $*" >&2
    cat "$_run_log" >&2
    return 1
  fi
}

# ── AI tools ───────────────────────────────────────────────────────────────────
# Installs to ~/.local/bin/claude
# https://claude.ai/download
install_claude() {
  run_cmd "curl -fsSL https://claude.ai/install.sh | bash"
}

# Hermes Agent CLI
# https://github.com/NousResearch/hermes-agent
install_hermes_agent() {
  run_cmd "curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash"
}

# Understand-Anything plugin for Hermes
# https://github.com/Lum1104/Understand-Anything
install_understand_anything_hermes() {
  run_cmd "curl -fsSL https://raw.githubusercontent.com/Lum1104/Understand-Anything/main/install.sh | bash -s hermes"
}

# LeanCTX context layer
# https://github.com/yvgude/lean-ctx
install_lean_ctx() {
  run_cmd "curl -fsSL https://leanctx.com/install.sh | sh"
}

# Oh My Pi / Pi Coding Agent
# https://github.com/can1357/oh-my-pi
install_oh_my_pi() {
  run_cmd "curl -fsSL https://omp.sh/install | sh"
}

# ── Rust + Cargo ───────────────────────────────────────────────────────────────
# Installs rustup, rustc, cargo to ~/.cargo/bin/
# https://rustup.rs
install_rust() {
  run_cmd "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
}

# ── Cargo crates ──────────────────────────────────────────────────────────────
# Run after Rust is installed. These are not managed by Homebrew.
install_cargo_crates() {
  run_cmd "cargo install loco-cli"
  run_cmd "cargo install rustlings"
}

# ── zsh4humans (z4h) ──────────────────────────────────────────────────────────
# Bootstrapped automatically by .zshenv on first shell launch — no manual install needed.
# z4h installs Powerlevel10k as a theme but does NOT install fonts.
# Fonts are handled via Homebrew cask "font-meslo-lg-nerd-font" (see Brewfile).
# Manual install only if bootstrapping fails:
install_z4h() {
  if command -v curl >/dev/null; then
    run_cmd "curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install | sh"
  else
    run_cmd "wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install | sh"
  fi
}

# ── uv (Python package manager) — Linux only ──────────────────────────────────
# On macOS, uv is managed via Homebrew (see Brewfile).
# On Linux, install via the standalone installer:
install_uv_linux() {
  run_cmd "curl -LsSf https://astral.sh/uv/install.sh | sh"
}

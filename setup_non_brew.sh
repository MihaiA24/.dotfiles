#!/usr/bin/env bash
# setup_non_brew.sh
# Tools installed outside of Homebrew.
# Run individual sections as needed — this script is for reference/documentation,
# not intended to be executed top-to-bottom blindly.

set -euo pipefail

# ── Claude Code CLI ────────────────────────────────────────────────────────────
# Installs to ~/.local/bin/claude
# https://claude.ai/download
install_claude() {
  curl -fsSL https://claude.ai/install.sh | bash
}

# ── Rust + Cargo ───────────────────────────────────────────────────────────────
# Installs rustup, rustc, cargo to ~/.cargo/bin/
# https://rustup.rs
install_rust() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

# ── Cargo crates ──────────────────────────────────────────────────────────────
# Run after Rust is installed. These are not managed by Homebrew.
install_cargo_crates() {
  cargo install loco-cli
  cargo install rustlings
}

# ── zsh4humans (z4h) ──────────────────────────────────────────────────────────
# Bootstrapped automatically by .zshenv on first shell launch — no manual install needed.
# z4h installs Powerlevel10k as a theme but does NOT install fonts.
# Fonts are handled via Homebrew cask "font-meslo-lg-nerd-font" (see Brewfile).
# Manual install only if bootstrapping fails:
install_z4h() {
  if command -v curl &>/dev/null; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
  else
    sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
  fi
}

# ── uv (Python package manager) — Linux only ──────────────────────────────────
# On macOS, uv is managed via Homebrew (see Brewfile).
# On Linux, install via the standalone installer:
install_uv_linux() {
  curl -LsSf https://astral.sh/uv/install.sh | sh
}

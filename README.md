# .dotfiles

## Keeping the Brewfile up to date

After installing or removing packages, regenerate the Brewfile to reflect the current state:

```bash
# Overwrite Brewfile with everything currently installed
brew bundle dump --file=~/.dotfiles/Brewfile --force

# Then review the diff and commit
git -C ~/.dotfiles diff Brewfile
git -C ~/.dotfiles add Brewfile && git -C ~/.dotfiles commit -m "(auto) Updated Brewfile"
```

To install everything from the Brewfile on a new machine:

```bash
brew bundle --file=~/.dotfiles/Brewfile
```

## Fish plugins

Fish plugins are declared in [`fish/fish_plugins`](./fish/fish_plugins).
`setup_sym_links_cachyos.sh` bootstraps Fisher and runs `fisher update` after
linking `~/.config/fish`; generated Tide functions/completions are not tracked.
Only the canonical `fish/fish_variables` file is kept in git.

## Non-Homebrew installs

Tools installed outside of Homebrew are documented in [`setup_non_brew.sh`](./setup_non_brew.sh). The file is structured as named functions — source or copy the relevant section rather than running the whole script.

### AI tools

| Tool | Install method |
|---|---|
| Claude Code CLI | `curl -fsSL https://claude.ai/install.sh \| bash` |
| Hermes Agent | `curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh \| bash` |
| Understand-Anything for Hermes | `curl -fsSL https://raw.githubusercontent.com/Lum1104/Understand-Anything/main/install.sh \| bash -s hermes` |
| LeanCTX | `curl -fsSL https://leanctx.com/install.sh \| sh` |
| Oh My Pi / Pi Coding Agent | `curl -fsSL https://omp.sh/install \| sh` |

### Other tools

| Tool | Install method |
|---|---|
| Rust + Cargo | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` |
| zsh4humans | Auto-bootstrapped by `.zshenv`; see `install_z4h()` in the script |
| uv (Linux) | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| Docker (Linux) | `curl -fsSL https://get.docker.com \| bash` |
| Powerlevel10k fonts (Linux) | See `install_p10k_fonts_linux()` in the script |


## Agentic environment bootstrap

The agent tooling stack can be installed and validated from a fresh container using
the `agentic-env` compose smoke-test setup.

- See [`agentic-env/README.md`](./agentic-env/README.md) for:
  - build/run instructions
  - fresh-install smoke contract
  - image-size/tradeoff rationale and compatibility notes
- CI gate:
  - `.github/workflows/agentic-env-smoke-test.yml` runs fresh-install smoke checks on:
    - `push` / `pull_request` for changes under `agentic-env/`
    - `workflow_dispatch` / UI **Run workflow** for manual trigger
- Design decision log:
  - [`agentic-env/docs/CONTEXT.md`](./agentic-env/docs/CONTEXT.md)
  - [`agentic-env/docs/adr/0001-container-base-for-fresh-agent-installs.md`](./agentic-env/docs/adr/0001-container-base-for-fresh-agent-installs.md)
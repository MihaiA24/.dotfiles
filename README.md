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
| Oh My Pi / Pi Coding Agent | `curl -fsSL https://omp.sh/install \| sh` |

### Other tools

| Tool | Install method |
|---|---|
| Rust + Cargo | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` |
| zsh4humans | Auto-bootstrapped by `.zshenv`; see `install_z4h()` in the script |
| uv (Linux) | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| Docker (Linux) | `curl -fsSL https://get.docker.com \| bash` |
| Powerlevel10k fonts (Linux) | See `install_p10k_fonts_linux()` in the script |


## Agentic environment and skill installation

The agent stack (OMP/Hermes provisioning, curated skills, MCPs, hooks and the stack doctor) moved to a separate private repository, `MihaiA24/agentic-env`, which keeps its history up to the split. [`d479743`](https://github.com/MihaiA24/.dotfiles/tree/d479743315c6611ae4df4799a9dc573ab63ed478/agentic-env) is the last public commit with that code here.
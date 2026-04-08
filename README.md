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

## Non-Homebrew installs

Tools installed outside of Homebrew are documented in [`setup_non_brew.sh`](./setup_non_brew.sh). The file is structured as named functions — source or copy the relevant section rather than running the whole script.

| Tool | Install method |
|---|---|
| Claude Code CLI | `curl -fsSL https://claude.ai/install.sh \| bash` |
| Rust + Cargo | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` |
| zsh4humans | Auto-bootstrapped by `.zshenv`; see `install_z4h()` in the script |
| uv (Linux) | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| Docker (Linux) | `curl -fsSL https://get.docker.com \| bash` |
| Powerlevel10k fonts (Linux) | See `install_p10k_fonts_linux()` in the script |

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

Choose the [installation route](./agentic-env/README.md#choose-an-installation-path) for the task:

- **Full agent stack, macOS/Linux:** [bootstrap and prerequisites](./agentic-env/README.md#quick-usage), then the [clean-platform acceptance runbook](./agentic-env/README.md#clean-platform-acceptance).
- **Existing OMP host:** [refresh managed skills](./agentic-env/README.md#refresh-skills-on-an-existing-omp-host) without reinstalling agents or MCPs.
- **Another harness's directory:** [copy selected curated packs](./agentic-env/README.md#install-into-another-harnesss-directory) with the native skills CLI.
- **Windows or offline copying:** [Python-only runbook](./agentic-env/README.md#python-only-copy-on-windows), using the vendored packages; this does not provision the Windows agent stack.
- **Existing standalone copies:** [verify and refresh safely](./agentic-env/README.md#verify-and-refresh-standalone-copies); global doctor, drift and update commands do not manage these destinations.

The [CI workflow](./.github/workflows/agentic-env-smoke-test.yml) runs full-stack macOS/Linux acceptance and a separate Windows copier-only check on relevant pushes/PRs, or through **Run workflow**. [Recorded evidence](./agentic-env/README.md#ci-and-recorded-evidence) names the scope of each result.

Policy: [operative decisions](./agentic-env/DECISIONS_AI_TOOLING.md), [domain vocabulary](./agentic-env/docs/CONTEXT.md), and [ADRs](./agentic-env/docs/adr/).
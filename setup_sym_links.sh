_SCRIPT_DIR="$(CDPATH= cd "$(dirname "$0")" && pwd)"
. "$_SCRIPT_DIR/agentic-env/setup_helpers.sh"

run_cmd "rm ~/.zshrc"
run_cmd "rm ~/.zshenv"
run_cmd "rm ~/.gitconfig"
run_cmd "rm ~/.p10k.zsh"

run_cmd "ln -s ~/.dotfiles/.zshrc ~/.zshrc"
run_cmd "ln -s ~/.dotfiles/.zshenv ~/.zshenv"
run_cmd "ln -s ~/.dotfiles/.gitconfig ~/.gitconfig"
run_cmd "ln -s ~/.dotfiles/.p10k.zsh ~/.p10k.zsh"


echo "setup_sym_links complete"

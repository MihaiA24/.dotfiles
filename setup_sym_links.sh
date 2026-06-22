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

run_cmd "rm ~/.zshrc"
run_cmd "rm ~/.zshenv"
run_cmd "rm ~/.gitconfig"
run_cmd "rm ~/.p10k.zsh"

run_cmd "ln -s ~/.dotfiles/.zshrc ~/.zshrc"
run_cmd "ln -s ~/.dotfiles/.zshenv ~/.zshenv"
run_cmd "ln -s ~/.dotfiles/.gitconfig ~/.gitconfig"
run_cmd "ln -s ~/.dotfiles/.p10k.zsh ~/.p10k.zsh"


echo "setup_sym_links complete"

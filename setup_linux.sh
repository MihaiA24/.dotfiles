# In this scripts go all CMD lines that can be executed from scratch without 0 addional config or manual download

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

run_cmd "sudo apt update && sudo apt upgrade -y"

# First add source repositories
run_cmd "sh ./setup_source_repositories.sh"

# Install 1Password
run_cmd "sudo apt update && sudo apt install 1password"

# Install Brave Browser
run_cmd "curl -fsS https://dl.brave.com/install.sh | sh"

# Install ZED editor
run_cmd "curl -f https://zed.dev/install.sh | sh"

# Install UV python package manager
run_cmd "curl -LsSf https://astral.sh/uv/install.sh | sh"

# Install Homebrew
run_cmd "curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | sh"
run_cmd "sudo apt-get install build-essential" # Homebrew recommendation
run_cmd "/home/linuxbrew/.linuxbrew/bin/brew bundle install --file=./Brewfile"

# Download first p10k fonts
run_cmd "curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf --output 'MesloGS NF Regular.ttf'"
run_cmd "curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf --output 'MesloGS NF Bold.ttf'"
run_cmd "curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf --output 'MesloGS NF Italic.ttf'"
run_cmd "curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf --output 'MesloGS NF Bold Italic.ttf'"

run_cmd "mkdir -p ~/.local/share/fonts"
run_cmd "mv *.ttf ~/.local/share/fonts"
run_cmd "fc-cache -f -v" # Refresh font cache

# Install JAVA
run_cmd "sudo apt install openjdk-17-jdk"

# Install Docker
run_cmd "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
run_cmd "sudo usermod -aG docker ${USER}"

# Last create sym links to .dotfiles repositores
run_cmd "sh setup_sym_links.sh"
run_cmd "Z4H_BOOTSTRAPPING=1 . ~/.zshenv"

echo "setup_linux complete"

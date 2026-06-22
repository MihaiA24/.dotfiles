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

###### 1Password repository ######

## Add the key for the 1Password apt repository
run_cmd "curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg"
## Add the 1Password apt repository
run_cmd "echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list"
## Add the debsig-verify policy
run_cmd "sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/"
run_cmd "curl -sS https://downloads.1password.com/linux/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol"
run_cmd "sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22"
run_cmd "curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg"

###### 1Password repository ######

###### Docker repository #########
# Add Docker's official GPG key:
run_cmd "sudo apt-get update"
run_cmd "sudo apt-get install ca-certificates curl"
run_cmd "sudo install -m 0755 -d /etc/apt/keyrings"
run_cmd "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc"
run_cmd "sudo chmod a+r /etc/apt/keyrings/docker.asc"

# Add the repository to Apt sources:
run_cmd "echo \
  'deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo \"${UBUNTU_CODENAME:-$VERSION_CODENAME}\") stable' | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"
run_cmd "sudo apt-get update"

###### Docker repository #########
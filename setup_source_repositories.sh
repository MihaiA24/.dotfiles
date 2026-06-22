# In this scripts go all CMD lines that can be executed from scratch without 0 addional config or manual download

_SCRIPT_DIR="$(CDPATH= cd "$(dirname "$0")" && pwd)"
. "$_SCRIPT_DIR/agentic-env/setup_helpers.sh"

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
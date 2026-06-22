# In this scripts go all CMD lines that can be executed from scratch without 0 addional config or manual download

_SCRIPT_DIR="$(CDPATH= cd "$(dirname "$0")" && pwd)"
. "$_SCRIPT_DIR/agentic-env/setup_helpers.sh"

run_cmd "sudo paru" # Update all installed

# Code tools
run_cmd "paru -S zed"
run_cmd "paru -S visual-studio-code-bin" # alternative paru -S code # This is the open source version
run_cmd "paru -S jetbrains-toolbox"
run_cmd "paru -S dbeaver" # Open source database management tool
run_cmd "paru -S bruno" # Postman alternative
run_cmd "paru -S ghostty" # Terminal
run_cmd "paru -S claude-code"
run_cmd "paru -S gemini-cli"
run_cmd "paru -S windsurf"
# run_cmd "paru -S ollama-cuda" # Install if using local LLMs

# Programming languages software
run_cmd "paru -S uv" # Package manager for python
# run_cmd "paru -S miniconda3" # Using uv by default
run_cmd "paru -S paru -S jdk21-openjdk" # The openjdk is availiable in cachy os ryzen repo
run_cmd "paru -S rustup"

# Other programs
run_cmd "paru -S telegram-desktop"
run_cmd "paru -S megasync-bin" # Mega sync cloud
run_cmd "paru -S qbittorrent" # Open source torrent client
run_cmd "paru -S discord"
run_cmd "paru -S google-chrome" # Chrome browser
run_cmd "paru -S brave-bin" # Brave browser
run_cmd "paru -S anytype-bin" # P2P note taking app
run_cmd "paru -S vlc vlc-plugins-all"
run_cmd "paru -S mission-center" # Windows like System Monitor
run_cmd "paru -S todoist-appimage" # Daily planner app

# Command line tools
run_cmd "paru -S btop" # Modern top
run_cmd "paru -S nvtop" # Modern top for nvidia GPU
run_cmd "paru -S ncdu" # Modern du
run_cmd "paru -S zip"
run_cmd "paru -S neovim"
run_cmd "paru -S aws-cli-v2"

# Already installed package by default installation in CachyOS
# run_cmd "paru -S exa" # Modern ls
# run_cmd "paru -S bat" # Modern cat
# run_cmd "paru -S fd" # Modern find
# run_cmd "paru -S duf" # Modern df
# run_cmd "paru -S tldr" # Modern man

# Proton suite
run_cmd "paru -S proton-pass"
run_cmd "paru -S proton-vpn-gtk-app" # Official Proton VPN app, available in CachyOS Repo

# Docker
run_cmd "paru -S docker docker-buildx docker-compose"
run_cmd "paru -S nvidia-container-toolkit" # Use docker with GPU support
run_cmd "sudo systemctl start docker"
run_cmd "sudo systemctl enable docker"
run_cmd "sudo usermod -aG docker $USER"

run_cmd "paru -S balena-etcher"
run_cmd "paru -S bitwarden"
run_cmd "paru -S dos2unix"
run_cmd "paru -S flameshot"
run_cmd "paru -S gnome-boxes"
run_cmd "paru -S graphviz"
run_cmd "paru -S mise" # The front-end to your dev env. Use multiple versions on same system
run_cmd "paru -S snapper" # CachyOS Btrfs automatic snapshots
run_cmd "paru -S speedtest++"
run_cmd "paru -S superfile" # Fancy terminal file manager
run_cmd "paru -S todoist-rs"
run_cmd "paru -S gnome-shell-extension-installer" # Use: gnome-shell-extension-installer <extension-id>

# Install rust packages cli
run_cmd "cargo install lean-ctx"

echo "setup_linux_cachyos complete"

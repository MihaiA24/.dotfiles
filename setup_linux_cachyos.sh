# In this scripts go all CMD lines that can be executed from scratch without 0 addional config or manual download

sudo paru # Update all installed


# Code tools
paru -S zed
paru -S visual-studio-code-bin # alternative paru -S code # This is the open source version
paru -S jetbrains-toolbox
paru -S dbeaver # Open source database management tool
paru -S bruno # Postman alternative
paru -S ghostty # Terminal
paru -S claude-code
paru -S gemini-cli
paru -S windsurf
# paru -S ollama-cuda # Install if using local LLMs


# Programming languages software
paru -S uv # Package manager for python
# paru -S miniconda3 # Using uv by default
paru -S paru -S jdk21-openjdk # The openjdk is availiable in cachy os ryzen repo
paru -S rustup

# Other programs
paru -S telegram-desktop
paru -S megasync-bin # Mega sync cloud
paru -S qbittorrent # Open source torrent client
paru -S discord
paru -S google-chrome # Chrome browser
paru -S brave-bin # Brave browser
paru -S anytype-bin # P2P note taking app
paru -S vlc vlc-plugins-all
paru -S mission-center # Windows like System Monitor
paru -S todoist-appimage # Daily planner app


## Command line tools
paru -S btop # Modern top
paru -S nvtop # Modern top for nvidia GPU
paru -S ncdu # Modern du
paru -S zip
paru -S neovim
paru -S aws-cli-v2

# Already installed package by default installation in CachyOS
# paru -S exa # Modern ls
# paru -S bat # Modern cat
# paru -S fd # Modern find
# paru -S duf # Modern df
# paru -S tldr # Modern man


# Proton suite
paru -S proton-pass
paru -S proton-vpn-gtk-app # Official Proton VPN app, available in CachyOS Repo


# Docker
paru -S docker docker-buildx docker-compose
paru -S nvidia-container-toolkit # Use docker with GPU support
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER


paru -S balena-etcher
paru -S bitwarden
paru -S dos2unix
paru -S flameshot
paru -S gnome-boxes
paru -S graphviz
paru -S mise # The front-end to your dev env. Use multiple versions on same system
paru -S snapper # CachyOS Btrfs automatic snapshots
paru -S speedtest++
paru -S superfile # Fancy terminal file manager
paru -S todoist-rs
paru -S gnome-shell-extension-installer # Use: gnome-shell-extension-installer <extension-id>

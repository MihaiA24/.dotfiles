# In this scripts go all CMD lines that can be executed from scratch without 0 addional config or manual download

sudo paru # Update all installed

paru -S zed
paru -S 1password
paru -S visual-studio-code-bin # alternative paru -S code # This is the open source version
paru -S jetbrains-toolbox
paru -S paru -S jdk21-openjdk # The openjdk is availiable in cachy os ryzen repo
paru -S ghostty # Terminal
paru -S rustup
rustup default stable # Install rust stable version
paru -S miniconda3
paru -S bruno
paru -S telegram-desktop
paru -S megasync-bin
paru -S qbittorrent
paru -S dbeaver
paru -S zip

paru -S btop # Modern top
paru -S nvtop # Modern top for nvidia GPU
paru -S ncdu # Modern du
# Already installed package by default installation in CachyOS
# paru -S exa # Modern ls
# paru -S bat # Modern cat
# paru -S fd # Modern find
# paru -S duf # Modern df
# paru -S tldr # Modern man


# Proton suite
paru -S proton-pass
paru -S proton-vpn-gtk-app # Official Proton VPN app, available in CachyOS Repo


paru -S vlc
paru -S mission-center # Windows like System Monitor

# Docker
paru -S docker
paru -S nvidia-container-toolkit # Use docker with GPU support
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER


# Install Homebrew
# TODO: Don't know if its is necesary having paru
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# sudo apt-get install build-essential # Homebrew recommendation
# /home/linuxbrew/.linuxbrew/bin/brew bundle install --file=./Brewfile

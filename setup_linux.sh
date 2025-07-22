# In this scripts go all CMD lines that can be executed from scratch without 0 addional config or manual download

sudo apt update && sudo apt upgrade -y

# First add source repositories
sh ./setup_source_repositories.sh

# Install 1Password
sudo apt update && sudo apt install 1password


# Install Brave Browser
curl -fsS https://dl.brave.com/install.sh | sh


# Install ZED editor
curl -f https://zed.dev/install.sh | sh


# Install UV python package manager
curl -LsSf https://astral.sh/uv/install.sh | sh


# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo apt-get install build-essential # Homebrew recommendation
/home/linuxbrew/.linuxbrew/bin/brew bundle install --file=./Brewfile

# Download first p10k fonts
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf --output 'MesloGS NF Regular.ttf'
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf --output 'MesloGS NF Bold.ttf'
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf --output 'MesloGS NF Italic.ttf'
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf --output 'MesloGS NF Bold Italic.ttf'

mkdir -p ~/.local/share/fonts
mv *.ttf ~/.local/share/fonts
fc-cache -f -v # Refresh font cache


# Install JAVA
sudo apt install openjdk-17-jdk

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker ${USER}

# Last create sym links to .dotfiles repositores
sh setup_sym_links.sh
Z4H_BOOTSTRAPPING=1 . ~/.zshenv

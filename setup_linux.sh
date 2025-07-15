# In this scripts go all CMD lines that can be executed from scratch without 0 addional config or manual download

# First add source repositories
./setup_source_repositories.sh

# Install 1Password
sudo apt update && sudo apt install 1password


# Install Brave Browser
curl -fsS https://dl.brave.com/install.sh | sh


# Install ZED editor
curl -f https://zed.dev/install.sh | sh
##  Add Zed to ZSH
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
source ~/.bashrc


# Install UV python package manager
curl -LsSf https://astral.sh/uv/install.sh | sh


# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


# Install JAVA
sudo apt install openjdk-17-jdk


# Install ZSH and OMZ
sudo apt-get install git zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


rm ~/.zshrc # Remove generated zshrc by OMZ
# Last create sym links to .dotfiles repositores
./create_sim_links.sh

brew bundle install --file=./Brewfile
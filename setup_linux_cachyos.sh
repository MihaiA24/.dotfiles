# In this scripts go all CMD lines that can be executed from scratch without 0 addional config or manual download

sudo paru # Update all installed

paru -S zed
paru -S 1password
paru -S visual-studio-code-bin # alternative paru -S code # This is the open source version
paru -S jetbrains-toolbox
paru -S paru -S jdk21-openjdk # The openjdk is availiable in cachy os ryzen repo
# Docker
paru -S docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER


# Install Homebrew
# TODO: Don't know if its is necesary having paru
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# sudo apt-get install build-essential # Homebrew recommendation
# /home/linuxbrew/.linuxbrew/bin/brew bundle install --file=./Brewfile

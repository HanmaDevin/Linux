#!/bin/bash

packages=("zip" "unzip" "wget" "curl" "neovim" "discord" "steam" "lazygit" "eza" "texlive" "btop" "ufw" "yazi" "gamemode" "mangohud" "zoxide" "gcc" "fzf" "bat" "gnome-tweaks" "gnome-extensions" "kitty")

for package in "${packages[@]}"; do
  sudo pacman -S "$package"
done

read -p "Want to configure git? (y/n)" gitconfig

if [[ $gitconfig == "y" ]]; then
  read -p "What is your Github username?" username
  git config --global user.name "$username"
  read -p "What is your email?" useremail
  git config --global user.email "$useremail"
fi

read -p "Ready to add ssh-key? (y/n)" sshready

if [[ $sshready == "y" ]]; then
  echo "Do not change de default file location and name in the following!!!"
  read -p "what is your email account?" email
  ssh-keygen -t ed25519 -C $email
  ssh-add ~/.ssh/id_ed25519
  echo "Paste the following content in your ssh-key section in Github"
  echo $(cat ~/.ssh/id_ed25519.pub)
fi


if [[ ! -d "$HOME/.config/neofetch/" ]]; then
  mkdir -p "$HOME/.config/neofetch/"
fi

# adding all configs
# Adding neofetch theme to maschine
echo "Adding neofetch config"
sleep 2

cp "$HOME/Linux/Neofetch-Theme/config.conf" "$HOME/.config/neofetch/config.conf"

echo "Finished!"
sleep 2

echo "Adding btop config"
sleep 2

mkdir -p "$HOME/.config/btop/"
cp "$HOME/Linux/btop/btop.conf" "$HOME/.config/btop/"

echo "Finished!"
sleep 2

# adding neovim plugin
echo "Adding neovim plugin"
sleep 2

mkdir -p "$HOME/.config/nvim/lua/plugins/"
cp "$HOME/Linux/neovim/lazygit.lua" "$HOME/.config/nvim/lua/plugins/"

echo "Finished!"
sleep 2

echo "adding yazi config"
sleep 2

mkdir -p "$HOME/.config/yazi/"
cp "$HOME/Linux/yazi/yazi.toml" "$HOME/.config/yazi/"

echo "Finished!"
sleep 2

echo "adding zshrc"
sleep 2

cp "$HOME/Linux/zsh/zshrc" "$HOME/.zshrc"

echo "Finished!"
sleep 2

echo "Adding wallpaper"
sleep 2

mkdir -p ~/Pictures/wallpaper
cp -a "$HOME/Linux/wallpaper/." "$HOME/Pictures/wallpaper/"

echo "Finished!"
sleep 2

echo "Adding kitty config"
sleep 2

mkdir -p "$HOME/.config/kitty"
cp -a "$HOME/Linux/kitty/." "$HOME/.config/kitty"

echo "Finished!"
sleep 2

echo "Install Ulauncher thats a good app"
sleep 3

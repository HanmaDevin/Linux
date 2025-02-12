#! /bin/bash

install_packages() {
  packages=("zip" "ntfs-3g" "tree" "discord" "lazygit" "ufw" "zsh" "unzip" "wget" "stow" "curl" "yazi" "neovim" "eza" "btop" "gamemode" "steam" "mangohud" "zoxide" "fzf" "bat" "kitty" "geany" "geany-plugins" "tmux" "jdk23-openjdk" "docker" "ripgrep" "cargo" "fd" "starship" "okular" "vlc" "conky" "xclip")

  for package in "${packages[@]}"; do
		sudo pacman -S "$package" --noconfirm || { echo "Failed to install $package"; exit 1; }
  done
}

config_ufw() {
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw enable
}

install_yay(){
  sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
}

install_nitch() {
	echo "Installing nitch..."
	wget https://raw.githubusercontent.com/unxsh/nitch/main/setup.sh && sh setup.sh
	echo "Finished!"
}

configure_git() {
  read -p "Want to configure git? (y/n): " gitconfig
  if [[ $gitconfig == "y" ]]; then
    read -p "What is your GitHub username? " username
    git config --global user.name "$username"
    read -p "What is your email address? " useremail
    git config --global user.email "$useremail"
  fi

  ssh-keygen -t ed25519 -C "$useremail"
}


install_themes() {
  echo "Installing themes..."
  
  unzip "$HOME/Linux/Themes/GTK/Catppuccin-Dark-BL-MG.zip" -d "$PWD/Themes"
  sudo mv "$HOME/Linux/Themes/Catppuccin-*" "/usr/share/themes"

  unzip "$HOME/Linux/Themes/icons/Catppuccin-Mocha.zip" -d "$PWD/Themes"
  sudo mv "$HOME/Linux/Themes/Catppuccin-Mocha" "/usr/share/icons"
  
  sudo cp "$HOME/Linux/Fonts/*" "/usr/share/fonts"
  sudo cp -r "$HOME/Linux/Cursor/Bibata-Modern-Ice" "/usr/share/icons"
  
  echo "Done!"

  echo "Adding ulauncher themes..."

  bash "$HOME/Linux/scripts/themes.sh"

  echo "Done!"

  echo "Installing Vencord..."

  bash "$HOME/Linux/Vencord/VencordInstaller.sh"

  echo "Done!"

}

add_tmux_tpm() {
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  mkdir -p ~/.config/tmux/plugins/catppuccin 
  git clone -b v2.1.2 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
}

install_packages
configure_git

config_ufw
install_nitch
install_themes
add_tmux_tpm

echo "Creating work directory"
mkdir -p "$HOME/Documents/Github/Projects"
echo "Done"
    
install_yay

echo "Installing packages from yay"
yay -S --noconfirm $(cat "$HOME/Linux/yay-packages.txt")
echo "Finished!"

#! /bin/bash

#echo "What package manager do you use?"
#echo "(1) apt"
#echo "(2) dnf"
#echo "(3) zypper"
#echo "(4) pacman"

#read answer

answer="4"

install_packages() {
  local packages=("$@")
  for package in "${packages[@]}"; do
	if [[ "$1" == "pacman" ]]; then
		sudo pacman -S "$package" --noconfirm || { echo "Failed to install $package"; exit 1; }
	else
		sudo "$1" install -y "$package" || { echo "Failed to install $package"; exit 1; }
	fi
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
}


install_themes() {
  echo "Installing themes..."
  
  unzip "$PWD/Themes/GTK/Catppuccin-Dark-BL-MG.zip" -d "$PWD/Themes"
  sudo mv "$PWD/Themes/Catppuccin-*" "/usr/share/themes"

  unzip "$PWD/Themes/icons/Catppuccin-Mocha.zip" -d "$PWD/Themes"
  sudo mv "$PWD/Themes/Catppuccin-Mocha" "/usr/share/icons"
  
  sudo cp "$PWD/Fonts/*" "/usr/share/fonts"
  sudo cp -r "$PWD/Cursor/*" "/usr/share/icons"
  
  echo "Done!"

add_tmux_tpm() {
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  mkdir -p ~/.config/tmux/plugins/catppuccin 
  git clone -b v2.1.2 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
}

case $answer in
  #1)
    #install_packages "apt" "zip" "ufw" "zsh" "unzip" "stow" "wget" "lutris" "curl" "neovim" "eza" "btop" "gamemode" "mangohud" "zoxide" "fzf" "bat" "kitty" "geany" "geany-plugins"
    #configure_git
    #add_ssh_key
    #config_ufw

	##add_configs
	
    #echo "adding zshrc"

    #bash "$PWD/scripts/p10k-theme.sh"
    #rm "$HOME/.zshrc"

    #echo "Finished!"
    #;;
  #2)
    #install_packages "dnf" "zip" "ufw" "zsh" "unzip" "stow" "wget" "curl" "eza" "btop" "gamemode" "mangohud" "zoxide" "fzf" "bat" "geany" "mediawriter"
    #configure_git
    #add_ssh_key
    #config_ufw

	##add_configs

    #echo "adding zshrc"

    #bash "$PWD/scripts/p10k-theme.sh"
    #cp "$PWD/zsh/fedorazsh" "$HOME/.zshrc"

    #echo "Finished!"
	#;;
  #3)
    #install_packages "zypper" "zip" "ufw" "zsh" "unzip" "stow" "wget" "curl" "neovim" "eza" "btop" "gamemode" "mangohud" "zoxide" "fzf" "bat" "kitty" "geany"
    #configure_git
    #add_ssh_key
    #config_ufw
    
    ##add_configs

    #echo "adding zshrc"

    #bash "$PWD/scripts/p10k-theme.sh"
    #cp "$PWD/zsh/debianzsh" "$HOME/.zshrc"

    #echo "Finished!"
	#;;
  4)
    install_packages "pacman" "zip" "discord" "lazygit" "ufw" "zsh" "unzip" "wget" "stow" "curl" "yazi" "neovim" "eza" "btop" "gamemode" "steam" "mangohud" "zoxide" "fzf" "bat" "kitty" "geany" "geany-plugins" "tmux" "jdk23-openjdk" "lazydocker" "docker-compose" "docker" "ripgrep" 
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
    yay -S --noconfirm $(cat "$PWD/yay-packages.txt")
    echo "Finished!"
    ;;
  *)
    echo "Do not know what to do, Bye!!"
    exit 223
    ;;
esac

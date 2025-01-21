#! /bin/bash

echo "What package manager do you use?"
echo "(1) apt"
echo "(2) dnf"
echo "(3) zypper"
echo "(4) pacman"

read answer

install_packages() {
  local packages=("$@")
  for package in "${packages[@]}"; do
    sudo "$1" install -y "$package" || { echo "Failed to install $package"; exit 1; }
  done
}

config_ufw() {
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw enable
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

add_ssh_key() {
  read -p "Ready to add ssh-key? (y/n): " sshready
  if [[ $sshready == "y" ]]; then
    echo "Do not change the default file location and name in the following!!!"
    read -p "What is your email address? " email
    ssh-keygen -t ed25519 -C "$email"
    ssh-add ~/.ssh/id_ed25519
    echo "Paste the following content in your ssh-key section on GitHub:"
    cat ~/.ssh/id_ed25519.pub
  fi
}

add_wallpaper() {
  if [[ ! -d "$HOME/Pictures/wallpaper" ]]; then
    mkdir -p "$HOME/Pictures/wallpaper"
  fi
  cp -a "$PWD/wallpaper/." "$HOME/Pictures/wallpaper/" && echo "Finished adding wallpapers!" || echo "Failed to add wallpapers."
}

add_configs() {
	echo "Adding geany colorschemes"

	if [[ ! -d "$HOME/.config/geany/colorschemes" ]]; then
        mkdir -p "$HOME/.config/geany/colorschemes"
    fi

	cp -a "$PWD/geany/." "$HOME/.config/geany/colorschemes"

	echo "Finished!"

    echo "Adding btop config"

    if [[ ! -d "$HOME/.config/btop" ]]; then
        mkdir -p "$HOME/.config/btop"
    fi

    cp "$PWD/btop/btop.conf" "$HOME/.config/btop"

    echo "Finished!"

    echo "Adding kitty config"

    if [[ ! -d "$HOME/.config/kitty" ]]; then
        mkdir -p "$HOME/.config/kitty"
    fi

    cp -a "$PWD/kitty/." "$HOME/.config/kitty"

    echo "Finished!"

    # adding neovim plugin
    echo "Adding neovim plugin"
    echo "Running neovim script"

    bash "$PWD/scripts/neovim.sh"

    if [[ ! -d "$HOME/.config/nvim/lua/plugins/" ]]; then
      mkdir -p "$HOME/.config/nvim/lua/plugins/"
    fi

    cp "$PWD/neovim/lazygit.lua" "$HOME/.config/nvim/lua/plugins/"

    echo "Finished!"

    add_wallpaper
    
    install_nitch

    echo "Adding font and cursor"

    sudo cp "$PWD/Fonts/MesloLGS NF Regular.ttf" "/usr/share/fonts/"
    sudo cp -r "$PWD/Cursor/Bibata-Modern-Ice/" "/usr/share/icons/"

    echo "Finished!"
}

case $answer in
  1)
    install_packages "apt" "zip" "ufw" "zsh" "unzip" "wget" "curl" "neovim" "eza" "btop" "gamemode" "mangohud" "zoxide" "fzf" "bat" "kitty" "geany" "geany-plugins"
    configure_git
    add_ssh_key
    config_ufw

	add_configs
	
    echo "adding zshrc"

    bash "$PWD/scripts/p10k-theme.sh"
    cp "$PWD/zsh/debianzsh" "$HOME/.zshrc"

    echo "Finished!"
    ;;
  2)
    install_packages "dnf" "zip" "ufw" "zsh" "unzip" "wget" "curl" "eza" "btop" "gamemode" "mangohud" "zoxide" "fzf" "bat" "geany" "mediawriter"
    configure_git
    add_ssh_key
    config_ufw

	add_configs

    echo "adding zshrc"

    bash "$PWD/scripts/p10k-theme.sh"
    cp "$PWD/zsh/fedorazsh" "$HOME/.zshrc"

    echo "Finished!"
	;;
  3)
    install_packages "zypper" "zip" "ufw" "zsh" "unzip" "wget" "curl" "neovim" "eza" "btop" "gamemode" "mangohud" "zoxide" "fzf" "bat" "kitty" "geany"
    configure_git
    add_ssh_key
    config_ufw
    
    add_configs

    echo "adding zshrc"

    bash "$PWD/scripts/p10k-theme.sh"
    cp "$PWD/zsh/debianzsh" "$HOME/.zshrc"

    echo "Finished!"
	;;
  4)
    install_packages "pacman" "zip" "ufw" "zsh" "unzip" "wget" "curl" "neovim" "eza" "btop" "gamemode" "mangohud" "zoxide" "fzf" "bat" "kitty" "geany"
    configure_git
    add_ssh_key
    config_ufw

	add_configs
    
    echo "adding zshrc"

    bash "$PWD/scripts/p10k-theme.sh"
    cp "$PWD/zsh/debianzsh" "$HOME/.zshrc"

    echo "Finished!"
    ;;
  *)
    echo "Do not know what to do, Bye!!"
    exit 223
    ;;
esac

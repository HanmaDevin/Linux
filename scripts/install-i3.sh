#! /bin/sh

# Import OS information
source /etc/os-release

# Logging function
log() {
  echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> ~/setup.log
}

log "Starting setup script"

packages=("git" "steam" "uthash" "pixman" "firefox" "picom" "discord" "iw" "python-pipx" "polybar"
  "maim" "xclip" "xdotool" "pavucontrol" "lazygit" "eza" "texlive" "rofi" "btop" "zsh" "okular" "ttf-font-awesome"
  "neofetch" "feh" "blueman" "libreoffice-still" "ufw" "yazi" "neovim" "unzip" "zip" "fzf" "ntfs-3g" "fuse2" "wget" "curl"
  "gamemode" "mangohud" "zoxide" "bat" "bluez" "bluez-utils" "kitty")

# Check if array is not empty
if [[ ${#packages[@]} -gt 0 ]]; then
  # Check for Linux distro and install packages
  log "Detected OS: $ID"
  case $ID in
    "fedora")
      for package in "${packages[@]}"; do
        sudo dnf install -y "$package" || log "Failed to install $package"
      done
      ;;
    "arch")
      for package in "${packages[@]}"; do
        sudo pacman -S --noconfirm "$package" || log "Failed to install $package"
      done
      ;;
    *)
      for package in "${packages[@]}"; do
        sudo apt install -y "$package" || log "Failed to install $package"
      done
      ;;
  esac
else
  log "No packages to install"
fi

# Function to configure Git
configure_git() {
  read -p "Want to configure git? (y/n) " gitconfig
  if [[ $gitconfig == "y" ]]; then
    read -p "What is your GitHub username? " username
    git config --global user.name "$username"
    read -p "What is your email? " useremail
    git config --global user.email "$useremail"
    log "Configured Git with username: $username"
  fi
}

# Function to add SSH key
add_ssh_key() {
  read -p "Ready to add ssh-key? (y/n) " sshready
  if [[ $sshready == "y" ]]; then
    echo "Do not change the default file location and name!"
    read -p "What is your email account? " email
    ssh-keygen -t ed25519 -C "$email"
    ssh-add ~/.ssh/id_ed25519
    log "SSH key generated for $email"
    echo "Paste the following content in your ssh-key section in GitHub:"
    cat ~/.ssh/id_ed25519.pub
  fi
}

# Function to install Vencord
install_vencord() {
  read -p "Do you want to install Vencord? (y/n) " vencord
  if [[ $vencord == "y" ]]; then
    sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)" || log "Failed to install Vencord"
  fi
}

# Function to create directories and back up existing configs
copy_config() {
  local config_path="$1"
  local source_path="$2"
  
  if [[ -d "$config_path" ]]; then
    mv "$config_path" "${config_path}.bak" && log "Backed up existing config at $config_path"
  fi
  mkdir -p "$(dirname "$config_path")"
  cp -r "$source_path" "$config_path" && log "Copied config from $source_path to $config_path"
}

# Configurations
log "Setting up configurations"

copy_config "$HOME/.config/neofetch/config.conf" "$HOME/Linux/Neofetch-Theme/config.conf"
copy_config "/etc/ly/config.ini" "$HOME/Linux/ly/ly.conf"
copy_config "$HOME/.config/i3/config" "$HOME/Linux/i3-dotfiles/config"
copy_config "$HOME/.config/picom/picom.conf" "$HOME/Linux/dotfiles/picom.conf"
copy_config "$HOME/.config/polybar/config.ini" "$HOME/Linux/i3-dotfiles/config.ini"
copy_config "$HOME/.config/polybar/launch.sh" "$HOME/Linux/i3-dotfiles/launch.sh"
copy_config "$HOME/.icons/Bibata-Modern-Ice" "$HOME/Linux/Cursor/Bibata-Modern-Ice"

# install fonts
sudo unzip -o "$HOME/Linux/Fonts/FiraCode.zip" -d "/usr/share/fonts/" && log "Installed fonts"

copy_config "$HOME/.config/btop/btop.conf" "$HOME/Linux/btop/btop.conf"
copy_config "/boot/grub/themes/dracula" "$HOME/Linux/Grub-Theme/dracula"
sudo cp "$HOME/Linux/Grub-Theme/grub" "/etc/default/grub"
sudo grub-mkconfig -o /boot/grub/grub.cfg && log "Updated GRUB config"
copy_config "$HOME/.Xresources" "$HOME/Linux/i3-dotfiles/Xresources"
copy_config "$HOME/.config/kitty/kitty.conf" "$HOME/Linux/kitty/kitty.conf"
copy_config "$HOME/.config/nvim/lua/plugins/lazygit.lua" "$HOME/Linux/neovim/lazygit.lua"
copy_config "$HOME/.config/yazi/yazi.toml" "$HOME/Linux/yazi/yazi.toml"
mkdir -p ~/wallpaper/ && cp -a "$HOME/Linux/wallpaper/." "$HOME/wallpaper/"

# i3-lock customization
copy_config "$HOME/.config/i3-lock/lock.sh" "$HOME/Linux/i3-dotfiles/lock.sh"
bash "$HOME/i3lock-color/install-i3lock-color.sh" && log "Installed i3lock color"

install_vencord
configure_git
add_ssh_key

# Configure firewall with UFW
log "Configuring firewall with UFW"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo ufw status && log "Firewall configured"

# Run scripts
log "Running additional scripts"
bash "$HOME/Linux/scripts/neovim.sh" || log "Failed to run neovim setup script"
bash "$HOME/Linux/scripts/p10k-theme.sh" || log "Failed to run p10k setup script"

log "Setup completed successfully!"
echo "Setup finished! Check ~/setup.log for details."

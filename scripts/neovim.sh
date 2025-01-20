#! /bin/sh

source /etc/os-release

echo "Welcome to my neovim configuration script"

read -p "Want to install neovim? (y/n)" neovim

if [[ $neovim == "y" ]]; then
  if [[ $ID == "fedora" ]]; then
    sudo dnf install neovim
  elif [[ $ID == "arch" ]]; then
    sudo pacman -S neovim
  else
    sudo apt install neovim
  fi
fi

mkdir -p $HOME/.config/nvim/

echo "Cloning into LazyVim"
sleep 1

git clone https://github.com/NvChad/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

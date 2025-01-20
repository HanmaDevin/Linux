#! /bin/sh

echo "Deleting i3 completely"
sleep 5

# import os information location
source /etc/os-release

packages=("uthash" "pixman" "picom" "iw" "xrandr" "arandr" "UXterm" "Xterm" "rofi-theme-selector" "python-pipx" "polybar" "maim" "xclip" "xdotool" "pavucontrol" "rofi" "okular" "feh" "blueman" "bluez" "bluez-utils")

# variable $ID comes from the os information import
# check if array is not empty
# remove unwanted packages
if [[ ${#packages[@]} ]]; then
  # check for linux distro
  if [[ $ID == "fedora" ]]; then
    # loop through array
    for package in ${packages[@]}; do
      sudo dnf autoremove $package
    done
  elif [[ $ID == "arch" ]]; then
    for package in ${packages[@]}; do
      sudo pacman -Rcs $package
    done
  else
    for package in ${packages[@]}; do
      sudo apt-get autoremove $package
    done
  fi
fi

# remove everything i3 related
sudo rm -rf /etc/ly/

sudo rm -rf "$HOME/.config/i3/"

sudo rm -rf "$HOME/.config/polybar/"

sudo rm -rf "$HOME/.config/picom/"

sudo rm -rf "$HOME/.Xresources"

sudo rm -rf "$HOME/.config/i3-lock/"

echo "Thank you bye!"
sleep 5

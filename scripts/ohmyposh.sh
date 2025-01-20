#! /bin/sh

mkdir -p $HOME/.poshthemes

wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v23.0.2/themes.zip -P $HOME/.poshthemes/

curl -s https://ohmyposh.dev/install.sh | bash -s

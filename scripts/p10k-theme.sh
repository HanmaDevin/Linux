#! /bin/sh

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#!/bin/bash

link_file () {
  local src=$1 dst=$2
  if [ -f "$dst" ]; then
    mv "$dst" "$dst.bkp"
  fi
  ln -s $src $dst
}

# install dependencies
if [ "$(uname -s)" == "Darwin" ]; then
  brew tap homebrew/bundle
  brew bundle
elif [ $(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"') == "Ubuntu" ]; then
  bin/ubuntu.sh
fi

# install vim-plug for neovim
PLUG_FILE=~/.local/share/nvim/site/autoload/plug.vim
if [ ! -f $PLUG_FILE ]; then
  curl -fLo $PLUG_FILE --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# tmux config
if  [ "$(uname -s)" == "Darwin" ]; then
  link_file `pwd`/tmux.conf.osx ~/.tmux.conf
else
  link_file `pwd`/tmux.conf.linux ~/.tmux.conf
fi

link_file `pwd`/tmux.shared.conf ~/.tmux.shared.conf

# neovim config
mkdir -p ~/.config/nvim
link_file `pwd`/config/nvim/init.vim ~/.config/nvim/init.vim
link_file `pwd`/zshrc ~/.zshrc


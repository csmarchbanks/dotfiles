#!/bin/bash
link_file () {
  local src=$1 dst=$2
  if [ -f "$dst" ]; then
    mv "$dst" "$dst.bkp"
  fi
  ln -s $src $dst
}

# tmux config
if  [ "$(uname -s)" == "Darwin" ]; then
  link_file `pwd`/tmux.conf.osx ~/.tmux.conf
else
  link_file `pwd`/tmux.conf.linux ~/.tmux.conf
fi

link_file `pwd`/tmux.shared.conf ~/.tmux.shared.conf

# neovim confi
mkdir -p ~/.config/nvim
link_file `pwd`/config/nvim/init.vim ~/.config/nvim/init.vim

#!/bin/bash
set -e

link_file () {
  local src=$1 dst=$2
  if [ -f "$dst" ] && [ ! -L "$dst" ]; then
    echo "Backing up $dst to $dst.bkp"
    mv "$dst" "$dst.bkp"
  fi
  if [ ! -f "$dst" ]; then
    echo "Linking $dst to $src"
    ln -s $src $dst
  fi
}

# install dependencies
if [ "$(uname -s)" == "Darwin" ]; then
  brew tap homebrew/bundle
  brew bundle
elif [ $(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"') == "Ubuntu" ]; then
  ./ubuntu-deps.sh
fi

# install vim-plug for neovim
PLUG_FILE=$HOME/.local/share/nvim/site/autoload/plug.vim
if [ ! -f $PLUG_FILE ]; then
  echo "Installing vim-plug"
  curl -fLo $PLUG_FILE --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

link_file `pwd`/tmux.conf ~/.tmux.conf

# neovim config
mkdir -p ~/.config/nvim
link_file `pwd`/config/nvim/init.vim ~/.config/nvim/init.vim
link_file `pwd`/config/nvim/init.vim ~/.vimrc
link_file `pwd`/zshrc ~/.zshrc
link_file `pwd`/gitconfig ~/.gitconfig
link_file `pwd`/gitignore ~/.gitignore

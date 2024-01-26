#!/bin/bash
set -e

link_file () {
  local src=$1 dst=$2
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "Backing up $dst to $dst.bkp"
    mv "$dst" "$dst.bkp"
  fi
  if [ ! -e "$dst" ]; then
    echo "Linking $dst to $src"
    ln -s $src $dst
  fi
}

# install dependencies
if [ "$(uname -s)" == "Darwin" ]; then
  brew tap homebrew/bundle
  brew bundle
elif [ ""$(awk -F= '/^ID_LIKE/{print $2}' /etc/os-release | tr -d '"') == "debian" ]; then
  ./ubuntu-deps.sh
else
  echo "Unknown OS, not installing dependencies"
fi

# install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

link_file `pwd`/tmux.conf ~/.tmux.conf

# neovim config
mkdir -p ~/.config/alacritty
link_file `pwd`/config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
mkdir -p ~/.config/wezterm
link_file `pwd`/config/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
link_file `pwd`/config/nvim ~/.config/nvim
link_file `pwd`/zshrc ~/.zshrc
link_file `pwd`/gitconfig ~/.gitconfig
link_file `pwd`/gitignore ~/.gitignore

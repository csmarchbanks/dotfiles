#!/bin/bash

sudo add-apt-repository -y universe
sudo add-apt-repository -y ppa:neovim-ppa/stable
sudo apt update

sudo apt install -y curl vim zsh
sudo apt install -y python-dev python-pip python3-dev python3-pip
sudo apt install -y powerline fonts-powerline 
sudo apt install -y tmux xsel
sudo apt install -y neovim


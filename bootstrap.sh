#!/bin/sh

echo "Downloading and installing the latest version of the dotfiles..."
echo "Downloading .bashrc..."
wget -qO ~/.bashrc raw.githubusercontent.com/chneau/dotfiles/master/.bashrc ||
    curl -fsSLo ~/.bashrc raw.githubusercontent.com/chneau/dotfiles/master/.bashrc

echo "Downloading .zshrc..."
wget -qO ~/.zshrc raw.githubusercontent.com/chneau/dotfiles/master/.zshrc ||
    curl -fsSLo ~/.zshrc raw.githubusercontent.com/chneau/dotfiles/master/.zshrc

echo "Downloading .aliases..."
wget -qO ~/.aliases raw.githubusercontent.com/chneau/dotfiles/master/.aliases ||
    curl -fsSLo ~/.aliases raw.githubusercontent.com/chneau/dotfiles/master/.aliases

echo "Downloading .env..."
wget -qO ~/.env raw.githubusercontent.com/chneau/dotfiles/master/.env ||
    curl -fsSLo ~/.env raw.githubusercontent.com/chneau/dotfiles/master/.env

echo "Execute \`exec \$0\` or sh or bash or zsh..."

#!/bin/sh
URL=https://raw.githubusercontent.com/chneau/dotfiles/master
fetch() {
    echo "Downloading $URL/$1 to $HOME/$1"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSLo "$HOME/$1" "$URL/$1"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "$HOME/$1" "$URL/$1"
    else
        echo "Neither curl nor wget found. Please install one of these."
        exit 1
    fi
}
fetch .bashrc
fetch .zshrc
fetch .aliases
fetch .profile
exec $SHELL

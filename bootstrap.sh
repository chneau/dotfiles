#!/bin/sh
url=https://raw.githubusercontent.com/chneau/dotfiles/master
fetch() {
    echo "Downloading $url/$1"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSLo "$1" "$url/$1"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "$1" "$url/$1"
    else
        echo "Neither curl nor wget found. Please install one of these."
        exit 1
    fi
}
fetch .bashrc
fetch .zshrc
fetch .aliases
fetch .env
exec $SHELL

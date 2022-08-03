#!/bin/sh
URL=https://raw.githubusercontent.com/chneau/dotfiles/master
fetch() {
    echo "Downloading $URL/$1 to $HOME/$1"
    if command -v curl >/dev/null 2>&1; then
        curl -H 'Cache-Control: no-cache, no-store' -fsSLo "$HOME/$1" "$URL/$1?$(date +%s)"
    elif command -v wget >/dev/null 2>&1; then
        wget --no-cookies --no-cache -qO "$HOME/$1" "$URL/$1?$(date +%s)"
    else
        echo "Neither curl nor wget found. Please install one of these."
        exit 1
    fi
}
fetch .bashrc &
fetch .zshrc &
fetch .aliases &
fetch .profile &
wait

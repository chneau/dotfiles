#!/bin/sh

if which apk; then
  apk add --no-cache curl bash sudo
else
  apt-get update -y
  apt-get install -y curl bash sudo
fi

curl -sSL https://raw.githubusercontent.com/CharlesNo/usefulCommands/master/.bashrc > ~/.bashrc && . ~/.bashrc

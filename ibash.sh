#!/bin/sh

getStuff(){
  if which apk; then
    apk add --no-cache curl bash sudo
  else
    apt-get update -yq && apt-get install -yq curl bash sudo
  fi
  curl -sSL https://raw.githubusercontent.com/CharlesNo/usefulCommands/master/.bashrc > ~/.bashrc && sh ~/.bashrc
}

getStuff

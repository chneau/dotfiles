# usefulCommands

A place where I store some scripts.

# Cool docker images:

mrvautin/adminmongo https://hub.docker.com/r/mrvautin/adminmongo/ https://github.com/mrvautin/adminMongo
An interface to connect to a DB and easily create databases / add users - roles

titpetric/netdata https://hub.docker.com/r/titpetric/netdata/ https://github.com/firehol/netdata
Get cool stats on your server with alert system

# To check

https://github.com/Unitech/pm2
https://github.com/srvrco/getssl

# Kubernetes

https://blog.alexellis.io/kubernetes-in-10-minutes/ as a starter
but use kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# Golang

Use this for nice logging output :

import "log"
log.SetFlags(log.Ldate | log.Ltime | log.Lshortfile)

Do not forget that using rand with goroutines is not efficient. Use rand.New with argument rand.Newsource((...date..))

CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' .

Using this looks better :

import log "github.com/sirupsen/logrus";

event better:
logxi

# Ban an IP

sudo iptables -A INPUT -s 58.218.198.xxx -j DROP

It's to bloc some IP that try to messup with ssh !

Commands last and lastlog to show auth stuff.


# Windows: set proxy on via cmd
```
taskkill /im iexplore.exe /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d 127.0.0.1:1080 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f

start /min cmd /c "C:\Program Files\Internet Explorer\iexplore.exe"
timeout 1
taskkill /im iexplore.exe /f
```

now set it off

```
taskkill /im iexplore.exe /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f

start /min cmd /c "C:\Program Files\Internet Explorer\iexplore.exe"
timeout 1
taskkill /im iexplore.exe /f
```

# Good vpn server script

https://github.com/Angristan/OpenVPN-install


# Git clone all

```bash

GHORG=COMPANYTOREPLACE; curl "https://api.github.com/orgs/$GHORG/repos?per_page=1000" | grep -o 'git://[^"]*' | sed "s/git:\/\//https:\/\//g" | xargs -L1 git clone

GUSER=chneau; curl "https://api.github.com/users/$GUSER/repos?per_page=1000" | grep -o 'git://[^"]*' | sed "s/git:\/\//https:\/\//g" | xargs -L1 git clone  

GUSER=chneau; curl "https://api.github.com/users/$GUSER/repos?per_page=1000" | grep -o 'git://[^"]*' | sed "s/git:\/\///g" | sed "s/.git//g" | xargs -L1 go get -t -u -v  
```

# Snap

nice idea but do not use it to install vscode / go. better use .deb file from vscode website and apt for latest go

# iso/img to usb
unetbootin for ubuntu  
rufus for windows  

# bashrc comments

```bash
#
# wget https://raw.githubusercontent.com/chneau/usefulCommands/master/.bashrc -O ~/.bashrc -q; . ~/.bashrc
#
# curl -sSL https://raw.githubusercontent.com/chneau/usefulCommands/master/.bashrc > ~/.bashrc && . ~/.bashrc
# curl -sSL bit.do/chnobash > ~/.bashrc && . ~/.bashrc
#
# !! to repeat command
# cd - to go back
# ctrl + r to search through last commands used
# escape + . put last args to current
# take a look here http://www.commandlinefu.com/commands/browse/sort-by-votes
#
# ctrl + shift + v to paste
# ctrl + d to exit session
# ctrl z to SIGSTOP
# fg to get back stopped jobs
# jobs to list jobs running
# or use %1 %2 ...
#
# sshfs maythux@192.168.xx.xx:/home/maythuxServ/Mounted ~/remoteDir
#
# htpasswd -bc file username password
#
# apt install -y network-manager
# nmtui # = good network manager with console UI
#
#auto lo
#iface lo inet loopback
#auto enp14s0
#iface enp14s0 inet dhcp
#auto wlp13s0
#iface wlp13s0 inet dhcp
#wpa-ssid ssid
#wpa-psk password
#
#nmcli dev show
#
#


#use extra globing features. See man bash, search extglob.
#include .files when globbing.
# fix spelling errors for cd, only in interactive shell

#
# to use a command without alias, use \.
# eg. \ls for a nornal ls
#
```

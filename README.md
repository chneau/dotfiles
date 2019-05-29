# ok

```bash
curl -fsSL https://raw.githubusercontent.com/chneau/usefulCommands/master/.bashrc -o ~/.bashrc && . ~/.bashrc
```

```bash
wget https://raw.githubusercontent.com/chneau/usefulCommands/master/.bashrc -O ~/.bashrc -q; . ~/.bashrc
```

## Cool docker images

[mrvautin/adminmongo](https://hub.docker.com/r/mrvautin/adminmongo/)  
An interface to connect to a DB and easily create databases / add users - roles

[titpetric/netdata](https://hub.docker.com/r/titpetric/netdata/)  
[firehol/netdata](https://github.com/firehol/netdata)  
Get cool stats on your server with alert system

## To check

[Unitech/pm2](https://github.com/Unitech/pm2)  
[srvrco/getssl](https://github.com/srvrco/getssl)  

## Kubernetes

[This](https://blog.alexellis.io/kubernetes-in-10-minutes/) as a starter  
but use `kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"`

## Golang

```go
import "log"

func init()  {
    log.SetFlags(log.Ldate | log.Ltime | log.Lshortfile)
}
```

Do not forget that using rand with goroutines is not efficient.  
Use rand.New with argument rand.Newsource((...date..))

```bash
CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' .
```

## Ban an IP

```bash
sudo iptables -A INPUT -s 58.218.198.xxx -j DROP
```

Commands last and lastlog to show auth stuff.

## Windows: set proxy on via cmd

```cmd
taskkill /im iexplore.exe /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d 127.0.0.1:1080 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f

start /min cmd /c "C:\Program Files\Internet Explorer\iexplore.exe"
timeout 1
taskkill /im iexplore.exe /f
```

now set it off

```cmd
taskkill /im iexplore.exe /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f

start /min cmd /c "C:\Program Files\Internet Explorer\iexplore.exe"
timeout 1
taskkill /im iexplore.exe /f
```

## Good vpn server script

[OpenVPN](https://github.com/Angristan/OpenVPN-install)

## Git clone all

```bash
GHORG=COMPANYTOREPLACE; curl "https://api.github.com/orgs/$GHORG/repos?per_page=1000" | grep -o 'git://[^"]*' | sed "s/git:\/\//https:\/\//g" | xargs -L1 git clone
```

```bash
GUSER=chneau; curl "https://api.github.com/users/$GUSER/repos?per_page=1000" | grep -o 'git://[^"]*' | sed "s/git:\/\//https:\/\//g" | xargs -L1 git clone  
```

```bash
GUSER=chneau; curl "https://api.github.com/users/$GUSER/repos?per_page=1000" | grep -o 'git://[^"]*' | sed "s/git:\/\///g" | sed "s/.git//g" | xargs -L1 go get -t -u -v  
```

With [token](https://github.com/settings/tokens)  

```bash
curl "https://api.github.com/user/repos?per_page=1000&access_token=[[TOKEN]]" | grep -o 'git://[^"]*' | sed "s/git:\/\//https:\/\//g" | xargs -n 1 -P 8 -L1 git clone
# -n 1 -P 8
# taking at most one argument per run command line
# and run up to eight processes at a time
```

## iso/img to usb

unetbootin for ubuntu  
rufus for windows  

## MongoDB

Starting MongoDB 4, `--master` is no longer supported.  
To do the same, do `mongod --replSet rs` then connected with a `mongo` and execute `rs.initiate( { _id: "rs", members: [ { _id: 0, host: "localhost:27017" } ] } )`  

To restore from a gzipped file do `mongorestore --gzip  --drop --archive=20180822083000.archive --nsFrom meteor.* --nsTo arrcraib.*`.  
Don't forget the `=` for the archive, else it won't work.  
You can use `--nsInclude` is the namespace doesn't change.  

Setup auth db:

- First `docker run --rm -it --name aisdb --hostname aisdb -p 25555:27017 -v ~/data/ais:/data/db mongo`  
- Then connect to it with `docker exec -it aisdb mongo` and:  

```js
use admin
db.createUser({user: 'username', pwd: 'password', roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase" ]})
```

- Then restart the first command with `docker run -d --restart always --name aisdb --hostname aisdb -p 25555:27017 -v ~/data/ais:/data/db mongo --auth`  

## bashrc comments

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
# auto lo
# iface lo inet loopback
# auto enp14s0
# iface enp14s0 inet dhcp
# auto wlp13s0
# iface wlp13s0 inet dhcp
# wpa-ssid ssid
# wpa-psk password
#
# nmcli dev show
#
# use extra globing features. See man bash, search extglob.
# include .files when globbing.
# fix spelling errors for cd, only in interactive shell
#
# to use a command without alias, use \.
# eg. \ls for a nornal ls
#
```

## Ubuntu VPN clients

Cisco quick connect: network-manager-openconnect-gnome  
OpenVPN: network-manager-openvpn-gnome  

## mongo fix rs

```mongo
rsconf = rs.conf()
rsconf.members = [{_id: 0, host: "localhost:27017"}]
rs.reconfig(rsconf, {force: true})
```

## Go

Full deps:

```bash
rm -rf vendor
go get -u ./... # pull latest version
govendor init
govendor add +e
govendor update +v
```

Mod deps:

```bash
rm -f go.mod go.sum
go mod init
```

## vscode extensions

GitLens  
Paste JSON as Code (ctrl+shift+p and search the command)  

## cool multi boot usb

[easy2boot](http://www.easy2boot.com/configuring-e2b/)  

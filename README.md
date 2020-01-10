# dotfiles

```bash
# curl
curl -fsSLo ~/.bashrc git.io/fjwA8; . ~/.bashrc

curl -fsSLo ~/.bashrc raw.githubusercontent.com/chneau/dotfiles/master/.bashrc; . ~/.bashrc

# wget
wget -qO ~/.bashrc git.io/fjwA8; . ~/.bashrc

wget -qO ~/.bashrc raw.githubusercontent.com/chneau/dotfiles/master/.bashrc; . ~/.bashrc
```

free -> <https://github.com/ripienaar/free-for-dev>

## SSH passwordless

```bash
ssh-keygen -t rsa -b 2048
ssh-copy-id id@server
ssh-add # only if an agent is already running
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

<https://k3s.io/> looks good as well.

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

## Windows: not responding to ping

```cmd
netsh advfirewall firewall add rule name="ping" protocol=ICMPV4 dir=in action=allow
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

By far the best: <http://www.easy2boot.com/configuring-e2b/>  
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
// or
db.createUser({user: 'username', pwd: 'password', roles: [ "userAdminAnyDatabase", "readWriteAnyDatabase" ]}) // db default to current db

```

- Then restart the first command with `docker run -d --restart always --name aisdb --hostname aisdb -p 25555:27017 -v ~/data/ais:/data/db mongo --auth`  

## bashrc comments

```bash
#
# wget https://raw.githubusercontent.com/chneau/dotfiles/master/.bashrc -O ~/.bashrc -q; . ~/.bashrc
#
# curl -sSL https://raw.githubusercontent.com/chneau/dotfiles/master/.bashrc > ~/.bashrc && . ~/.bashrc
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

## When too many open files

```bash
# Check max of files open per process
ulimit -n
# Set the limit higher
ulimit -n 120000
# This setting is per terminal, not system wide
```

## Don't leak memory with go http client

```golang
resp, err := (&http.Client{
    Timeout: timeout,
    Transport: &http.Transport{
        DisableKeepAlives: true,
        Proxy:             http.ProxyURL(&url.URL{Scheme: "http", Host: proxyHost}),
        Dial: (&net.Dialer{
            Timeout:   timeout,
            KeepAlive: timeout,
        }).Dial,
    },
}).Get(urlGet)
// Dial needs to have a timeout and keepalive, AND DisableKeepAlives set to true
```

## nsupdate

```bash
root@testmachine1 ~]# nsupdate 
> update delete testmachine1.domain1.local
> update add testmachine1.domain1.local 86400 A 10.1.1.1.1
> send
> answer
Outgoing update query:
;; ->>HEADER<<- opcode: UPDATE, status: NOERROR, id:  61616
;; flags: qr ; ZONE: 1, PREREQ: 0, UPDATE: 1, ADDITIONAL: 0
;; ZONE SECTION:
;domain1.local.                 IN      SOA

;; UPDATE SECTION:
testmachine1.domain1.local. 86400 IN A    10.1.1.1

> quit
```

## code review by google

<https://google.github.io/eng-practices/review/reviewer/>

## Machine learning HAVE TO KNOW

<https://towardsdatascience.com/10-machine-learning-methods-that-every-data-scientist-should-know-3cc96e0eeee9>

- Regression
- Classification
- Clustering
- Dimensionality Reduction
- Ensemble Methods
- Neural Nets and Deep Learning
- Transfer Learning
- Reinforcement Learning
- Natural Language Processing
- Word Embeddings

<https://www.nltk.org/>

Stuff to distinguish (<https://projector.tensorflow.org/>):

- Uniform manifold approximation and projection (looks like a one shot thing)
- t-distributed stochastic neighbor embedding (can be iterated) [good explanation](https://nlml.github.io/in-raw-numpy/in-raw-numpy-t-sne/) - [quora answer](https://www.quora.com/How-does-t-SNE-work-in-simple-words)
- principal component analysis [eli5](https://www.reddit.com/r/explainlikeimfive/comments/17xk21/eli5_principle_component_analysis_pcn/c89rmai/)

other:
- umap / t-sne <https://josauder.github.io/dreambank_visualized/>
- very cool visualisation <https://distill.pub/2016/misread-tsne/>
- tensorflow playground about NN <https://playground.tensorflow.org/>

## Samba server on raspbery pi

```bash
dt dperson/samba -h
# for quick testing
docker run --rm -it -p 139:139 -p 445:445 -v `pwd`/samba:/c dperson/samba -p -r -u "c;c" -s "c;/c;no;no;no;c;none;c"
# as a service
docker run -d --restart=always --name samba --hostname samba -p 139:139 -p 445:445 -v `pwd`/samba:/c dperson/samba -p -r -u "c;c" -s "c;/c;no;no;no;c;none;c"
# dperson/samba:armv7hf for orangepi
```

## Mount external disk

```bash
# to check if it is reconised
lsusb
# lit mounted blk
lsblk
# Identify The Devices Unique ID
ls -l /dev/disk/by-uuid/
# or
blkid
# check speed
sudo hdparm -Tt /dev/sdb1
# Create a Mount Point
sudo mkdir /media/usb
sudo chown -R c:c /media/usb
# Manually Mount The Drive
sudo mount /dev/sda1 /media/usb -o uid=c,gid=c
# Un-mounting The Drive
sudo umount /media/usb
# Auto Mount
sudo nano /etc/fstab
# add this: UUID=18A9-9943 /media/usb ntfs async,auto,nofail,noatime,users,rw,uid=c,gid=c 0 2
# or: UUID=3E06129406124CF1 /media/usb ntfs-3g defaults,barrier=0 0 2
# or: UUID=3E06129406124CF1 /media/usb ntfs-3g rw,auto,user,noatime,async,big_writes 0 2
# mount -a to test fstab
```

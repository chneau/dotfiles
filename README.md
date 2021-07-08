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

## Bash variable manipulation

> source https://www.cyberciti.biz/tips/bash-shell-parameter-substitution-2.html

| Command                       | Description                                                      |
| ----------------------------- | ---------------------------------------------------------------- |
| ${parameter:-defaultValue}    | Get default shell variables value                                |
| ${parameter:=defaultValue}    | Set default shell variables value                                |
| ${parameter:?"Error Message"} | Display an error message if parameter is not set                 |
| ${#var}                       | Find the length of the string                                    |
| ${var%pattern}                | Remove from shortest rear (end) pattern                          |
| ${var%%pattern}               | Remove from longest rear (end) pattern                           |
| ${var:num1:num2}              | Substring                                                        |
| ${var#pattern}                | Remove from shortest (front) pattern                             |
| ${var##pattern}               | Remove from longest (front) pattern                              |
| ${var/pattern/string}         | Find and replace (only replace first occurrence)                 |
| ${var//pattern/string}        | Find and replace all occurrences                                 |
| ${!prefix\*}                  | Expands to the names of variables whose names begin with prefix. |
| ${var,}                       | Convert first character to lowercase.                            |
| ${var,pattern}                |                                                                  |
| ${var,,}                      | Convert all characters to lowercase.                             |
| ${var,,pattern}               |                                                                  |
| ${var^}                       | Convert first character to uppercase.                            |
| ${var^pattern}                |                                                                  |
| ${var^^}                      | Convert all character to uppercase..                             |
| ${var^^pattern}               |                                                                  |

## SSH passwordless

```bash
ssh-keygen -t rsa -b 2048
ssh-copy-id id@server
ssh-add # only if an agent is already running
```

## The best awesomes:

- https://github.com/chubin/awesome-console-services
- https://github.com/public-apis/public-apis
- and of course the awesome of awesome https://awesomelists.top/

## Visual Studio

Steps to add Git Bash:

- Click `Tools -> Options -> Environment -> Terminal`
- Click `Add`
  - Name: `Git Bash`
  - Shell location: `C:\Program Files\Git\bin\bash.exe`
  - Arguments: `--login -i`
- Click `Set as Default`
- Press [Ctrl]+[`] while on the code or click `View -> Terminal`

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

- https://kubernetes.io/docs/reference/kubectl/
- https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- https://kubernetes.io/docs/reference/kubectl/docker-cli-to-kubectl/

```bash
# output a Deployment and a Service for you without having to even think about indenting any yaml.
kubectl run nginx -n web --port 80 --image nginx:latest --env FOO=bar --requests 'cpu=100m,memory=256Mi' --limits 'cpu=200m,memory=512Mi' -l app=web --expose --dry-run=client -oyaml

# without namespace
kubectl run nginx --port 80 --image nginx:latest --env FOO=bar --requests 'cpu=100m,memory=256Mi' --limits 'cpu=200m,memory=512Mi' -l app=web --expose --dry-run=client -oyaml

# nice to understand what's up
kubectl get all -owide --show-labels

# restart deployments
kubectl rollout restart deploy

# deployments hitory
kubectl rollout history deploy

# undo once
kubectl rollout undo deploy

# describing
kubectl describe deploy

# not including installation steps
wsl
sudo service docker start
k3d cluster create test
kubectl apply -f example.yml
kubectl port-forward -n even svc/api-even-front 8080:80
# open broswer and test api calls http://localhost:8080/home/

# you can check logs
kubectl logs -n even service/api-even
kubectl logs -n even service/api-even-front

# if using a remote kubernetes
k3d kubeconfig get test
# this remote config to save in a local file
KUBECONFIG=~/.kube/config:/c/temp/oo-k3d kubectl config view --flatten > ~/.kube/new_config
# check file
mv ~/.kube/new_config ~/.kube/config
# be sure the server is reachable from local

# you can list the contexts
kubectl config get-contexts
# and select one
kubectl config set-context k3d-test

# get the logs from all replicas
kubectl logs -n even -l app=api-even -f

# arkad / kubectl krew to install cool kubectl plugins
```

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
CGO_ENABLED=0 go build -trimpath -ldflags '-s -w -extldflags "-static"' -o app

# go mod download -x
go mod graph | awk '{if ($1 !~ "@") print $2}' | xargs go get
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

## Windows: Sound manager

- good to remove all the useless / unused outputs from the sound manager to easily switch between eg. headphones and speakers with only 2 choices left

## Windows: Reset network

```cmd
ipconfig /flushdns
ipconfig /release
netcfg -d
nbtstat –RR
<!-- then restart windows -->
```

from https://superuser.com/a/1326842

```txt
Standard name resolution process in Windows is in the following order:

Check against local computer's name
HOSTS file
DNS, local cache
DNS, DNS servers in the order of precedence
WINS servers
NetBIOS over TCP/IP (NetBT) broadcast
```

## Windows: General networking

```bash
# nslookup hostname or nslookup ip, works good
nslookup

# looks to be windows only?
# route print hostname or route print ip, works good
route print
```

Very useful if computer is not accessible, or can't access other computers by hostname.

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

## git bash / meteor trick

want to run a bat file from git bash? create a file with the same name as the bat file without `.bat`:

```bash
#!/bin/sh
cmd //c "$0.bat" "$@"
```

## MongoDB

Starting MongoDB 4, `--master` is no longer supported.  
To do the same, do `mongod --replSet rs` then connected with a `mongo` and execute `rs.initiate( { _id: "rs", members: [ { _id: 0, host: "localhost:27017" } ] } )`

To restore from a gzipped file do `mongorestore --gzip --drop --archive=20180822083000.archive --nsFrom meteor.* --nsTo arrcraib.*`.  
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
// the all mighty
db.createUser({user: 'username', pwd: 'password', roles: [ "root" ]})
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

https://benhoyt.com/writings/go-intro/

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
go mod init # to init
go mod tidy # remove unused, tidy...
go get -u ./... # update deps
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
docker run -d --restart=always --name samba --hostname samba -e USERID=1000 -e GROUPID=1000 -p 139:139 -p 445:445 -v `pwd`/samba:/c dperson/samba -p -r -u "c;c" -s "c;/c;no;no;no;c;none;c"
# dperson/samba:armv7hf for orangepi
# another example
docker run -d --restart=always --name samba --hostname samba -e USERID=1000 -e GROUPID=1000 -e VETO=yes -p 139:139 -p 445:445 -p 137:137/udp -p 138:138/udp -v `pwd`/samba:/c dperson/samba -p -n -r -u "c;c" -s "c;/c;no;no;no;c;none;c" -W
docker run -d --restart=always --name samba --hostname samba -e USERID=1000 -e GROUPID=1000 -e VETO=yes -p 139:139 -p 445:445 -p 137:137/udp -p 138:138/udp -v `pwd`/samba:/c dperson/samba -p -n -r -u "c;c" -u "Sarah;c" -s "c;/c;no;no;no;c,Sarah;none;c,Sarah" -W
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
# check read speed
sudo hdparm -Tt /dev/sdb1
# check write speed after mount
dd if=/dev/zero of=/media/usb/DATA/test bs=8k count=10k; rm -f /media/usb/DATA/test
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

## Download Manager

```bash
# as a service

mkdir -p ~/docker/aria2-ui/filebrowser/
touch ~/docker/aria2-ui/filebrowser/filebrowser.db
docker run -d --restart=always --name aria2-ui -p 1080:80 -v ~/docker/aria2-ui/filebrowser/filebrowser.db:/app/filebrowser.db -v ~/samba/:/data -e ENABLE_AUTH=true -e ARIA2_USER=user -e ARIA2_PWD=pwd -e ARIA2_SSL=false wahyd4/aria2-ui

# testing
docker run --rm -it --name aria2-ui -p 1080:80 -v ~/docker/aria2-ui/filebrowser/filebrowser.db:/app/filebrowser.db -v ~/samba/:/data -e ENABLE_AUTH=true -e ARIA2_USER=user -e ARIA2_PWD=pwd -e ARIA2_SSL=false wahyd4/aria2-ui

#quickly access the file manager and change default password admin/admin
# access site via ipv4, not the hostname
# NOTICE: if not connected, go on the web page and go to AriaNg Settings and go to the second tab to change the port and reload.
```

## Autossh (access servers behind corporate NAT)

<https://superuser.com/questions/277218/ssh-access-to-office-host-behind-nat-router>

```bash
# from Corporation to Home
autossh -N -R 6000:localhost:22 user@monitoring.com

# at home
ssh remoteuser@localhost -p 6000

# source: https://handyman.dulare.com/ssh-tunneling-with-autossh/

# example with docker
dtest -e SSH_HOSTUSER=USERNAME -e SSH_HOSTNAME=remote.ddns.net -e SSH_HOSTPORT=22 -e SSH_TUNNEL_REMOTE=2222 -e SSH_TUNNEL_LOCAL=22 -e SSH_TUNNEL_HOST=172.17.0.1 -v ~/.ssh/id_rsa:/id_rsa jnovack/autossh
# 172.17.0.1 = docker host
# id_rsa = keys, properly set it up with ssh-copy-id and ssh-keygen

# on remote (here remote.ddns.net)
ssh USERNAME@0 -p2222 # @0 == @::1 == @127.1 == @localhost == @127.0.0.1    --> geek stuff

# ssh through multiple computers example:
ssh server-one -t ssh user@localhost -t ssh server-two

# another example with docker: (for vnc)
docker run -d --restart=always --name=autovnc --hostname=autovnc -e SSH_HOSTUSER=c -e SSH_HOSTNAME=chneau.ddns.net -e SSH_HOSTPORT=21 -e SSH_TUNNEL_REMOTE=12311 -e SSH_TUNNEL_LOCAL=5900 -e SSH_TUNNEL_HOST=172.17.0.1 -v ~/.ssh/id_rsa:/id_rsa jnovack/autossh

# make a port EXPOSED: https://unix.stackexchange.com/a/10429
ssh -g -L 12310:localhost:12311 -N c@0 -p21
# here, we make port 12311 exposed on all interfaces on port 12310
# -g means allow other clients on my network to connect to port 12310
# https://unix.stackexchange.com/a/115906
# -L from local to remote
# -R from remote to local (not in example)
# -N means all I am doing is forwarding ports, don't start a shell.

# why -R 0.0.0.0:[...] wasnt working: https://serverfault.com/a/861911 (because target host need some special configuration)
```

## x11vnc

```bash
# create a password
x11vnc -storepasswd

# run server with pwd without exiting at first logout
x11vnc -usepw -forever

# note: in debian with Gnome on Xorg (to select when loging in !) it works even for the login screen
```

## youtube-dl

```bash
# from file
-a file.txt

# docker
# -v 1 directory where to download
# -v 2 list of dls
docker run --rm -it -v ~/samba/like-moi:/workdir:rw -v ~/samba/like-moi.txt:/lm.txt:ro mikenye/youtube-dl -a /lm.txt

# docker service (no restart since it's a onetime job)
docker run --rm -d -v ~/samba/like-moi:/workdir:rw -v ~/samba/like-moi.txt:/lm.txt:ro mikenye/youtube-dl -a /lm.txt

```

## gradle

```bash
# upgrade gradle to latest
# (to it twice so it update gradle jar)
./gradlew wrapper --gradle-version=6.6.1 --distribution-type=all
./gradlew wrapper --gradle-version=6.6.1 --distribution-type=bin
# gradle-1.12-all.zip file will have binaries, sources, and documentation. gradle-1.12-bin.zip will have only binaries(That should be enough as you don't need any samples/docs)
# src: https://stackoverflow.com/a/25456329
```

## docker update image on swarm

```bash
# here is an example with wordpress
docker pull wordpress:latest && docker service update --image wordpress:latest wordpress_wordpress
```

## golang: easy pprof:

```go
// living the thug life:
defer func() { _ = exec.Command("go", "tool", "pprof", "-web", "pprof.out").Start() }()
f, _ := os.Create("pprof.out")
defer f.Close()
_ = pprof.StartCPUProfile(f)
defer pprof.StopCPUProfile()
// tip, disable gc temporary so the pprof is clearer
debug.SetGCPercent(-1)
defer debug.SetGCPercent(100)
// for cpu:
f, err := os.Create("pprof.out")
checkError(err)
defer f.Close()
err = pprof.StartCPUProfile(f)
checkError(err)
defer pprof.StopCPUProfile()
// then
```

```bash
# run this to get the svg
go tool pprof -web pprof.out
# or to get the UI
go tool pprof -http=:9999 pprof.out
```

## python tips and tricks

- https://www.techbeamers.com/essential-python-tips-tricks-programmers/

```bash
# evil good
pip install pigar
pigar --without-referenced-comments -o ">=" # Generate requirements.txt for current directory.
```

- check the site-packages directory of python to remove bad remaining directories

```bash
# force pip to be pip3
python3 -m pip install --upgrade --force pip
```

## books / resources

### Read

- Grokking Agorithms
- Effective Python
- Clean Code
- Don't Make Me Think
- The Design of everyday things
- https://github.com/dwyl/start-here

### Reading (or read but still need experience)

- The Devops Handbook
- The Phoenix Project
- The Site Reliability Workbook
- I've read so far
- https://github.com/ctjhoa/rust-learning
- https://github.com/sindresorhus/awesome (about anything)

### want to read

- Cloud Native Transformation
- Team Topologies by Matthew Skelton and Manuel Pais
- The Unicorn Project
- Building Secure & Reliable Systems
- Cracking the coding interview (set under the PC to make the fan more silent...)
- You Don't Know JS Yet
- Accelerate - Building and Scaling High Performing Technology Organisations - Nicole Fergrson
- https://github.com/denysdovhan/wtfjs
- https://github.com/yeasy/docker_practice
- https://github.com/tuhdo/os01
- https://github.com/realpython/python-guide
- https://github.com/TheAlgorithms
- https://github.com/daryllxd/lifelong-learning

## setting up windows

- removes useless features
- disable backgroud apps
- use scripts to remove useless services
- use scripts to remove defender
- verify previous steps after updates...
- add wget by running `C:\tools\cygwin\cygwinsetup.exe` after `choco install cygwin`

## disable some windows features

- all here https://github.com/W4RH4WK/Debloat-Windows-10
- and here is how to disable this cpu sucker of windows defender:

- https://github.com/farag2/Windows-10-Setup-Script
- https://github.com/Sycnex/Windows10Debloater

```powershell
Set-MpPreference -DisableRealtimeMonitoring $true
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name DisableAntiSpyware -Value 1 -PropertyType DWORD -Force
# using the disable_windows_defender.bat works better
```

- and here is how to disable onedrive

```powershell
ps onedrive | Stop-Process -Force
start-process "$env:windir\SysWOW64\OneDriveSetup.exe" "/uninstall"
```

- and here is how to disable hibernation (and remove hiberfil.sys)

```cmd
powercfg -h off
```

- and here to remove pagefile (not super good if not a lot of ram)

```powershell
# Disable automatic pagefile management
$cs = gwmi Win32_ComputerSystem
if ($cs.AutomaticManagedPagefile) {
    $cs.AutomaticManagedPagefile = $False
    $cs.Put()
}
# Disable a *single* pagefile if any
$pg = gwmi win32_pagefilesetting
if ($pg) {
    $pg.Delete()
}
```

## windows service tips

```powershell
# set a service to use its own svchost.exe
sc config eventlog type= own
# clear logs
wevtutil el | Foreach-Object {wevtutil cl "$_"}

## ^ this was useful when eventlog was reading 8mb/s for no apparent reasons
```

## nodejs bcrypt on windows

```bash
# if npm i fails at bcrypt on windows ...
npm install --global --production windows-build-tools
```

## dns with adblock integrated

```go
"192.168.1.4",     // pihole
"176.103.130.130", // AdGuard
"208.67.222.222",  // OpenDNS
"23.253.163.53",   // Alternate DNS
```

## pihole docker example that works

```bash
# getting huge help from https://github.com/gwsales/docker-pihole
# replace `--rm -it` by `-d --restart=always`
docker run --rm -it --name=pihole --net=host --cap-add=NET_ADMIN --cap-add=NET_BIND_SERVICE --cap-add=NET_RAW -e=ServerIP=192.168.1.4 -e=TZ=Europe/London -e=INTERFACE=enp14s0 -e=DNS_BOGUS_PRIV=true -e=DNS_FQDN_REQUIRED=true -v ~/docker/pihole/etc/pihole/:/etc/pihole/ -v ~/docker/pihole/etc/dnsmasq.d/:/etc/dnsmasq.d/ --dns=127.0.0.1 --dns=1.1.1.1 pihole/pihole:latest
```

## language/framework insights

- https://insights.stackoverflow.com/survey/
- https://githut.info/

## simple "random" generator

- https://en.wikipedia.org/wiki/Linear_congruential_generator

## the best online tools

- https://explainshell.com/
- https://app.quicktype.io/
- https://kepler.gl/
- https://mobisoftinfotech.com/tools/plot-multiple-points-on-map/

## Rust

For vscode, probably the best working extension ever:

- https://rust-analyzer.github.io/manual.html#installation
- For Windows... install these https://github.com/rust-lang/rustup/issues/1003#issuecomment-289733784

## Any web dev

```html
<!-- the EASY way to autoreload a page being edited -->
<script src="//livejs.com/live.js"></script>
<!-- don't forget to remove for prod -->
```

With a python script like this

```python
#!/usr/bin/env python

import http.server
import io

from bs4 import BeautifulSoup


class MyHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def guess_type(self, path):
        mimetype = http.server.SimpleHTTPRequestHandler.guess_type(self, path)
        if mimetype == "text/plain":  # fix for live.js to work properly
            if path.endswith(".js"):
                mimetype = "application/javascript"
        return mimetype

    def end_headers(self):
        self.send_header("Cache-Control", "no-store, no-cache, must-revalidate, post-check=0, pre-check=0")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        http.server.SimpleHTTPRequestHandler.end_headers(self)

    def send_header(self, keyword, value):
        if keyword.lower() == 'content-length':  # ignore content-length for the little hack to work
            return
        http.server.SimpleHTTPRequestHandler.send_header(self, keyword, value)

    def copyfile(self, source, outputfile):
        if source.name.lower().endswith(".html"):
            res = BeautifulSoup(source, features="html.parser")
            res.head.insert(0, res.new_tag('script', src='//livejs.com/live.js'))
            source.close()
            bb = res.encode()
            new_source = io.BufferedReader(io.BytesIO(bb))
            source = new_source
        http.server.SimpleHTTPRequestHandler.copyfile(self, source, outputfile)

    def log_message(self, format, *args):
        if len(args) > 1 and isinstance(args[0], str) and args[0].startswith("HEAD"):
            return
        http.server.SimpleHTTPRequestHandler.log_message(self, format, *args)


if __name__ == "__main__":
    PORT = 8000
    print(f"http://localhost:{PORT}/")
    print(f"http://localhost:{PORT}/map")
    http.server.test(HandlerClass=MyHTTPRequestHandler, port=PORT)
```

Where basically:

- hide HEAD logging (for confort)
- say to the browser to NOT CACHE anything (else chrome load from cache ~"exponentially")
- auto inject livejs :)

But. Using https://github.com/lepture/python-livereload is simpler: `pip install livereload`

## shell check

- just here to mention this awesome project https://github.com/koalaman/shellcheck
- online version https://www.shellcheck.net/

# vps stuff

- tun missing?

```bash
#!/bin/bash
mkdir /dev/net
mknod /dev/net/tun c 10 200
chmod 0666 /dev/net/tun
# chmod +x /usr/sbin/tunscript.sh


# then
/usr/sbin/tunscript.sh || exit 1
exit 0
# to /etc/rc.local
```

- [ ] TODO: create an Ansible playbook to automatise this + get the client.ovpn

## WSL

- https://docs.microsoft.com/en-us/windows/wsl/install-win10

```ps1
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
# restart
# download https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi
wsl --set-default-version 2
REM install ubuntu from store
REM check version used
wsl -l -v
```

If for some reasons internet doesnt work:

```cmd
REM create this file %userprofile%\.wslconfig with
[wsl2]
swap=0
```

To uninstall Ubuntu:

```cmd
wsl --unregister Ubuntu

REM to install Ubuntu again, type in ubuntu, it will install it back as fresh
```

## TODO

- Investigate `heroku login` cool login process
- Draw project in c# dotnet core
- Use Linq when possible ?

## PS1 bash

- one of the best https://stackoverflow.com/a/34812608

```bash
# here is a copy
function timer_now {
    date +%s%N
}

function timer_start {
    timer_start=${timer_start:-$(timer_now)}
}

function timer_stop {
    local delta_us=$((($(timer_now) - $timer_start) / 1000))
    local us=$((delta_us % 1000))
    local ms=$(((delta_us / 1000) % 1000))
    local s=$(((delta_us / 1000000) % 60))
    local m=$(((delta_us / 60000000) % 60))
    local h=$((delta_us / 3600000000))
    # Goal: always show around 3 digits of accuracy
    if ((h > 0)); then timer_show=${h}h${m}m
    elif ((m > 0)); then timer_show=${m}m${s}s
    elif ((s >= 10)); then timer_show=${s}.$((ms / 100))s
    elif ((s > 0)); then timer_show=${s}.$(printf %03d $ms)s
    elif ((ms >= 100)); then timer_show=${ms}ms
    elif ((ms > 0)); then timer_show=${ms}.$((us / 100))ms
    else timer_show=${us}us
    fi
    unset timer_start
}


set_prompt () {
    Last_Command=$? # Must come first!
    Blue='\[\e[01;34m\]'
    White='\[\e[01;37m\]'
    Red='\[\e[01;31m\]'
    Green='\[\e[01;32m\]'
    Reset='\[\e[00m\]'
    FancyX='\342\234\227'
    Checkmark='\342\234\223'


    # Add a bright white exit status for the last command
    PS1="$White\$? "
    # If it was successful, print a green check mark. Otherwise, print
    # a red X.
    if [[ $Last_Command == 0 ]]; then
        PS1+="$Green$Checkmark "
    else
        PS1+="$Red$FancyX "
    fi

    # Add the ellapsed time and current date
    timer_stop
    PS1+="($timer_show) \t "

    # If root, just print the host in red. Otherwise, print the current user
    # and host in green.
    if [[ $EUID == 0 ]]; then
        PS1+="$Red\\u$Green@\\h "
    else
        PS1+="$Green\\u@\\h "
    fi
    # Print the working directory and prompt marker in blue, and reset
    # the text color to the default.
    PS1+="$Blue\\w \\\$$Reset "
}

trap 'timer_start' DEBUG
PROMPT_COMMAND='set_prompt'
```

## Ubuntu server on old laptop

```bash
sudo nano /etc/systemd/logind.conf
# #HandleLidSwitch=suspend
# to
# HandleLidSwitch=ignore
sudo systemctl restart systemd-logind

sudo nano /etc/ssh/sshd_config
# #Port 22
# to
# Port 23
# NOTE: using port 21 for some reason to investigate create loop disconect for ssh connection
sudo systemctl restart sshd
```

## dotnet

```bash
# generate new https certificate for port 5001 dev purpose
dotnet dev-certs https --trust
```

## Omnisharp fixes for dotnet core vscode ubuntu

```jsonc
// on ~/.omnisharp/omnisharp.json
// dotnet nuget locals all -c
// resinstalling c# extension
{
  "MSBuild": {
    "UseLegacySdkResolver": true
  }
}
```

## python3 and defaults

```bash
sudo apt install python-is-python3
sudo update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1
```

## systemctl

```bash
# find a service:
systemctl | grep -i docker

# status of a service:
systemctl status docker.service

# Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
# first enabled might means it will start on reboot

# to enable a service
systemctl enable docker.service

# more here https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units
```

## no password sudoer

```bash
# type this to edit the right file
sudo visudo

# add NOPASSWD: before ALL like this follow
%sudo   ALL=(ALL:ALL) NOPASSWD: ALL
# example above allow allow people within sudo group to not type password

# for a specific user add this line
user   ALL=(ALL:ALL) NOPASSWD: ALL
```

## Sandboxie

```bash
# use this setting to change the path of the sandbox
FileRootPath=D:\example\
```

## nvidia on linux

```bash
# sources: https://askubuntu.com/a/271625
# nvidiafb is a frame buffer

# check what is nvidiafb
modinfo nvidiafb | grep description

# check if nvidia is installed
dpkg -l | grep -i nvidia

# check if nouveau is running
lsmod | grep nouveau
# can do the same with nvidia

# another useful command to check which driver is in use
lspci -nnk | grep -iA2 vga

# alternative
sudo lshw -class video
```

## bash trap

```bash
# example of trap to kill listed sub process

rabbitmq-server &
PIDS[0]=$!
npm start &
PIDS[1]=$!
sleep 1000 &
PIDS[2]=$!
trap "kill ${PIDS[*]} ; trap - SIGINT" SIGINT
wait
```

## docker macvlan stuff

```bash
# first, you can check if this is available on your system
lsmod | grep macvlan

# use `ip a` or `ifconfig` to find your local network
docker network create -d macvlan --subnet=192.168.1.3/24 --gateway=192.168.1.1 -o parent=enp14s0 macvlan

# check this is set up
docker network ls

# run a docker with a local ip
docker run --rm -it --net=macvlan --ip=192.168.1.111 containous/whoami

# pro tip, be sure the container is using port 80 is testing with a browser
```

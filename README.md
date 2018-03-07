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

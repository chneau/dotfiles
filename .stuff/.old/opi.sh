#!/bin/sh

mkdir -p /containers/portainer

docker rm -f tumblr
docker run -d --restart=always --net=host --name tumblr tumblr

docker rm -f test
docker run -d --restart=always --net=host --name test -v /sys/class/gpio/:/sys/class/gpio/ -v /sys/devices/platform:/sys/devices/platform test

docker rm -f netdata
docker run -d --restart=always --net=host --name netdata --cap-add SYS_PTRACE -v /proc:/host/proc:ro -v /sys:/host/sys:ro -v /var/run/docker.sock:/var/run/docker.sock:ro firehol/netdata:armv7hf

docker rm -f portainer
docker run -d --restart=always --net=host --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v /containers/portainer:/data --restart=always portainer/portainer:linux-arm


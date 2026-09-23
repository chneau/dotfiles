#!/bin/bash

dd if=/dev/zero of=/swap bs=1M count=4000
chmod 600 /swap
mkswap /swap
swapon /swap
echo '/swap none swap sw 0 0' >> /etc/fstab

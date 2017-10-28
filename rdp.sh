#!/bin/bash

apt install -y xrdp xfce4
echo xfce4-session >~/.xsession
service xrdp restart

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

case $- in
    *i*) ;;
      *) return;;
esac

#use extra globing features. See man bash, search extglob.
shopt -s extglob
#include .files when globbing.
shopt -s dotglob
# fix spelling errors for cd, only in interactive shell
shopt -s cdspell

HISTCONTROL=ignoreboth
shopt -s histappend
export HISTFILESIZE=20000
export HISTSIZE=10000
export HISTIGNORE="&:ls:[bf]g:exit"
shopt -s checkwinsize
shopt -s globstar
shopt -s cmdhist
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
# force anyway ...
PS1='\[\033[35m\]\t\[\033[m\]-\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]$'
unset color_prompt force_color_prompt
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
alias ll='ls -alFh'
alias la='ls -A'
alias lo="ls -o"
alias lh="ls -lh"
alias l='ls -CF'
alias hs='history | grep $1'
alias ..='cd ..'
alias ...='cd ../../'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias update='sudo apt-get -y autoremove && sudo apt-get -yf install && sudo apt-get -y update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade'
alias updateall='sudo apt -y autoremove && sudo apt -yf install && sudo apt -y update && sudo apt -y upgrade && sudo apt -y dist-upgrade'


alias d='docker'
alias dprune='docker system prune -f --volumes'
alias dkill='docker kill $(docker ps -q)'
alias dprunea='docker system prune -af --volumes'
alias dtest='docker run --rm -it --name test --hostname test --net "host" '
alias dt='docker run --rm -it --hostname test --net "host" '
alias de='docker exec -it'
alias db='docker build -t'
alias dl='docker logs -f'
alias dsl='docker service logs -f'
alias dsi='docker service inspect --pretty'
alias dsu='docker stack up -c'
alias dsd='docker stack down'
alias doh='docker history'
alias drm='docker rmi $(docker images -q --filter "dangling=true")'

alias ct='column -t'

alias mip='curl ifconfig.me/ip'
alias mh='curl ifconfig.me/host'

alias ports='netstat -tulanp'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias apti='sudo apt install -y'
alias aptr='sudo apt remove --auto-remove -y'
alias sss='service --status-all'

# self update
alias updatebashrc='curl -sSL https://raw.githubusercontent.com/chneau/usefulCommands/master/.bashrc > ~/.bashrc && . ~/.bashrc'

# almost cool aliases
alias ipt='sudo /sbin/iptables'
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist
alias root='sudo -i'
alias su='sudo -i'
alias nginxreload='sudo /usr/local/nginx/sbin/nginx -s reload'
alias nginxtest='sudo /usr/local/nginx/sbin/nginx -t'
alias meminfo='free -m -l -t'
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
alias cpuinfo='lscpu'
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

alias nmr='sudo service network-manager restart'


alias npmig='npm i -g ungit coffeescript npm-check-updates npm'
alias imeteor='curl -sSL install.meteor.com | sh'
alias idocker='curl -sSL get.docker.com | sh'
alias isshuttle='sudo apt -y install sshuttle'
alias ivirtualbox='sudo apt -y install virtualbox'
alias ivagrant='sudo apt -y install vagrant'
alias invm='curl -sSL https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash'
alias iminikube='curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.23.0/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/'
alias ik8s='curl -sSL https://get.k8s.io | bash'
alias k='kubectl'
alias kga='kubectl get all --all-namespaces'
alias ka='sudo kubeadm'

alias gg='git pull -f; git reset --hard origin/master'

ks() {
sudo swapoff -a
sudo kubeadm init
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
}


ik() {
  sudo apt-get update
  sudo apt-get install -y apt-transport-https
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubelet kubeadm kubernetes-cni
}


invim() {
  sudo apt-get -y install software-properties-common
  sudo apt-get -y install python-software-properties
  sudo add-apt-repository -y ppa:neovim-ppa/stable
  sudo apt-get update
  sudo apt-get -y install neovim
}






alias v='vagrant'

alias pstats='powerstat -d 0 -f 1'

alias webshare='python -m SimpleHTTPServer'


alias df="df -Tha --total"
alias du="\du -chs *"
alias free="free -mt"
alias ps="ps auxf"
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias mkdir="mkdir -pv"
alias exe="chmod u+x "

alias npmu="npm-check-updates -au && npm install && npm update"









alias renewip="sudo dhclient -v -r && sudo dhclient -v"



#
# to use a command without alias, use \.
# eg. \ls for a nornal ls
#




function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
 else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

dsave() {
  eval "docker save $1 | 7z -si a $1.tar.7z"
}

alias u='ls -hltr'
alias e='\du * -cs | sort -nr | head'
alias g='grep -C5 --color=auto'


export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'





s() { # do sudo, or sudo the last command if no argument given
    if [[ $# == 0 ]]; then
        sudo $(history -p '!!')
    else
        sudo "$@"
    fi
}





google() {
    search=""
    echo "Googling: $@"
    for term in $@; do
        search="$search%20$term"
    done
    2>/dev/null 1>&2 xdg-open "http://www.google.com/search?q=$search"
}

i() {
  if VERB="$( which apt )" 2> /dev/null; then
    VERB="$VERB -y install "
  elif VERB="$( which apt-get )" 2> /dev/null; then
    VERB="$VERB -y install "
  elif VERB="$( which apk )" 2> /dev/null; then
    VERB="$VERB add --no-cache "
  elif VERB="$( which yum )" 2> /dev/null; then
    VERB="$VERB -y "
  elif VERB="$( which pacman )" 2> /dev/null; then
    VERB="$VERB -S --noconfirm "
  else
    echo "I have no idea what I'm doing." >&2
    exit 1
  fi
  SUSUDO="$( which sudo )" 2> /dev/null
  eval "$SUSUDO $VERB $@" 2> /dev/null
}





export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export GOPATH=~/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# alias logs="find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"






alias findtext='grep -rnw . -e'
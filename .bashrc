export HISTCONTROL=ignoreboth
export HISTFILESIZE=20000
export HISTSIZE=10000
export HISTIGNORE="&:ls:[bf]g:exit"
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
export NVM_DIR=~/.nvm
export GOPATH=~/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:~/.linuxbrew/bin
export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin
export PATH=~/anaconda3/bin:/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:$PATH
export PATH=~/.nimble/bin:$PATH

case $- in
  *i*) ;;
  *) return;;
esac

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
[ -s "/usr/share/bash-completion/bash_completion" ] && \. "/usr/share/bash-completion/bash_completion"
[ -s "/etc/bash_completion" ] && \. "/etc/bash_completion"
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


if hash shopt 2>/dev/null; then
    shopt -s extglob
    shopt -s dotglob
    shopt -s histappend
    shopt -s checkwinsize
    shopt -s globstar
    shopt -s cmdhist
    shopt -s autocd
    shopt -s cdable_vars
    shopt -s cdspell
fi

SELECT="if [ \$? = 0 ]; then echo \"\[\e[32m\]\"; else echo \"\[\e[31m\]\"; fi"
PS1="\[\e[35m\]\t\`${SELECT}\`\u@\h \[\e[33m\]\w\[\e[m\] "























alias refresh='clear; exec $0'
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diskspace="du -S | sort -n -r |more"
alias ll='ls -alFh'
alias lld="ls -alFhtr --group-directories-first"
alias la='ls -A'
alias lo="ls -o"
alias lh="ls -lh"
alias l='ls -CF'
alias hs='history | grep $1'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias updateall='sudo apt -yf install && sudo apt -y update && sudo apt -y upgrade && sudo apt -y dist-upgrade && sudo apt -y autoremove'
alias updatebashrc='curl -fsSL https://raw.githubusercontent.com/chneau/usefulCommands/master/.bashrc -o ~/.bashrc && . ~/.bashrc'
alias update='updatebashrc; updateall'
alias d='docker'
alias dprune='docker system prune -f --volumes'
alias dkill='docker kill $(docker ps -q)'
alias dprunea='docker system prune -af --volumes'
alias dtest='docker run --rm -it --name test --hostname test'
alias dt='docker run --rm -it'
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
alias mip='curl api.ipify.org && echo ""'
alias mh='curl ifconfig.me/host'
alias ports='netstat -tulanp'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias apti='sudo apt install -y'
alias aptr='sudo apt remove --auto-remove -y'
alias sss='service --status-all'
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
alias npmig='npm i -g ungit npm-check-updates npm'
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
alias ks='ks'
ik() {
    sudo apt-get update
    sudo apt-get install -y apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubernetes-cni
}
alias ik='ik'
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
alias npmu="ncu -u && npm install && npm update"
alias renewip="sudo dhclient -v -r && sudo dhclient -v"
extract() {
    if [ -z "$1" ]; then
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
alias extract='extract'
dsave() {
    eval "docker save $1 | 7z -si a $1.tar.7z"
}
alias dsave='dsave'
alias u='ls -hltr'
alias e='\du * -cs | sort -nr | head'
alias g='grep -C5 --color=auto'
s() {
    if [[ $# == 0 ]]; then
        sudo env "PATH=$PATH" $(history -p '!!')
    else
        sudo env "PATH=$PATH" "$@"
    fi
}
alias s='s '
google() {
    search=""
    echo "Googling: $@"
    for term in $@; do
        search="$search%20$term"
    done
    2>/dev/null 1>&2 xdg-open "http://www.google.com/search?q=$search"
}
alias google='google'
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
alias i='i'
alias findtext='grep -rnw . -e'
alias hp='sudo hping3 --flood'
alias banip='sudo iptables -A INPUT -j DROP -s '
alias dn='docker run --rm -itv `pwd`:`pwd` -w `pwd` -u 1000 node:alpine'
alias nload='nload -m -u M'
alias ivpn='wget https://raw.githubusercontent.com/Angristan/OpenVPN-install/master/openvpn-install.sh -O openvpn-install.sh && bash openvpn-install.sh'
alias fixgpg='sudo apt-key adv --recv-key --keyserver keyserver.ubuntu.com'
alias oc='code -a .'
alias m='make'
alias gitclean='git reflog expire --expire=now --all; git repack -ad; git prune'
alias igotop='go get -u github.com/cjbassi/gotop'
alias dm='docker run --net=host --rm -itv `pwd`:`pwd` -w `pwd` -u 1000 mongo'
alias dmm='docker run --net=host --rm -it mrvautin/adminmongo'
alias igit='git config --global credential.helper "cache --timeout=36000000"; git config --global user.email "charles63500@gmail.com";git config --global user.name "chneau"'
alias igitw='git config --global credential.helper "store"; git config --global user.email "charles63500@gmail.com";git config --global user.name "chneau";git config --global core.askpass "";git config --global credential.modalprompt false'
alias sudo='sudo env "PATH=$PATH" '
alias goget='go get -u -v'
gocd() {
    cd "$GOPATH/src/$@"
}
alias gocd='gocd '
fio() {
    curl -F "file=@$@" https://file.io/?expires=1d
    echo ""
}
alias fio='fio '
alias dk='docker run --rm -it --name=kaggle -p=8080:8080 -v=`pwd`:`pwd` -w=`pwd` kaggle/python jupyter notebook --no-browser --notebook-dir=`pwd` --allow-root --port=8080 --ip=\*'
alias dtf='docker run --rm -it --name=kaggle -p=8080:8080 -v=`pwd`:`pwd` -w=`pwd` tensorflow/tensorflow jupyter notebook --no-browser --notebook-dir=`pwd` --allow-root --port=8080 --ip=\*'
serveo() {
    while true; do
        ssh -R 80:localhost:$@ serveo.net
    done
}
alias sop='serveo'
serveossh() {
    while true; do
        ssh -o ServerAliveInterval=60 -R $@:22:localhost:22 serveo.net
    done
}
alias sos='serveossh'
serveosshconnect() {
    ssh -o ProxyCommand="ssh -W $2:22 serveo.net" $1@$2
}
alias soc='serveosshconnect'
gogetc() {
    go get -u -v github.com/chneau/$@
}
alias gogetc='gogetc'
h() {
    echo -e "$(curl -s cht.sh/$@)"
}
alias h='h'
ptree() {
    pstree $(pgrep $@)
}
alias ptree='ptree'

alias ibrew='sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"'
alias icode='curl -sSL https://raw.githubusercontent.com/chneau/util-commands/master/vscode.json > ~/.config/Code/User/settings.json'
alias dnd='docker run --rm -it --name netdata --hostname netdata --cap-add SYS_PTRACE -v /proc:/host/proc:ro -v /sys:/host/sys:ro -p 19999:19999 titpetric/netdata'
alias dndd='docker run -d --restart always --name netdata --hostname netdata --cap-add SYS_PTRACE -v /proc:/host/proc:ro -v /sys:/host/sys:ro -p 19999:19999 titpetric/netdata'

alias irust='curl https://sh.rustup.rs -sSf | sh'

alias iptableclean='iptables-save | uniq | iptables-restore'

alias yt='docker run --rm -u $(id -u):$(id -g) -v $PWD:/data vimagick/youtube-dl'

# aliases just to remenber something that needs to be deeply digged on my brain

alias gigit='git clone --depth=1' # just the tip
alias gotest='go test -cover -count=1' # can add -race
alias gitc='git clone https://github.com/chneau/'
alias theia='docker run -it -p 3000:3000 -v "$(pwd):/home/project:cached" theiaide/theia:next'
alias dcode='docker run -p 127.0.0.1:8443:8443 -v "${PWD}:/root/project" codercom/code-server code-server --allow-http --no-auth'
alias iscc='go get -u github.com/boyter/scc'
alias openports='nmap -p- portquiz.net | grep -i open' # shows outgoing open ports

alias fixionotify='grep -Fxq "fs.inotify.max_user_watches=524288" /etc/sysctl.conf || echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p'

if type -t _completion_loader >/dev/null; then
    _completion_loader make
    complete -F _make m
    _completion_loader docker
    complete -F _docker d
fi

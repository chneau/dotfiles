export HISTCONTROL=ignoreboth
export HISTFILESIZE=20000
export HISTSIZE=10000
export PATH=$PATH:~/go/bin
export PATH=$PATH:~/.cargo/bin
export PATH=$PATH:~/.linuxbrew/bin
export PATH=$PATH:~/.dotnet
export PATH=$PATH:~/.go/bin
export PATH=$PATH:~/.local/bin
export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin
export PATH=$PATH:/snap/bin
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:/usr/sbin
export PATH=$PATH:/sbin

case $- in
*i*) ;;      # this shell is interactive
*) return ;; # this shel is not interative, early return
esac

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

function timer_now() {
    date +%s%N
}

function timer_start() {
    timer_start=${timer_start:-$(timer_now)}
}

function timer_stop() {
    local delta_us=$((($(timer_now) - $timer_start) / 1000))
    local us=$((delta_us % 1000))
    local ms=$(((delta_us / 1000) % 1000))
    local s=$(((delta_us / 1000000) % 60))
    local m=$(((delta_us / 60000000) % 60))
    local h=$((delta_us / 3600000000))
    # Goal: always show around 3 digits of accuracy
    if ((h > 0)); then
        timer_show=${h}h${m}m
    elif ((m > 0)); then
        timer_show=${m}m${s}s
    elif ((s >= 10)); then
        timer_show=${s}.$((ms / 100))s
    elif ((s > 0)); then
        timer_show=${s}.$(printf %03d $ms)s
    elif ((ms >= 100)); then
        timer_show=${ms}ms
    elif ((ms > 0)); then
        timer_show=${ms}.$((us / 100))ms
    else
        timer_show=${us}us
    fi
    unset timer_start
}

set_prompt() {
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

# SELECT="if [ \$? = 0 ]; then echo \"\[\e[32m\]\"; else echo \"\[\e[31m\]\"; fi"
# PS1="\[\e[35m\]\t\`${SELECT}\`\u@\h \[\e[33m\]\w\[\e[m\] "

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias apti='sudo apt install -y'
alias aptr='sudo apt remove --auto-remove -y'
alias banip='sudo iptables -A INPUT -j DROP -s '
alias cpuinfo='lscpu'
alias createpwd='PASSWORD=$(base64 < /dev/urandom | head -c12); echo "$PASSWORD"; echo -n "$PASSWORD" | sha256sum'
alias ct='column -t'
alias curlt='curlt'
alias d='docker'
alias db='docker build -t'
alias dcode='docker run -p 127.0.0.1:8443:8443 -v "${PWD}:/root/project" codercom/code-server code-server --allow-http --no-auth'
alias de='docker exec -it'
alias df='df -Tha --total'
alias diff='diff --color -u'
alias dir='dir --color=auto'
alias diskspace='du -S | sort -n -r | more'
alias dk='docker run --rm -it --name=kaggle -p=8080:8080 -v=`pwd`:`pwd` -w=`pwd` kaggle/python jupyter notebook --no-browser --notebook-dir=`pwd` --allow-root --port=8080 --ip=\*'
alias dkill='docker kill $(docker ps -q)'
alias dl='docker logs --tail 40 -f'
alias dm='docker run --net=host --rm -itv `pwd`:`pwd` -w `pwd` -u 1000 mongo'
alias dmm='docker run --net=host --rm -it mrvautin/adminmongo'
alias dn='docker run --rm -itv `pwd`:`pwd` -w `pwd` -u 1000 node:alpine'
alias dnd='docker run --rm -it --no-healthcheck --security-opt apparmor=unconfined --name netdata --hostname netdata --cap-add SYS_PTRACE -v /etc/passwd:/host/etc/passwd:ro -v /etc/group:/host/etc/group:ro -v /proc:/host/proc:ro -v /sys:/host/sys:ro -v /etc/os-release:/host/etc/os-release:ro -v /var/run/docker.sock:/var/run/docker.sock:ro -p 19999:19999 netdata/netdata'
alias dndd='docker run -d --restart always --no-healthcheck --security-opt apparmor=unconfined --name netdata --hostname netdata --cap-add SYS_PTRACE -v /etc/passwd:/host/etc/passwd:ro -v /etc/group:/host/etc/group:ro -v /proc:/host/proc:ro -v /sys:/host/sys:ro -v /etc/os-release:/host/etc/os-release:ro -v /var/run/docker.sock:/var/run/docker.sock:ro -p 19999:19999 netdata/netdata'
alias doh='docker history'
alias dpihole='docker run -d --name pihole -p 53:53/tcp -p 53:53/udp -p 1080:80 -e TZ="Europe/London" -v "$(pwd)/pihole/etc/pihole/:/etc/pihole/" -v "$(pwd)/pihole/etc/dnsmasq.d/:/etc/dnsmasq.d/" --dns=127.0.0.1 --dns=1.1.1.1 --restart=unless-stopped --hostname pihole -e VIRTUAL_HOST="pihole" -e PROXY_LOCATION="pihole" -e ServerIP="127.0.0.1" pihole/pihole:latest'
alias dprune='docker system prune -f --volumes'
alias dprunea='docker system prune -af --volumes'
alias drm='docker rmi $(docker images -q --filter "dangling=true")'
alias ds='docker stats'
alias dsd='docker stack down'
alias dsi='docker service inspect --pretty'
alias dsl='docker service logs -f'
alias dsu='docker stack up -c'
alias dt='docker run --rm -it'
alias dtest='docker run --rm -it --name test --hostname test'
alias dtf='docker run --rm -it --name=kaggle -p=8080:8080 -v=`pwd`:`pwd` -w=`pwd` tensorflow/tensorflow jupyter notebook --no-browser --notebook-dir=`pwd` --allow-root --port=8080 --ip=\*'
alias du='\du -chs *'
alias dupdate='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --cleanup --debug --run-once'
alias dwatch='docker run -d --restart=always --name=watchtower -v=/var/run/docker.sock:/var/run/docker.sock:ro containrrr/watchtower --cleanup'
alias e='\du * -cs | sort -nr | head'
alias egrep='egrep --color=auto'
alias exe='chmod u+x '
alias extract='extract'
alias fgrep='fgrep --color=auto'
alias findtext='grep -rnw . -e'
alias fio='fio '
alias firewall=iptlist
alias fixgpg='sudo apt-key adv --recv-key --keyserver keyserver.ubuntu.com'
alias fixionotify='grep -Fxq "fs.inotify.max_user_watches=524288" /etc/sysctl.conf || echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p'
alias free='free -mt'
alias g='grep -C5 --color=auto'
alias ga='git add'
alias gb='git branch -v'
alias gc='git commit -v'
alias gca='git commit . -v'
alias gcl='git clone'
alias gcom='git checkout master'
alias gd='git diff'
alias gg='git pull -f; git reset --hard origin/master'
alias gigit='git clone --depth=1'
alias gitc='git clone https://github.com/chneau/'
alias gitclean='git reflog expire --expire=now --all; git repack -ad; git prune; git fetch --prune --prune-tags'
alias gitmessage='curl -s http://whatthecommit.com/index.txt'
alias gl='git pull'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias glom='git pull origin master'
alias goget='go get -u -v'
alias gogetc='gogetc'
alias gols="go list -f '{{join .Deps \"\n\"}}' | xargs go list -f '{{if not .Standard}}{{.ImportPath}}{{end}}'"
alias gotest='go test -cover -count=1'
alias gp='git push'
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'
alias grep='grep --color=auto'
alias grm='git ls-files --deleted | xargs git rm'
alias gs='git status -sb'
alias gundopush='git push -f origin HEAD^:master'
alias h='h'
alias hp='sudo hping3 --flood'
alias hs='history | grep $1'
alias ibrew='sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"'
alias icroc='GO111MODULE=on go get -u -v github.com/schollz/croc/v8'
alias idocker='curl -sSL get.docker.com | sh'
alias idotnet='curl -sSL https://dot.net/v1/dotnet-install.sh | bash'
alias igit='git config --global credential.helper "cache --timeout=36000000"; git config --global user.email "charles63500@gmail.com";git config --global user.name "chneau"; git config --global url.https://github.com/.insteadOf git://github.com/'
alias igitw='git config --global credential.helper "store"; git config --global user.email "charles63500@gmail.com";git config --global user.name "chneau";git config --global core.askpass "";git config --global credential.modalprompt false'
alias igo='curl -LO https://get.golang.org/$(uname)/go_installer && chmod +x go_installer && ./go_installer && rm go_installer'
alias igotop='go get -v -u github.com/cjbassi/gotop'
alias igotty='go get -u -v github.com/yudai/gotty'
alias ihey='vgoget github.com/rakyll/hey'
alias ik3s='curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -s -'
alias ik8s='curl -sSL https://get.k8s.io | bash'
alias ikind='vgoget sigs.k8s.io/kind'
alias ilivereload='pip install livereload'
alias imeteor='curl -sSL install.meteor.com | sh'
alias imicro='curl https://getmic.ro | bash'
alias iminikube='curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.23.0/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/'
alias invm='curl -sSL https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash'
alias ipt='sudo /sbin/iptables'
alias iptableclean='iptables-save | uniq | iptables-restore'
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias irio='curl -sfL https://get.rio.io | sh -'
alias irust='curl https://sh.rustup.rs -sSf | sh'
alias iscc='go get -u github.com/boyter/scc'
alias isshuttle='sudo apt -y install sshuttle'
alias ivagrant='sudo apt -y install vagrant'
alias ivirtualbox='sudo apt -y install virtualbox'
alias ivpn='wget https://raw.githubusercontent.com/Angristan/OpenVPN-install/master/openvpn-install.sh -O openvpn-install.sh && bash openvpn-install.sh'
alias k='kubectl'
alias ka='kubectl apply -f'
alias kd='kubectl delete -f'
alias ke='kubectl exec -ti '
alias kga='kubectl get all -owide --show-labels'
alias kl='kubectl logs -f --tail=40'
alias kpf='kubectl port-forward'
alias krestart='kubectl rollout restart deploy'
alias kw='kubectl get po -w'
alias l='ls -CF'
alias la='ls -A'
alias lh='ls -lh'
alias ll='ls -alFh'
alias lld='ls -alFhtr --group-directories-first'
alias lo='ls -o'
alias ls='ls --color=auto'
alias m='make'
alias meminfo='free -m -l -t'
alias mh='curl ifconfig.me/host'
alias mip='curl api.ipify.org && echo ""'
alias mip2='curl icanhazip.com'
alias mkdir='mkdir -pv'
alias n='n'
alias nginxreload='sudo /usr/local/nginx/sbin/nginx -s reload'
alias nginxtest='sudo /usr/local/nginx/sbin/nginx -t'
alias nload='nload -m -u M'
alias nmr='sudo service network-manager restart'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
alias nowtime=now
alias npmig='npm i -g ungit npm-check-updates npm nodemon'
alias npmu='ncu -u && npm install && npm update'
alias nud='nvm use default'
alias oc='code -a .'
alias openports='nmap -p- portquiz.net | grep -i open'
alias path='echo -e ${PATH//:/\\n}'
alias pipup='pip list --format freeze --outdated | sed 's/=.*//g' | xargs -n1 pip install -U'
alias ports='netstat -tulanp'
alias ps='ps auxf'
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias pstats='powerstat -d 0 -f 1'
alias refresh='clear; exec $0'
alias renewip='sudo dhclient -v -r && sudo dhclient -v'
alias root='\sudo \su'
alias sop='serveo'
alias sss='service --status-all'
alias sudo='sudo env "PATH=$PATH" '
alias theia='docker run -it -p 3000:3000 -v "$(pwd):/home/project:cached" theiaide/theia:next'
alias u='ls -hltr'
alias update='updatebashrc; updateall'
alias updateall='sudo apt -yf install && sudo apt -y update && sudo apt -y upgrade && sudo apt -y dist-upgrade && sudo apt -y autoremove'
alias updatebashrc='curl -fsSL https://raw.githubusercontent.com/chneau/dotfiles/master/.bashrc -o ~/.bashrc && . ~/.bashrc'
alias va='vagrant'
alias vdir='vdir --color=auto'
alias vgoget='GO111MODULE=on go get -u -v'
alias weather='weather'
alias webshare='python -m SimpleHTTPServer'
alias ymp3='youtube-dl --extract-audio --audio-format mp3'
alias yt='docker run --rm -u $(id -u):$(id -g) -v $PWD:/data vimagick/youtube-dl'

weather() { curl wttr.in/"$1"; }

serveo() {
    while true; do
        ssh -R 80:localhost:$@ ssh.localhost.run
    done
}
gogetc() {
    go get -u -v github.com/chneau/$@
}
h() {
    echo -e "$(curl -s cht.sh/$@)"
}
n() {
    cat <<EOF
# curl
curl -fsSLo ~/.bashrc git.io/fjwA8; . ~/.bashrc
curl -fsSLo ~/.bashrc raw.githubusercontent.com/chneau/dotfiles/master/.bashrc; . ~/.bashrc
# wget
wget -qO ~/.bashrc git.io/fjwA8; . ~/.bashrc
wget -qO ~/.bashrc raw.githubusercontent.com/chneau/dotfiles/master/.bashrc; . ~/.bashrc
EOF
}
curlt() {
    curl -so /dev/null -w "\
   namelookup:  %{time_namelookup}s\n\
      connect:  %{time_connect}s\n\
   appconnect:  %{time_appconnect}s\n\
  pretransfer:  %{time_pretransfer}s\n\
     redirect:  %{time_redirect}s\n\
starttransfer:  %{time_starttransfer}s\n\
-------------------------\n\
        total:  %{time_total}s\n" "$@"
}
fio() {
    curl -F "file=@$@" https://file.io/?expires=1d
    echo ""
}
extract() {
    if [ -z "$1" ]; then
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
        echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
        return 1
    else
        for n in $@; do
            if [ -f "$n" ]; then
                case "${n%,}" in
                *.tar.bz2 | *.tar.gz | *.tar.xz | *.tbz2 | *.tgz | *.txz | *.tar)
                    tar xvf "$n"
                    ;;
                *.lzma) unlzma ./"$n" ;;
                *.bz2) bunzip2 ./"$n" ;;
                *.rar) unrar x -ad ./"$n" ;;
                *.gz) gunzip ./"$n" ;;
                *.zip) unzip ./"$n" ;;
                *.z) uncompress ./"$n" ;;
                *.7z | *.arj | *.cab | *.chm | *.deb | *.dmg | *.iso | *.lzh | *.msi | *.rpm | *.udf | *.wim | *.xar)
                    7z x ./"$n"
                    ;;
                *.xz) unxz ./"$n" ;;
                *.exe) cabextract ./"$n" ;;
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
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

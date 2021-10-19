# shellcheck shell=bash
# shellcheck disable=SC2142,SC2154

export HISTCONTROL=ignoreboth
export HISTFILESIZE=20000
export HISTSIZE=10000
export DOCKER_BUILDKIT=1
export NODE_OPTIONS=--max_old_space_size=4096
export KUBECTL_EXTERNAL_DIFF='diff --color -u -N -I generation'
export CARGO_NET_GIT_FETCH_WITH_CLI=true

export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar"
export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew"
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}"
export MANPATH="/home/linuxbrew/.linuxbrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:${INFOPATH:-}"

export PATH=$PATH:~/go/bin
export PATH=$PATH:~/.arkade/bin
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH=$PATH:~/.cargo/bin
export PATH=$PATH:~/.dotnet
export PATH=$PATH:~/.go/bin
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/bin
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

    # cool ps1 for bash
    timer_now() {
        date +%s%N
    }

    timer_start() {
        timer_start=${timer_start:-$(timer_now)}
    }

    timer_stop() {
        local delta_us=$((($(timer_now) - timer_start) / 1000))
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

        # windows git bash work around
        history -a
    }

    trap 'timer_start' DEBUG
    PROMPT_COMMAND='set_prompt'
else
    SELECT="if [ \$? = 0 ]; then echo \"\[\e[32m\]\"; else echo \"\[\e[31m\]\"; fi"
    PS1="\[\e[35m\]\t\`${SELECT}\`\u@\h \[\e[33m\]\w\[\e[m\] "
fi

alias a='ansible'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias apti='sudo apt install -y'
alias aptr='sudo apt remove --auto-remove -y'
alias banip='sudo iptables -A INPUT -j DROP -s '
alias cleanos='rm -rf bleachbit && HOME= git clone --depth=1 https://github.com/bleachbit/bleachbit && python3 bleachbit/bleachbit.py --list | grep -v system.free_disk_space | grep -v system.memory | grep -v deepscan | xargs sudo python3 bleachbit/bleachbit.py --clean && rm -rf bleachbit'
alias completeall='completeall'
alias cpuinfo='lscpu'
alias crictlprune='crictl images -q | xargs -n 1 crictl rmi' # crictl rmi --prune
alias ct='column -t'
alias curlt='curlt'
alias d='docker'
alias db='docker build -t'
alias dcode='docker run -p 127.0.0.1:8443:8443 -v "${PWD}:/root/project" codercom/code-server code-server --allow-http --no-auth'
alias de='docker exec -it'
alias df='df -Tha --total'
alias diff='diff --color -u -w'
alias dir='dir --color=auto'
alias diskspace='du -S | sort -n -r | more'
alias dk='docker run --rm -it --name=kaggle -p=8080:8080 -v=`pwd`:`pwd` -w=`pwd` kaggle/python jupyter notebook --no-browser --notebook-dir=`pwd` --allow-root --port=8080 --ip=\*'
alias dkill='docker kill $(docker ps -q)'
alias dl='docker logs --tail 40 -f'
alias dlog='docker ps -q | xargs -L 1 -P `docker ps | wc -l` docker logs --since 30s -f'
alias dm='docker run --net=host --rm -itv `pwd`:`pwd` -w `pwd` -u 1000 mongo'
alias dmm='docker run --net=host --rm -it mrvautin/adminmongo'
alias dn='docker run --rm -itv `pwd`:`pwd` -w `pwd` -u 1000 node:alpine'
alias dnd='docker run --rm -it --no-healthcheck --security-opt apparmor=unconfined --name netdata --hostname netdata --cap-add SYS_PTRACE -v /etc/passwd:/host/etc/passwd:ro -v /etc/group:/host/etc/group:ro -v /proc:/host/proc:ro -v /sys:/host/sys:ro -v /etc/os-release:/host/etc/os-release:ro -v /var/run/docker.sock:/var/run/docker.sock:ro -p 19999:19999 netdata/netdata'
alias dndd='docker run -d --restart always --no-healthcheck --security-opt apparmor=unconfined --name netdata --hostname netdata --cap-add SYS_PTRACE -v /etc/passwd:/host/etc/passwd:ro -v /etc/group:/host/etc/group:ro -v /proc:/host/proc:ro -v /sys:/host/sys:ro -v /etc/os-release:/host/etc/os-release:ro -v /var/run/docker.sock:/var/run/docker.sock:ro -p 19999:19999 netdata/netdata'
alias dockertags='dockertags'
alias dockerup='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --cleanup --debug --run-once'
alias doh='docker history'
alias dotnethttps='dotnet dev-certs https --clean && dotnet dev-certs https --trust'
alias dotnetup='dotnetup'
alias dpihole='docker run -d --name pihole -p 53:53/tcp -p 53:53/udp -p 1080:80 -e TZ="Europe/London" -v "$(pwd)/pihole/etc/pihole/:/etc/pihole/" -v "$(pwd)/pihole/etc/dnsmasq.d/:/etc/dnsmasq.d/" --dns=127.0.0.1 --dns=1.1.1.1 --restart=unless-stopped --hostname pihole -e VIRTUAL_HOST="pihole" -e PROXY_LOCATION="pihole" -e ServerIP="127.0.0.1" pihole/pihole:latest'
alias dprune='docker system prune -f --volumes'
alias dprunea='docker system prune -af --volumes'
alias drm='docker rmi $(docker images -q --filter "dangling=true")'
alias ds='docker stats'
alias dsave='f(){ docker save "$1" | gzip >"$1.tgz" && echo "$1.tgz created";  unset -f f; }; f'
alias dsd='docker stack down'
alias dsi='docker service inspect --pretty'
alias dsl='docker service logs -f'
alias dsls='docker service ls --tail 40'
alias dsu='docker stack up -c'
alias dt='docker run --rm -it'
alias dtest='docker run --rm -it --name test --hostname test'
alias dtf='docker run --rm -it --name=kaggle -p=8080:8080 -v=`pwd`:`pwd` -w=`pwd` tensorflow/tensorflow jupyter notebook --no-browser --notebook-dir=`pwd` --allow-root --port=8080 --ip=\*'
alias du='\du -chs *'
alias dup='dockerup'
alias dwatch='docker run -d --restart=always --name=watchtower -v=/var/run/docker.sock:/var/run/docker.sock:ro containrrr/watchtower --cleanup'
alias e='\du * -cs | sort -nr | head'
alias egrep='egrep --color=auto'
alias exe='chmod u+x '
alias extract='extract'
alias ff='freecache; free'
alias fgrep='fgrep --color=auto'
alias findtext='grep -rnw . -e'
alias fio='f(){ curl -F "file=@$@" https://file.io/?expires=1d && echo;  unset -f f; }; f'
alias firewall='iptlist'
alias fixgitbashbatfiles='fixgitbashbatfiles'
alias fixgpg='sudo apt-key adv --recv-key --keyserver keyserver.ubuntu.com'
alias fixionotify='fixionotifywatches; fixionotifyinstances'
alias fixionotifyinstances='grep -Fxq "fs.inotify.max_user_instances=524288" /etc/sysctl.conf || echo fs.inotify.max_user_instances=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p'
alias fixionotifywatches='grep -Fxq "fs.inotify.max_user_watches=524288" /etc/sysctl.conf || echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p'
alias fixsleep='sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target'
alias fixsshperm='chown `id -u` ~/; chown `id -u` ~/.ssh; chmod go-w ~/; chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys; chmod 600 ~/.ssh/id_rsa; chmod 600 ~/.ssh/config; chmod 644 ~/.ssh/id_rsa.pub'
alias fixtz='timedatectl set-timezone Europe/London'
alias free='free -mt'
alias freecache='sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"'
alias g='grep -C5 --color=auto'
alias ga='git add'
alias gb='git branch -v'
alias gc='git commit -v'
alias gca='git commit . -v'
alias gcl='git clone'
alias gco='git checkout'
alias gcom='git checkout master'
alias gd='git diff'
alias genpwd='PASSWORD=$(base64 < /dev/urandom | head -c32); echo "$PASSWORD"; echo -n "$PASSWORD" | sha256sum'
alias genuuid="python -c 'import uuid; print(uuid.uuid4())'"
alias gg='git pull -f; git reset --hard origin/master'
alias gigit='git clone --depth=1'
alias gitclean='git reflog expire --expire=now --all; git repack -ad; git prune; git fetch --prune --prune-tags; GIT_ASK_YESNO=false git clean -ffdx'
alias gitget='gitget'
alias gitmessage='curl -s http://whatthecommit.com/index.txt'
alias gitrmtag='git push -d origin'
alias gl='git pull'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias glom='git pull origin master'
alias gobuild="CGO_ENABLED=0 go build -trimpath -ldflags '-s -w -extldflags \"-static\"'"
alias gocd='f(){ cd ~/go/src/${1#*://}; unset -f f; }; f'
alias goget='f(){ go get -u -v ${1#*://}; unset -f f; }; f'
alias gols="go list -f '{{join .Deps \"\n\"}}' | xargs go list -f '{{if not .Standard}}{{.ImportPath}}{{end}}'"
alias gotest='go test -cover -count=1'
alias goup='rm -f go.mod go.sum && go mod init && go get -u && go mod tidy'
alias gp='git push'
alias gpgexport='gpg --armor --export'             # +key
alias gpggit='git config --global user.signingkey' # +key
alias gpglist='gpg --list-secret-keys --keyid-format LONG'
alias gpgnew='gpg --default-new-key-algo rsa4096 --gen-key'
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'
alias grb="git for-each-ref --sort='committerdate:iso8601' --format='%(committerdate:relative)|%(refname:short)|%(committername)' refs/remotes/ | column -s '|' -t"
alias grep='grep --color=auto'
alias grephere='grep -rnw . -e'
alias grm='git ls-files --deleted | xargs git rm'
alias gs='git status -sb'
alias gundopush='git push -f origin HEAD^:master'
alias h='f(){ echo -e "$(curl -s cht.sh/$@)"; unset -f f; }; f'
alias hp='sudo hping3 --flood'
alias hs='history | grep $1'
alias iact='curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash'
alias iarkade='curl -sLS https://dl.get-arkade.dev | sudo sh'
alias iaz='curl -L https://aka.ms/InstallAzureCli | bash'
alias ibpytop='pip install bpytop'
alias ibrew='bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"'
alias icroc='goget github.com/schollz/croc/v9@latest'
alias idatree='goget github.com/datreeio/datree@latest'
alias idocker='curl -sSL get.docker.com | sh'
alias idockercompose='pip install docker-compose'
alias idotnet='curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel 5.0'
alias ifluxctl='sudo snap install fluxctl --classic'
alias igit='git config --global user.email "charles63500@gmail.com"; git config --global user.name "chneau"; git config --global url.ssh://git@github.com/.insteadOf https://github.com/; git config --global core.autocrlf true; git config --global core.safecrlf false; git config --global merge.ff false; git config --global pull.ff true; git config --global core.whitespace blank-at-eol,blank-at-eof,space-before-tab,cr-at-eol'
alias igo='curl -LO https://get.golang.org/$(uname)/go_installer && chmod +x go_installer && ./go_installer && rm go_installer'
alias igoogler='curl -sSLO https://raw.githubusercontent.com/jarun/googler/master/googler && exe googler && echo "move googler in some path"'
alias igotop='goget github.com/xxxserxxx/gotop/v4@latest'
alias igotty='goget github.com/yudai/gotty@latest'
alias igradle='echo "org.gradle.console=plain" > ~/.gradle/gradle.properties'
alias ihey='goget github.com/rakyll/hey@latest'
alias ik3d='curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash'
alias ik3s='curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--no-deploy traefik" sh -s -'
alias ik3slatest='curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--no-deploy traefik" INSTALL_K3S_CHANNEL=latest sh -s -'
alias ik3sup='goget github.com/alexellis/k3sup@latest'
alias ik8s='curl -sSL https://get.k8s.io | bash'
alias ikind='goget sigs.k8s.io/kind@latest'
alias ikubectl='curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && chmod u+x kubectl && sudo mv kubectl /usr/local/bin/'
alias ikubectx='goget github.com/ahmetb/kubectx/cmd/kubectx@latest'
alias ikubens='goget github.com/ahmetb/kubectx/cmd/kubens@latest'
alias ilivereload='pip install livereload'
alias imeteor='curl -sSL install.meteor.com | sh'
alias imicro='curl https://getmic.ro | bash'
alias iminikube='curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.23.0/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/'
alias invm='curl -sSL https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash'
alias ioctant='go get github.com/vmware-tanzu/octant/cmd/octant@latest' # does not work on windows
alias iombash='bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"'
alias iomzsh='sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
alias ipt='sudo /sbin/iptables'
alias iptableclean='iptables-save | uniq | iptables-restore'
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias irio='curl -sfL https://get.rio.io | sh -'
alias irust='curl https://sh.rustup.rs -sSf | sh'
alias iscc='goget github.com/boyter/scc/v3@latest'
alias ispeedtest='curl -s https://install.speedtest.net/app/cli/install.deb.sh | sudo bash'
alias issh='ssh-keygen -t rsa -b 2048'
alias isshuttle='sudo apt -y install sshuttle'
alias ivagrant='sudo apt -y install vagrant'
alias ivirtualbox='sudo apt -y install virtualbox'
alias ivpn='ivpnnyr'
alias ivpnangristan='wget https://raw.githubusercontent.com/Angristan/OpenVPN-install/master/openvpn-install.sh -O openvpn-angristan-install.sh && bash openvpn-angristan-install.sh'
alias ivpnnyr='wget https://raw.githubusercontent.com/Nyr/openvpn-install/master/openvpn-install.sh -O openvpn-nyr-install.sh && bash openvpn-nyr-install.sh'
alias jctl='journalctl -n 200 -f'
alias k='kubectl'
alias k3sconfig='cat /etc/rancher/k3s/k3s.yaml'
alias ka='kubectl apply -f'
alias kak='kubectl apply -k'
alias kar='kubectl api-resources'
alias kclean='kubectl delete $(kubectl get all | grep replicaset.apps | grep "0         0         0" | cut -d" " -f 1)'
alias kconf='kubectl config view --raw'
alias kctx='kubectx'
alias kd='kubectl diff -f'
alias kdecode='kubectl get secret loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo'
alias kdes='kubectl describe'
alias kdestroy='kubectl delete --grace-period=0 --force'
alias kdk='kubectl diff -k'
alias ke='kubectl exec -ti '
alias kg='kubectl get'
alias kga='kubectl get all'
alias killalljobs='kill `jobs -p`'
alias kk='kubectl kustomize'
alias kl='kubectl logs -f --tail=40'
alias kns='kubens'
alias kpf='kubectl port-forward'
alias kr='kubectl rollout'
alias krr='kubectl rollout restart'
alias ktn='kubectl top nodes'
alias ktp='kubectl top pods'
alias kw='kubectl get po -w'
alias l='ls -CF'
alias la='ls -A'
alias lh='ls -lh'
alias ll='ls -alFh'
alias lld='ls -alFhtr --group-directories-first'
alias lo='ls -o'
alias ls='ls --color=auto'
alias m='make'
alias mapscii='telnet mapscii.me'
alias meminfo='free -m -l -t'
alias mh='curl ifconfig.me/host'
alias mip='curl api.ipify.org && echo'
alias mip2='curl icanhazip.com'
alias mkcdir='f(){ mkdir -- "$1" && cd -P -- "$1"; unset -f f; }; f'
alias mkdir='mkdir -pv'
alias n='printf "\ncurl -fsSLo ~/.bashrc raw.githubusercontent.com/chneau/dotfiles/master/.bashrc; . ~/.bashrc\n\nwget -qO ~/.bashrc raw.githubusercontent.com/chneau/dotfiles/master/.bashrc; . ~/.bashrc\n\n"'
alias nginxreload='sudo /usr/local/nginx/sbin/nginx -s reload'
alias nginxtest='sudo /usr/local/nginx/sbin/nginx -t'
alias nload='nload -m -u M'
alias nmr='sudo service network-manager restart'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
alias nowtime=now
alias npmig='npm i -g npm ungit npm-check-updates nodemon prettier typesync depcheck'
alias npmup='ncu --upgrade --target=minor && npm install --silent && ncu'
alias nud='nvm use default'
alias oc='code -a .'
alias openports='nmap -p- portquiz.net | grep -i open'
alias path='echo -e ${PATH//:/\\n}'
alias pipup="pip list --format freeze --outdated | sed 's/=.*//g' | xargs -n1 pip install -U"
alias poefilterup='poefilterup'
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
alias rmdot='for f in *.*; do pre="${f%.*}"; suf="${f##*.}"; mv -i -- "$f" "${pre//./_}.${suf}"; done'
alias root='\sudo \su'
alias s='strace -fqc'
alias screen='screen -q'
alias serveo='f(){ ssh -o "StrictHostKeyChecking no" -R 80:localhost:$1 localhost.run; unset -f f; }; f'
alias servepy='python -m http.server'
alias sshgenkey='mkdir -p .ssh && ssh-keygen -t rsa -f .ssh/id_rsa -q -N ""'
alias sshkillagents='ssh-add -D; ssh-agent -k'
alias sss='service --status-all'
alias sudo='sudo env "PATH=$PATH" '
alias t='terraform'
alias theia='docker run -it -p 3000:3000 -v "$(pwd):/home/project:cached" theiaide/theia:next'
alias toix="curl -F 'f:1=<-' ix.io"
alias toqrcode='curl -F-=\<- qrenco.de'
alias traefikauth='f(){ echo $(htpasswd -nb $1 $2) | sed -e s/\\$/\\$\\$/g; unset -f f; }; f'
alias transfer='transfer'
alias u='ls -hltr'
alias up='updatebashrc; updateall'
alias upb='updatebashrc'
alias update='updatebashrc; updateall'
alias updateall='sudo apt update && sudo apt -y full-upgrade --auto-remove --purge'
alias updatebashrc='curl -fsSL https://raw.githubusercontent.com/chneau/dotfiles/master/.bashrc -o ~/.bashrc && . ~/.bashrc'
alias va='vagrant'
alias vdir='vdir --color=auto'
alias weather='f(){ curl -s wttr.in/"$1"; unset -f f; }; f'
alias webshare='python -m SimpleHTTPServer'
alias yabs='curl -sL yabs.sh | bash -s -- -i'
alias yabsgeekbench='curl -sL yabs.sh | bash -s -- -ifd'
alias yabswithiperf='curl -sL yabs.sh | bash -s -- -r'
alias ymp3='youtube-dl --restrict-filenames --continue --ignore-errors --download-archive downloaded.txt --no-post-overwrites --no-overwrites --extract-audio --audio-format mp3 --output "%(title)s.%(ext)s"' # --min-views --match-filter '!is_live'
alias yt='docker run --rm -u $(id -u):$(id -g) -v $PWD:/data vimagick/youtube-dl'

# shellcheck disable=SC1090
completeall() {
    if command -v kubectl &>/dev/null; then
        source <(kubectl completion bash)
    fi
    eval "$(curl -sSL https://raw.githubusercontent.com/scop/bash-completion/master/bash_completion)"
    eval "$(curl -sSL https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias)"
    # shellcheck disable=SC2046
    complete -F _complete_alias $(alias | while read -r line; do
        line="${line%%=*}"
        echo "${line:6}"
    done)
}

fixgitbashbatfiles() {
    for var in *.bat; do
        # shellcheck disable=SC2016
        printf '#!/bin/sh\ncmd //c "$0.bat" "$@"\n' >"${var%.bat}"
        echo "Created ${var%.bat}"
    done
}

transfer() {
    if [ $# -eq 0 ]; then
        printf "No arguments specified.\nUsage:\n transfer <file|directory>\n ... | transfer <file_name>\n" >&2
        return 1
    fi
    if tty -s; then
        file="$1"
        file_name=$(basename "$file")
        if [ ! -e "$file" ]; then
            echo "$file: No such file or directory" >&2
            return 1
        fi
        if [ -d "$file" ]; then
            file_name="$file_name.zip" ,
            (cd "$file" && zip -r -q - .) | curl --progress-bar --upload-file "-" "http://transfer.sh/$file_name" | tee /dev/null,
        else curl --progress-bar --upload-file "-" "http://transfer.sh/$file_name" <"$file" | tee /dev/null; fi
    else
        file_name=$1
        curl --progress-bar --upload-file "-" "http://transfer.sh/$file_name" | tee /dev/null
    fi
    echo
}

dotnetup() {
    regex='PackageReference Include="([^"]*)" Version="([^"]*)"'
    find . -name "*.*proj" | while read -r proj; do
        # shellcheck disable=SC2094
        while read -r line; do
            if [[ $line =~ $regex ]]; then
                name="${BASH_REMATCH[1]}"
                version="${BASH_REMATCH[2]}"
                if [[ $version != *-* ]]; then
                    dotnet add "$proj" package "$name"
                fi
            fi
        done <"$proj"
    done
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

gitget() {
    git_url=$1
    repo_name=${git_url#*://}
    clone_dir=~/go/src/$repo_name

    if ! [[ "$1" =~ ^.*:// ]]; then
        git_url=https://$git_url
    fi

    if ! git ls-remote "$git_url" >/dev/null 2>&1; then
        echo Repository "$git_url" not found !
        exit 1
    fi

    echo Cloning "$repo_name" into "$clone_dir"
    rm -rf "$clone_dir"
    mkdir -p "$clone_dir" >/dev/null
    git clone --quiet "$git_url" "$clone_dir"
}

extract() {
    if [ -z "$1" ]; then
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
        echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
        return 1
    else
        for n in "$@"; do
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

poefilterup() {
    cd ~/Documents/My\ Games/Path\ of\ Exile/ || return
    (curl -so "NeverSink's filter - 0-SOFT.filter" "https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter/master/NeverSink's%20filter%20-%200-SOFT.filter" &)
    (curl -so "NeverSink's filter - 1-REGULAR.filter" "https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter/master/NeverSink's%20filter%20-%201-REGULAR.filter" &)
    (curl -so "NeverSink's filter - 2-SEMI-STRICT.filter" "https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter/master/NeverSink's%20filter%20-%202-SEMI-STRICT.filter" &)
    (curl -so "NeverSink's filter - 3-STRICT.filter" "https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter/master/NeverSink's%20filter%20-%203-STRICT.filter" &)
    (curl -so "NeverSink's filter - 4-VERY-STRICT.filter" "https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter/master/NeverSink's%20filter%20-%204-VERY-STRICT.filter" &)
    (curl -so "NeverSink's filter - 5-UBER-STRICT.filter" "https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter/master/NeverSink's%20filter%20-%205-UBER-STRICT.filter" &)
    (curl -so "NeverSink's filter - 6-UBER-PLUS-STRICT.filter" "https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter/master/NeverSink's%20filter%20-%206-UBER-PLUS-STRICT.filter" &)
    cd - >/dev/null || return
    wait
    echo "Downloaded filters from master branch"
}

dockertags() {
    if [ $# -lt 1 ]; then
        cat <<HELP
dockertags  --  list all tags for a Docker image on a remote registry.

EXAMPLE:
    - list all tags for ubuntu:
       dockertags ubuntu

    - list all php tags containing apache:
       dockertags php apache

HELP
    fi

    image="$1"
    tags=$(curl -s https://registry.hub.docker.com/v1/repositories/"${image}"/tags | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n' | awk -F: '{print $3}')

    if [ -n "$2" ]; then
        tags=$(echo "${tags}" | grep "$2")
    fi

    echo "${tags}"
}

# shellcheck disable=SC1091
if hash shopt 2>/dev/null; then
    if ! shopt -oq posix; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
            . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
            . /etc/bash_completion
        fi
    fi
fi

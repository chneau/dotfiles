. ~/.env

case $- in
*i*) ;;      # this shell is interactive
*) return ;; # this shel is not interative, early return
esac

setopt extendedglob
setopt dotglob
# shopt -s histappend
# shopt -s checkwinsize
setopt globstarshort
# shopt -s cmdhist
setopt autocd
setopt cdablevars
# shopt -s cdspell
setopt PROMPT_SUBST
autoload -U colors && colors

TMOUT=1

TRAPALRM() {
    zle reset-prompt
}

preexec() {
    timer=$(($(date +%s%0N) / 1000))
}

precmd() {
    Last_Command=$? # Must come first!
    if [ $timer ]; then
        now=$(($(date +%s%0N) / 1000))
        elapsed=$(($now - $timer))
        us=$((elapsed % 1000))
        ms=$(((elapsed / 1000) % 1000))
        s=$(((elapsed / 1000000) % 60))
        m=$(((elapsed / 60000000) % 60))
        h=$((elapsed / 3600000000))
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

        if [[ $Last_Command == 0 ]]; then
            RPROMPT="%B%F{green}✓ %F{cyan}${timer_show} %f%b"
        else
            RPROMPT="%B%F{red}✗ %F{cyan}${timer_show} %f%b"
        fi
        unset timer
    fi
}

PROMPT="%B%F{green}[%D{%H:%M:%S}] %n@%m %F{blue}%~ $ %f%b"

parse_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

. $HOME/.aliases

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename ~/.zshrc

autoload -Uz compinit
compinit
# End of lines added by compinstall

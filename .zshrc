. ~/.env

case $- in
*i*) ;;      # this shell is interactive
*) return ;; # this shel is not interative, early return
esac

setopt extendedglob
setopt dotglob
setopt globstarshort
setopt cdablevars
setopt AUTO_CD
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt PROMPT_SUBST
unsetopt MENU_COMPLETE
setopt AUTO_MENU

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

function git_prompt_info {
    local ref=$(=git symbolic-ref HEAD 2>/dev/null)
    local gitst="$(=git status 2>/dev/null)"

    if [[ -f .git/MERGE_HEAD ]]; then
        if [[ ${gitst} =~ "unmerged" ]]; then
            gitstatus=" %{$fg[red]%}unmerged%{$reset_color%}"
        else
            gitstatus=" %{$fg[green]%}merged%{$reset_color%}"
        fi
    elif [[ ${gitst} =~ "Changes to be committed" ]]; then
        gitstatus=" %{$fg[blue]%}!%{$reset_color%}"
    elif [[ ${gitst} =~ "use \"git add" ]]; then
        gitstatus=" %{$fg[red]%}!%{$reset_color%}"
    elif [[ -n $(git checkout HEAD 2>/dev/null | grep ahead) ]]; then
        gitstatus=" %{$fg[yellow]%}*%{$reset_color%}"
    else
        gitstatus=''
    fi

    if [[ -n $ref ]]; then
        echo "%{$fg_bold[green]%}/${ref#refs/heads/}%{$reset_color%}$gitstatus"
    fi
}

PROMPT="%B%F{green}[%D{%H:%M:%S}] %n@%m %F{blue}%~ $(git_prompt_info) $ %f%b"

. $HOME/.aliases

bindkey "^K" kill-whole-line                     # ctrl-k
bindkey "^R" history-incremental-search-backward # ctrl-r
bindkey "^A" beginning-of-line                   # ctrl-a
bindkey "^E" end-of-line                         # ctrl-e
bindkey "[B" history-search-forward              # down arrow
bindkey "[A" history-search-backward             # up arrow
bindkey "^D" delete-char                         # ctrl-d
bindkey "^F" forward-char                        # ctrl-f
bindkey "^B" backward-char                       # ctrl-b
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename ~/.zshrc

autoload -Uz compinit && compinit
# End of lines added by compinstall

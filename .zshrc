. ~/.profile

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
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt PROMPT_SUBST
setopt AUTO_MENU
setopt SH_WORD_SPLIT
unsetopt MENU_COMPLETE


autoload -U colors && colors
TMOUT=1
TRAPALRM() {
    [ "$WIDGET" != "expand-or-complete" ] \
    && [ "$WIDGET" != "fzf-history-widget" ] \
    && [ "$WIDGET" != "fzf-file-widget" ] \
    && [ "$WIDGET" != "fzf-tab-complete" ] \
    && [ "$WIDGET" != "fzf-completion" ] \
    && zle reset-prompt
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
            RPROMPT="%B%F{green}${timer_show}%f%b"
        else
            RPROMPT="%B%F{red}$(nice_exit_code ${Last_Command}) ${timer_show}%f%b"
        fi
        unset timer
    else
        RPROMPT=
    fi
}

PROMPT="%B%F{green}%D{%H:%M:%S} %n@%m %F{blue}%~ $ %f%b"

. $HOME/.aliases

bindkey -e
bindkey "^R" history-incremental-search-backward  # ctrl-r
bindkey "^[[A" history-beginning-search-backward  # up arrow
bindkey "^[[B" history-beginning-search-forward   # down arrow
bindkey "^[[5~" history-beginning-search-backward # page down
bindkey "^[[6~" history-beginning-search-forward  # page up
bindkey "^[[1;5C" forward-word                    # ctrl-right
bindkey "^[[1;5D" backward-word                   # ctrl-left
bindkey "^[[H" beginning-of-line                  # home
bindkey "^[[F" end-of-line                        # end
bindkey "^[[3~" delete-char                       # delete

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone --depth=1 https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

zinit wait light-mode for \
    from"gh-r" as"command" mv"bat*/bat -> bat" pick"bat" @sharkdp/bat \
    from"gh-r" as"command" mv"bin/exa -> exa" pick"exa" @ogham/exa \
    from"gh-r" as"command" mv"fd*/fd -> fd" pick"fd" @sharkdp/fd \
    from"gh-r" as"command" pick"fzf" @junegunn/fzf \
    depth"1" @Aloxaf/fzf-tab \
    depth"1" @bric3/nice-exit-code \
    depth"1" @hlissner/zsh-autopair \
    depth"1" @MichaelAquilina/zsh-you-should-use \
    depth"1" @micrenda/zsh-nohup \
    depth"1" @paulirish/git-open \
    depth"1" @unixorn/fzf-zsh-plugin \
    depth"1" @zdharma-continuum/fast-syntax-highlighting \
    depth"1" atload'bindkey "^[^M" autosuggest-execute;' @zsh-users/zsh-autosuggestions \
    depth"1" @zsh-users/zsh-completions \
    @https://github.com/chneau/dotfiles/blob/master/zsh/lib/functions.zsh \
    @OMZP::colored-man-pages \
    @OMZP::docker/_docker \
    @OMZP::fancy-ctrl-z \
    @OMZP::sudo \
    @OMZP::web-search

alias ls='exa'
alias cat='bat'
alias l='exa -F'
alias la='exa -a'
alias lld='exa -alFhr --sort newest --group-directories-first'
alias lo='exa -l'

autoload -Uz compinit && compinit -i
unset zle_bracketed_paste

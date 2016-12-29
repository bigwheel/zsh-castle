# mycom.1
autoload -U compinit
compinit -u
export LANG=ja_JP.UTF-8
export EDITOR=vim
export ALTERNATE_EDITOR=vi
export PAGER=less


# mycom.2

# Prompt Settings
setopt prompt_subst

# mycom.3
HISTSIZE=10000000
SAVEHIST=10000000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data
setopt extended_history
setopt append_history
setopt inc_append_history
setopt hist_reduce_blanks
setopt hist_ignore_space

setopt print_eight_bit

# mycom.4
bindkey -e
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# mycom.5
setopt auto_cd
setopt auto_pushd
setopt correct
setopt list_packed
setopt nolistbeep

# mycom.6
#autoload predict-on
#predict-on

#setopt complete_aliases
if [ "$(uname)" = 'Darwin' ]; then
    alias ls='ls -v -G -h'
else
    alias ls='ls -v --group-directories-first --color=auto --classify -h'
fi
alias lg="ls -g"
alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"
alias lla="ls -al"
alias lal="ls -al"

alias df="df -h"

alias cp="cp -i"
alias mv="mv -i"
alias du="du -h"

# mycom.9
zstyle ':completion:*' list-colors ''

# screen section
#if [ $TERM != "screen" ]; then
#    exec screen -S main -xRR -q
#fi

#alias screen='screen -U -D -RR'

# for trash-cli command
# following section replaces rm to trash

# 0.10 >= version
if which trash &>/dev/null; then
    alias rm=trash
fi
# 0.10 < version
if which trash-put &>/dev/null; then
    alias rm=trash-put
fi

# for sudo alias. refer to http://d.hatena.ne.jp/yuta84q/20090301/1235896452
alias sudo='sudo '

# ssh replace. If ssh is typed, zsh create new screen and execute ssh in its.
# addition, zsh rename screen name to ssh host name.
function ssh_screen(){
 eval server=\${$#}
 screen -t $server ssh "$@"
}
#if [ x$TERM = xscreen ]; then
#  alias ssh=ssh_screen
#fi

# below section was disabled, because Error occured.

#alias ec="emacsclient"
function ec() {
    emacsclient -n $1
}

alias grep="grep --color=always"
alias tree="tree -CAN"

#alias gco="git checkout"
#alias gci="git commit -v"
#alias gst="git status"
#alias gss="git status -s "
#alias gbr="git branch"
#alias gad="git add"
#alias glg="git log --graph --color"

alias gba="git branch --color -a | grep --color=never -v ' trash/'"
alias gd="git diff"
alias gdc="git diff --cached"
alias gcac="git commit -v -a -c HEAD"
#alias gdm="git diff master"
#alias gd1="git diff HEAD~1"
#alias gd2="git diff HEAD~2"
#alias gd3="git diff HEAD~3"
#alias gd5="git diff HEAD~5"
#alias gd10="git diff HEAD~10"
alias glg1="git log --pretty=format:\"%C(yellow)%h%Creset|%C(blue)%an%Creset|%C(green)%cr%Creset|%s\" | awk -F '|' '{ printf \"%s %-30s %-25s %s\n\", \$1, \$2, \$3, \$4 }' | less"

alias less="less -R"

#alias history="history -E"

if which ack-grep &> /dev/null; then
    alias ack="ack-grep --smart-case"
else
    alias ack="ack --smart-case"
fi

if which pcregrep &> /dev/null; then
	alias pcregrep="pcregrep -Hn --color"
fi

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# zsh設定ファイルの置かれてるディレクトリ関連
#if [ -d ~/dotfiles -o -L ~/dotfiles ]; then
#  source ~/dotfiles/cdd
#  chpwd() {
#    _cdd_chpwd
#  }
#  zstyle ':completion:*' group-name ''
#  zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'
#fi

# tmuxのため
export TERM="xterm-256color"

#if [ -z $TMUX ] ; then
#  if tmux ls &> /dev/null ; then
#    tmux attach -t 0
#  else
#    tmux
#  fi
#fi

REPORTTIME=10

PATH=$PATH:$HOME/bin

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

zstyle ':completion:*:git:*' user-commands ${${(k)commands[(I)git-*]}#git-}

# もう面倒なのでdotfilesある前提でHISTFILEの位置を記述する
# 上手く動かなかったので無効化する
if [ -d ~/dotfiles -o -L ~/dotfiles ]; then
    HISTFILE=$HOME/dotfiles/.zsh_history
fi

#if which xmodmap &> /dev/null; then
#    xmodmap $HOME/.Xmodmap
#fi

if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

# http://qiita.com/takyam/items/d6afacc7934de9b0e85e
export PATH=$PATH:/usr/local/share/git-core/contrib/diff-highlight
export PATH=$PATH:/usr/share/doc/git/contrib/diff-highlight

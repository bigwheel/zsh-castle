# http://yonchu.hatenablog.com/entry/20120415/1334506855
## 重複パスを登録しない
typeset -U path cdpath fpath manpath

# zplugが存在しなければインストール
if ! [ -e ~/.zplug/ ]; then
  curl -sL zplug.sh/installer | zsh
fi

source ~/.zplug/init.zsh

zplug "plugins/git", from:oh-my-zsh
zplug "themes/terminalparty", from:oh-my-zsh, as:theme
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# ここに書かれている通りzsh-syntax-highlightingとの相性問題でSegfaultがでる。
# そのため修正が入っているdevelopブランチへ一時的に切り替え
# https://github.com/zsh-users/zsh-autosuggestions/pull/150
# ここの一番最後に書かれているv0.4.0がリリースされればmasterに戻していいはず
zplug "zsh-users/zsh-autosuggestions", at:develop

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# Customize to your needs...

# zsh-autosuggestionsで補完される文字の色が暗すぎて見づらいので明度を調整
# https://github.com/zsh-users/zsh-autosuggestions#suggestion-highlight-style
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'

# https://superuser.com/a/613817
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&'

# autoload -U compinit より前にfpathを設定する必要があるためここに記述
if [ -e ~/.homesick/repos/homeshick ]; then
    source "$HOME/.homesick/repos/homeshick/homeshick.sh"
    fpath=($HOME/.homesick/repos/homeshick/completions $fpath)
fi

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

# http://askubuntu.com/a/22043
alias sudo='sudo '

alias grep="grep --color=always"
alias tree="tree -CN"

#alias gco="git checkout"
#alias gci="git commit -v"
#alias gst="git status"
#alias gss="git status -s "
#alias gbr="git branch"
#alias gad="git add"
#alias glg="git log --graph --color"

alias gba="git branch --color -a | grep --color=never -v ' trash/'"
alias gd="git diff"
alias gdst="git diff --stat"
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

REPORTTIME=10

PATH=$PATH:$HOME/bin

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

zstyle ':completion:*:git:*' user-commands ${${(k)commands[(I)git-*]}#git-}

# .zsh_historyはリンクではうまく動かないのでHISTFILEで指定する
if [ -e $HOME/Dropbox/linux/dotfiles/.zsh_history ]; then
    HISTFILE=$HOME/Dropbox/linux/dotfiles/.zsh_history
fi

# gnome-terminalのsolarized絡みで入れたdir_colorsの読み込み設定
if [ -e ~/.dir_colors ]; then
    eval `dircolors $HOME/.dir_colors/dircolors`
fi

# http://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-command-completion.html
# 本家マニュアルに従い以下の記述へ変更するが、
# http://qiita.com/takeo-asai/items/c0ab835b9ba244d0d17a
# 上のqiitaに書かれている通り落ちるという報告もあるのでやばかったら削除
# 後々再検討する場合はaws_zsh_completer.sh自体のヘッダの記述も参考にする
if which aws_zsh_completer.sh &> /dev/null; then
    source aws_zsh_completer.sh
fi

if [ -e ~/go ]; then
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
fi

if [ -e $HOME/.rbenv/bin ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
fi

#if which xmodmap &> /dev/null; then
#    xmodmap $HOME/.Xmodmap
#fi

if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

# http://qiita.com/takyam/items/d6afacc7934de9b0e85e
export PATH=$PATH:/usr/local/share/git-core/contrib/diff-highlight # mac
export PATH=$PATH:/usr/share/doc/git/contrib/diff-highlight # ubuntu

# http://yonchu.hatenablog.com/entry/20120415/1334506855
## 重複パスを登録しない
typeset -U path cdpath fpath manpath

# zplugが存在しなければインストール
if ! [ -e ~/.zplug/ ]; then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
fi

source ~/.zplug/init.zsh

zplug "plugins/git", from:oh-my-zsh
#if [ "$(uname)" = 'Darwin' ]; then
##  # 絵文字問題でmacでは描画がずれる
#  zplug "~/.zplug/repos/robbyrussell/oh-my-zsh/custom/themes", from:local, use:"t.zsh-theme"
#else
  zplug "themes/terminalparty", from:oh-my-zsh, as:theme
#fi
if [ "$(uname)" != 'Darwin' ]; then
  zplug "zsh-users/zsh-syntax-highlighting", defer:2
  zplug "zsh-users/zsh-autosuggestions"
fi

zplug "junegunn/fzf-bin", as:command, rename-to:"fzf", from:gh-r
zplug "b4b4r07/enhancd", use:init.sh, on:"junegunn/fzf-bin"
zplug "mollifier/cd-gitroot"

# https://blog.shibayu36.org/entry/2017/04/01/213621
zplug "Tarrasch/zsh-autoenv"

# https://medium.com/@n4sekai5y/kubectl-completion-zsh%E3%82%92%E8%BB%8A%E8%BC%AA%E3%81%AE%E5%86%8D%E7%99%BA%E6%98%8E%E3%81%97%E3%81%9F-da6c5345263f
zplug "nnao45/zsh-kubectl-completion"

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

REPORTTIME=10

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

zstyle ':completion:*:git:*' user-commands ${${(k)commands[(I)git-*]}#git-}



###################################################
#            コマンドエイリアス系                 #
###################################################

#setopt complete_aliases
if [ "$(uname)" = 'Darwin' ]; then
    alias ls='ls -v -G -h'
else
    alias ls='ls -v --group-directories-first --color=auto --classify -h'
fi
alias la="ls -a"
alias ll="ls -l"
alias lla="ls -al"

alias df="df -h"

alias cp="cp -i"
alias mv="mv -i"
alias du="du -h"

# mycom.9
zstyle ':completion:*' list-colors ''

# http://askubuntu.com/a/22043
alias sudo='sudo '

alias grep="grep --color=always -i"
alias tree="tree -CN"
if which git-foresta &> /dev/null; then
    alias git-foresta="git-foresta | less -RSX"
fi

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
# デフォルトで定義されているけどstatが良い感じになるよう再定義
# TODO: ここ、tputコマンドで自動的に文字幅を決めるようにする
alias glg="git log --stat=300,300 --stat-graph-width=20"
alias gdst="git diff --stat=300,300 --stat-graph-width=20"
# git diff to head
function gdh() {
  git diff $1..HEAD
}
# git diff to head summary
function gdhs() {
  git diff --stat=300,300 --stat-graph-width=30 $1..HEAD
}

# git diff --stat=300,300 --stat-graph-width=10 origin/develop..HEAD

# https://qiita.com/takc923/items/598a68c4684114ffb102
alias less="less -iMR"

#alias history="history -E"

if which ack-grep &> /dev/null; then
    alias ack="ack-grep --smart-case"
else
    alias ack="ack --smart-case"
fi

if which pcregrep &> /dev/null; then
    alias pcregrep="pcregrep -Hn --color"
fi

if which colordiff &> /dev/null; then
    alias diff=colordiff
fi

# https://github.com/andreafrancia/trash-cli#can-i-alias-rm-to-trash-put
# if which trash-put &> /dev/null; then
#     alias rm='trash-put'
# fi

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g .../='../..'
alias -g ..../='../../..'
alias -g ...../='../../../..'

alias agh="ag --hidden"
alias agl="ag -l"

alias mycli="mycli --warn"

# alias k=kubectl
alias k=kubecolor


###################################################
#                 パス/source系                   #
###################################################

PATH=$PATH:$HOME/bin

# .zsh_historyはリンクではうまく動かないのでHISTFILEで指定する
if [ -e $HOME/Dropbox/linux/dotfiles/.zsh_history ]; then
    HISTFILE=$HOME/Dropbox/linux/dotfiles/.zsh_history
else
    HISTFILE=$HOME/.zsh_history
fi

# https://cookiecutter.readthedocs.io/en/1.7.2/installation.html#unix-and-macos
# これによるなら $HOME/bin はやめてこちらに寄せたほうが良いかも
if [ -e ~/.local/bin ]; then
    export PATH=$HOME/.local/bin:$PATH
fi

if [ -e /usr/local/bin ]; then
    export PATH="$PATH:/usr/local/bin"
fi

if [ -e $HOME/.cargo/bin ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -e /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

# gnome-terminalのsolarized絡みで入れたdir_colorsの読み込み設定
# https://github.com/aruhier/gnome-terminal-colors-solarized#dircolors
if [ -e ~/.dir_colors ]; then
    eval `dircolors $HOME/.dir_colors/dircolors`
fi

# http://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-command-completion.html
# 本家マニュアルに従い以下の記述へ変更するが、
# http://qiita.com/takeo-asai/items/c0ab835b9ba244d0d17a
# 上のqiitaに書かれている通り落ちるという報告もあるのでやばかったら削除
# 後々再検討する場合はaws_zsh_completer.sh自体のヘッダの記述も参考にする
#if which aws_zsh_completer.sh &> /dev/null; then
#    source aws_zsh_completer.sh
#fi

if [ -e ~/go ]; then
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
fi

if [ -e $HOME/.rbenv/bin ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
fi

if [ -e $HOME/.anyenv/ ]; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"
fi

if [ -e $HOME/.tfenv/ ]; then
    export PATH="$HOME/.tfenv/bin:$PATH"
fi

if which direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi




if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

if [ -e /usr/local/opt/gnu-sed/libexec/gnubin ]; then
    export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
    # 面倒なのでもう全部ここに書いてしまった
    export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
    export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
    export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
    export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
    export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
fi

# http://qiita.com/takyam/items/d6afacc7934de9b0e85e
if [ "$(uname)" = 'Darwin' ]; then
    export PATH=$PATH:/usr/local/share/git-core/contrib/diff-highlight # mac
else
    export PATH=$PATH:/usr/share/doc/git/contrib/diff-highlight # ubuntu
fi

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh


###################################################
#                    fzf設定                      #
###################################################

# 本家のhistory search用関数だと
# 直接呼び出しならうまく行くがbindkeyするとなぜか
# 選択後にEnterを押さないと選択したコマンドが入力されなかったので
# こちらから拝借
# https://blog.tsub.me/post/move-from-peco-to-fzf/
# 改造に伴い参考リンク追加
# https://github.com/junegunn/fzf/wiki/examples#opening-files
# https://github.com/junegunn/fzf/issues/477


if which fzf-tmux &> /dev/null; then
  FZF_PATH=$(which fzf-tmux)
else
  FZF_PATH=fzf
fi
function history-fzf() {
  local tac

  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi

  # 一つ目のsedはSHARE_HISTORY有効時にfc -lコマンドが他のタブで入力されたコマンドの数字の後に勝手に*をつけるのを除去するため
  # LANG=CはUTF-8っぽい行でsedが失敗するため、無視するよう設定
  local out key comm
  IFS=$'\n' out=($( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | \
      LANG=C LC_CTYPE=C sed 's/^\( *[0-9]*\)\*/\1 /' | \
      $FZF_PATH -e +s --tac --query "$LBUFFER" --expect=enter,ctrl-e,ctrl-f,ctrl-a,ctrl-b))
  key=$(head -1 <<< "$out")
  comm=$(head -2 <<< "$out" | tail -1 | sed 's/^[0-9]* *//')
  BUFFER=$comm
  CURSOR=$#BUFFER

  zle reset-prompt
  if [ "$key" = 'enter' ]; then
      zle accept-line
  fi
}

zle -N history-fzf
bindkey '^r' history-fzf

# pipeと引数どちらでも表示できるjq less関数
function jqless() {
    if [ -p /dev/stdin ]; then
        cat - | jq -C '.' | less
    else
        cat $@ | jq -C '.' | less
    fi
}

# pipeと引数どちらでも表示できるjqformat
function jqformat() {
    if [ -p /dev/stdin ]; then
        cat - | jq -C '.'
    else
        cat $@ | jq -C '.'
    fi
}

# git用便利変数
function precmd_set_git_root_variable() {
  GIT_ROOT=$(git rev-parse --show-toplevel 2> /dev/null)
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd precmd_set_git_root_variable

# git用便利変数2
function precmd_set_git_rel_variable() {
  GIT_REL=$(git rev-parse --show-prefix 2> /dev/null)
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd precmd_set_git_rel_variable




export PATH="/usr/local/opt/mysql-client/bin:$PATH"

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/knishida/code/usd-index/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/knishida/code/usd-index/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/knishida/code/usd-index/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/knishida/code/usd-index/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /Users/knishida/code/usd-index/node_modules/tabtab/.completions/slss.zsh ]] && . /Users/knishida/code/usd-index/node_modules/tabtab/.completions/slss.zsh

# for macosx
# https://stackoverflow.com/a/52230415/4006322
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

alias kubectlks='kubectl -n kube-system'
alias kubectldd='kubectl -n datadog'
alias agtf='ag --terraform --ignore .terraform'
alias jn='jsonnet'

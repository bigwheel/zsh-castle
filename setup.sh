#!/usr/bin/env bash

set -eux

# http://qiita.com/yudoufu/items/48cb6fb71e5b498b2532
script_dir=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

sudo apt-get install -y zsh

git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
ln -s $script_dir/my-zshrc.zsh $HOME/.oh-my-zsh/custom/my-zshrc.zsh

#!/usr/bin/env bats

@test 'tmux command exists' {
  run zsh --version
  [ "$status" -eq 0 ]
}

@test 'config files exist' {
  [ -e $HOME/.oh-my-zsh ]
  [ -e $HOME/.zshrc ]
}

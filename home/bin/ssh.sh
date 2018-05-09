#!/usr/bin/env bash

while true; do
  read -r host
  read -r id
  read -r pw_file_path
  break
done < $1

# $pw_file_path に含まれるチルダ/$HOMEを解決させるにはevalが必要らしい
# https://qiita.com/kod314/items/f8aa4929501882e97b38
SSHPASS=$(eval cat $pw_file_path) sshpass -e ssh $id@$host

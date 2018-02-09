#!/usr/bin/env bash

while true; do
  read -r host
  read -r id
  read -r pw_file_path
  break
done < $1

# うまく動いていない。要改良
sshpass -f $pw_file_path ssh $id@$host

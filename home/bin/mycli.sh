#!/usr/bin/env bash

while true; do
  read -r host
  read -r id
  read -r pw
  break
done < $1

expect -c "
spawn mycli -u $id -h $host
expect \"Password:\"
sleep 2
send \"$pw\n\"
expect \"Version:\"
interact
"

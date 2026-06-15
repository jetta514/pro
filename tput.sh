#!/bin/bash

ret=$(($(tput cols) - 2))
tput clear
tput cup 0 0
echo -n "╔"
for ((i=1; i<=ret; i++)); do printf '═'; done
echo -n "╗"
tput cup 1 0
echo -n "║"
center=$((($(tput cols)-15)/2))
tput cup 1 $center
echo -n "Быстрые команды"
tput cup 1  $(tput cols)
 echo -n "║"
tput cup 2 0
 echo -n "╠"
for ((i=1; i<=ret; i++)); do
  if [[ $i == 8 ]]; then
    printf '╦'
  else
    printf '═'
  fi
done
 echo -n "╣"
tput cup 3 0
echo -n "║"
tput cup 3 3
echo -n "rc"
tput cup 3 8
echo -n "║"
tput cup 3 12
echo -n "nano ~/.config/fish/config.fish"
tput cup 3 $(tput cols)
echo -n "║"

tput cup 4 0
 echo -n "╠"
for ((i=1; i<=ret; i++)); do
  if [[ $i == 8 ]]; then
    printf '╬'
  else
    printf '═'
  fi
done
 echo -n "╣"
tput cup 5 0
 echo -n "║"
 tput cup 5 3
echo -n "pro"
 tput cup 5 8
echo -n "║"
tput cup 5 12
 echo -n "nano /sdcard/newnew/pro.sh"
 tput cup 5 $(tput cols)
echo -n "║"
tput cup 6 0
 echo -n "╚"
for ((i=1; i<=ret; i++)); do
  if [[ $i == 8 ]]; then
    printf '╩'
  else
    printf '═'
  fi
done
 echo -n "╝"
tput cup $(tput lines) 0 

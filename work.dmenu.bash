#!/bin/bash

cd $HOME/code/scripts/

awk -F, '{
  if ($2 != "") {
    print $2
  } else {
    print $1
  }
}' /home/linus/code/scripts/work.csv | dmenu -i -l 5 | while read selection; do
  if [ -z "$selection" ]; then
    exit 0
  fi
  awk -F, -v sel="$selection" '
    $2 == sel { print $1; found=1 }
    $2 == "" && $1 == sel { print $1; found=1 }
    END { if (!found) exit 1 }
    ' /home/linus/code/scripts/work.csv | while read dir; do
    tmux send-keys -t main:work.1 "cd $dir" C-m
  done
done


#!/bin/bash

cd $HOME/code/scripts/

awk -F, '{
  if ($2 != "") {
    print $2
  } else {
    print $1
  }
}' $HOME/code/scripts/work.csv | fzf --tmux 80%,80% --border-label ' workspaces ' --style full | while read selection; do
  if [ -z "$selection" ]; then
    exit 0
  fi
  awk -F, -v sel="$selection" '
    $2 == sel { print $1; found=1 }
    $2 == "" && $1 == sel { print $1; found=1 }
    END { if (!found) exit 1 }
    ' $HOME/code/scripts/work.csv | while read dir; do
    tmux send-keys -t main:work.1 "cd $dir" C-m
    # tmux send-keys -t main:work.1 "nvim ." C-m
  done
done


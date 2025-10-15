#!/bin/bash

tmux rename-session main
tmux rename-window work

tmux new-window -n list 
tmux send-keys -t main:list.1 "cd $HOME/lists" C-m
tmux new-window -n code
tmux send-keys -t main:temp.1 "cd $HOME/code" C-m
tmux new-window -n note
tmux send-keys -t main:note.1 "cd $HOME/obsidian" C-m


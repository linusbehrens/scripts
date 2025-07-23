#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <command>"
    exit 1
fi

tmux send-keys -t main:work.1 "$1" C-m

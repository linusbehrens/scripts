#!/bin/bash

path=$HOME/Documents/Notizen/

finder="fzf --preview 'fzf-preview.sh {}' --tmux 80%,80% --style full"
# finder="dmenu -c -l 10"
# tmux.inject.bash "mshow $index | nvim"

newnote () { \
    name="$(echo "" | $finder <&-)" || exit 0
    : "${name:=$(date +%F_%T | tr ':' '-')}"
    setsid -f "$TERMINAL" -e nvim $path$name".md" >/dev/null 2>&1
}

selected () { \
    choice=$(echo -e "New\n$(command ls -t1 $folder)" | $finder)
    case $choice in
        New) newnote ;;
        *.md) setsid -f "$TERMINAL" -e nvim "$folder$choice" >/dev/null 2>&1 ;;
        *) exit ;;
    esac
}

selected

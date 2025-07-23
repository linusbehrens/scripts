#!/bin/bash

mbsync -a

mlist -N $MAIL | mseq -S
# selection=$(mthread | mscan | fzf --preview 'echo {} | mshow')
selection=$(mlist -N $MAIL | fzf --preview 'echo {} | mshow' --tmux 80%,80% --border-label ' mail@linus-behrens.de ' --style full ) || exit

index=$(printf "$(mthread | mscan)" | awk -v sel="$selection" 'BEGIN{i=0} $0==sel{print i; exit} {i++}')

index=index + 1

tmux.inject.bash "mshow $index | nvim"

# --bind 'focus:transform-preview-label:[[ -n {} ]] && mshow -h subject {}' \

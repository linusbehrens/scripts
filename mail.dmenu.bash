#!/bin/bash

mbsync -a && echo "sync..." | dmenu -c -l 1 > /dev/null

path=$HOME/Mail/
mails=$(ls -1 $path)
news=$''

for mail in $mails; do
    # cd $path/$mail
    cd $path/mail@linus-behrens.de

    # echo $(pwd)
    mlist -N . | mseq -S
    result=$(mscan -I -f '%F %16D %25f %s')
    # TODO: nicht mit ls sondern mblaze:
    # result=account/time/sender/Betreff
    if [[ -n $result ]]; then
        news+="$result"
        news+=$'\n'
    fi
done

if [[ "$news" == "" ]]; then
    news="no news"
fi

printf "%s" "$news" | dmenu -c -l 10 > /dev/null

# until [[ "$news" == "" ]]; do
#     new=$(printf "%s" "$news" | dmenu -c -l 10 )
#     if [[ "$new" == "no news" || "$new" == "e" || "$new" == "exit" ]]; then
#         exit
#     fi
#     if [[ "$new" == "n" ]]; then
#         mless
#     fi
# done

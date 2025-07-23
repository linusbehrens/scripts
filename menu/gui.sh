#!/bin/bash

# Read all lines from stdin into an AppleScript list
choices=$(cat | awk '{ print "\"" $0 "\"," }' | tr -d '\n' | sed 's/,$//')

# Run AppleScript to show a dialog and return the selection
osascript <<EOF
set theList to {${choices}}
set chosenItem to choose from list theList with prompt "Choose an item:" default items {} without multiple selections allowed and empty selection allowed
if chosenItem is false then
    return
else
    set chosenItem to item 1 of chosenItem
    do shell script "echo " & quoted form of chosenItem
end if
EOF

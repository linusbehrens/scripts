#!/bin/bash

# Read list from stdin
choices=$(cat)

# Exit if no input
[ -z "$choices" ] && exit 1

# Convert input to comma-separated values for SwiftDialog
choices_csv=$(echo "$choices" | sed 's/"/\\"/g' | paste -sd ',' -)

# Launch SwiftDialog with a list
selected=$(dialog --title "gxfzf" \
    --message "Choose an option:" \
    --selecttitle "Options" \
    --selectvalues "$choices_csv" \
    --button1text "Select" \
    --button2text "Cancel" \
    --width 500 \
    --height 400 \
    --json)

# Check if the user selected or cancelled
if echo "$selected" | grep -q '"button_pressed": "Select"'; then
    # Extract selected value
    echo "$selected" | sed -n 's/.*"selected_option": "\(.*\)".*/\1/p'
else
    exit 130  # Indicate cancel
fi

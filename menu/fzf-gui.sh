#!/bin/bash

# Define your list of options
OPTIONS=$(cat <<EOF
📁 Open Folder
📄 Open File
📝 Edit Config
🌐 Launch Browser
🖼️ View Image
🔒 Lock Screen
🚪 Logout
EOF
)

# Pipe options into fzf
SELECTION=$(echo "$OPTIONS" | fzf --height=40% --reverse --border \
    --prompt="➤ Choose action: " \
    --preview-window=right:wrap \
    --preview="echo {}" \
    --header="🚀 Interactive Menu - Use ↑ ↓ to navigate, Enter to select")

# Handle the selection
case "$SELECTION" in
    "📁 Open Folder")
        echo "Opening Finder to ~/Documents"
        open ~/Documents
        ;;
    "📄 Open File")
        echo "Opening example.txt"
        open ~/example.txt
        ;;
    "📝 Edit Config")
        echo "Opening .zshrc in default editor"
        open ~/.zshrc
        ;;
    "🌐 Launch Browser")
        echo "Launching Safari"
        open -a Safari
        ;;
    "🖼️ View Image")
        echo "Viewing sample.jpg"
        open ~/Pictures/sample.jpg
        ;;
    "🔒 Lock Screen")
        echo "Locking screen"
        /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
        ;;
    "🚪 Logout")
        echo "Logging out"
        osascript -e 'tell application "System Events" to log out'
        ;;
    *)
        echo "No action selected or cancelled."
        ;;
esac

#! /bin/bash

clear
cd $HOME/stagit

title() {
    local message="$1"

    echo ""
    echo ""
    echo "  $message"
    echo -n " "
    printf '%.0s-' {1..34}; echo
    echo ""
}

ok() {
    echo -e " [\e[32mok!\e[0m]"
}

length() {
    local string="$1"
    local width=23
    echo -n "    "
    printf '%-*s' "$width" "$string"
}


stagitdir() {
    local app="$1"

    length "$app"
    cp style.css ./$app
    cp meta/$app.png ./$app/logo.png
    cd $app
    stagit "$HOME/stagit/repos/$app"
    ok
    cd ..
}

echo ""
echo "  Stagit gen script, by Linus"
echo -n " "
printf '=%.0s' {1..34}; echo

title "Stagit: Repositories"

stagitdir sandbox 
stagitdir obsidian 
stagitdir dotfiles 
stagitdir Unterlagen 
stagitdir personalwebsite 

title "Stagit: Indexing"


length "Indexing"
stagit-index \
    $HOME/obsidian \
    $HOME/Documents/Unterlagen \
    $HOME/dotfiles \
    $HOME/code/sandbox \
    $HOME/code/personalwebsite \
    > index.html
ok

title "Nginx: Reload"

sudo nginx -s reload > /dev/null 2>&1
length "Reload"
ok
echo ""

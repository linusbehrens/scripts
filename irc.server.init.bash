#!/bin/bash
PASS=$(pass show irc/ngircd-operator)  # adjust path to your pass entry
CONFIG=$(mktemp)

# inject the password
sed "s|{{PASSWORD}}|$PASS|" irc.server.conf > "$CONFIG"

# run ngircd with custom config
ngircd -f "$CONFIG"

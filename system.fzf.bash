#!/bin/bash

case "$(printf "kill\nzzz\nreboot\nshutdown" | fzf )" in
	kill) ps -u $USER -o pid,comm,%cpu,%mem | fzf | awk '{print $1}' | xargs -r kill ;;
	zzz) slock systemctl suspend -i ;;
	reboot) sudo openrc-shutdown -r now ;;
	shutdown) shutdown now ;;
	*) exit 1 ;;
esac

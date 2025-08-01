#!/bin/bash

case "$(printf "kill\nzzz\nreboot\nshutdown" | dmenu -i -l 4)" in
	kill) ps -u $USER -o pid,comm,%cpu,%mem | dmenu -i -l 10 -p Kill: | awk '{print $1}' | xargs -r kill ;;
	zzz) slock systemctl suspend -i ;;
	reboot) sudo openrc-shutdown -r now ;;
	shutdown) shutdown now ;;
	*) exit 1 ;;
esac

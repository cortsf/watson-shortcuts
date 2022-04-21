#!/usr/bin/env bash

status="$(watson status)"
if [ "$status" == "No project started." ]; then
    choice=$(echo -e "no\nyes" | dmenu -p "Do you REALLY want to delete ALL projects from watson?" -l 3)

    if [ "$choice" == "yes" ]; then
	echo "[]" > ~/.config/watson/frames && dzen_notification.sh "REMOVED ALL WATSON ENTRIES" 3 "info"
    else
	dzen_notification.sh "USER CANCELLED" 5 "warning"
    fi
else
    dzen_notification.sh "A project is running, stop it and try again." 3 "warning"
fi

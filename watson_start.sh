#!/usr/bin/env bash

status="$(watson status)"
if [ "$status" == "No project started." ]; then
    projects="$(watson projects)"
    project="$(echo "$projects" | dmenu -fn '-bitstream-charter-medium-r-normal--12-120-75-75-p-68-iso8859-1[65 70 80_90]')"
    result="$(watson start "$project")"

    if [ "$?" == "0" ]; then
	dzen_notification.sh "$result" 3 "info"
    elif [ "$project" == "" ]; then
	dzen_notification.sh "USER CANCELLED" 3 "warning"
    else
	dzen_notification.sh "CHECK STATUS" 3 "error"
    fi

else
    dzen_notification.sh "Project is running." 3 "warning"
fi

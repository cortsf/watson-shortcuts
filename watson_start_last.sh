#!/usr/bin/env bash

status="$(watson status)"
if [ "$status" == "No project started." ]; then
    log="$(watson log --no-reverse | tail -n1)"
    if [ "$log" != "" ]; then
	stringarray=($log)
	project=${stringarray[-1]}
	result="$(watson start "$project")"
	if [ "$?" == "0" ]; then
	    ~/.bin/dzen_notification.sh "$result" 3 "info"
	else
	    ~/.bin/dzen_notification.sh "CHECK STATUS" 3 "error"
	fi
    else
	~/.bin/watson_start.sh # "No projects registered. Create a new one."
    fi
else
    ~/.bin/dzen_notification.sh "Project is running." 3 "warning"
fi

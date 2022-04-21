#!/usr/bin/env bash

projects="$(watson projects)"
if [ "$projects" == "" ]; then
    status="$(watson status)"
    if [ "$status" == "No project started." ]; then
	dzen_notification.sh "No projects found" 3 "warning"
    else
	dzen_notification.sh "No projects found but a new project is running. Check status." 3 "warning"
    fi
else
    result="$(echo "$projects" | dmenu)"
    if [ "$result" != "" ]; then
	dzen_notification.sh "$(watson report -p "$result" -d -c) (TODAY)" 3 
    fi
fi

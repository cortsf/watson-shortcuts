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
    log="$(watson log --no-reverse | tail -n1)"
    stringarray=($log)
    project=${stringarray[-1]}
    echo $project
    dzen_notification.sh "$(watson report -p "$project" -d -c) (TODAY)" 3 
fi

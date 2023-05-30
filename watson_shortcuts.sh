#!/usr/bin/env bash

watson_projects () {
    projects="$(watson projects)"
    if [ "$projects" == "" ]; then
	status="$(watson status)"
	if [ "$status" == "No project started." ]; then
  	    notify "No projects found" 3 "warning"
	else
  	    notify "No projects found but a new project is running. Check status." 3 "warning"
	fi
    else
	result="$(echo "$projects" | dmenu)"
	if [ "$result" != "" ]; then
  	    notify "$(watson report -p "$result" -d -c) (TODAY)" 3 
	fi
    fi
}

watson_stop () {
    result="$(watson stop)"

    if [ "$result" == "" ]; then
	notify "No project started." 3 "warning"
    else
	notify "$result" 3 
    fi
}

watson_status () {
    result="$(watson status)"
    if [ "$result" == "No project started." ]; then
	notify "$result" 3 "warning"
    else
	notify "$result" 3 "info"
    fi
}

watson_start_last () {
    status="$(watson status)"
    if [ "$status" == "No project started." ]; then
	log="$(watson log --no-reverse | tail -n1)"
	if [ "$log" != "" ]; then
	    stringarray=($log)
	    project=${stringarray[-1]}
	    result="$(watson start "$project")"
	    if [ "$?" == "0" ]; then
		notify "$result" 1 "info"
	    else
		notify "CHECK STATUS" 3 "error"
	    fi
	else
	    watson_start # "No projects registered. Create a new one."
	fi
    else
	notify "Project is running." 3 "warning"
    fi
}

watson_start () {
    status="$(watson status)"
    if [ "$status" == "No project started." ]; then
	projects="$(watson projects)"
	project="$(echo "$projects" | dmenu -fn '-bitstream-charter-medium-r-normal--12-120-75-75-p-68-iso8859-1[65 70 80_90]')"
	result="$(watson start "$project")"
	if [ "$?" == "0" ]; then
	    notify "$result" 3 "info"
	elif [ "$project" == "" ]; then
	    notify "USER CANCELLED" 3 "warning"
	else
	    notify "CHECK STATUS" 3 "error"
	fi
    else
	notify "Project is running." 3 "warning"
    fi
}

watson_show_last () {
    log="$(echo "$(watson log -d)" | tail -n1)"
    log="$(echo "$log" | cut -d ' ' -f2-)"
    notify "$log" 4 
}

watson_restart () {
    # This scripts restarts last project WITHOUT ANY GAP. 
    # It uses last frame end time instead of current time to start a new frame.
    status="$(watson status)"
    if [ "$status" == "No project started." ]; then
	log="$(watson log --no-reverse | tail -n1)"
	if [ "$log" != "" ]; then
	    result="$(watson restart -G)"
	    if [ "$?" == "0" ]; then
		notify "RESTART WITHOUT GAP!!! -- $result" 3 "info"
	    else
		notify "CHECK STATUS" 3 "error"
	    fi
	else
	    watson_start # "No projects registered. Create a new one."
	fi
    else
	notify "Project is running." 3 "warning"
    fi
}

watson_report_yesterday () {
    yesterday="$(dateadd "$(date '+%Y-%m-%d')" -1d)"
    watson report -C --from "$yesterday" --to "$yesterday"
}

watson_report () {
    report="$(watson report -c -d | tail -n 1)"
    notify "$report (TODAY - ALL PROJECTS)" 3 "info"
}

watson_remove_last () {
    if [ "$(watson projects)" == "" ]; then
	notify "No projects found" 3 "warning"
    else
	status="$(watson status)"
	if [ "$status" == "No project started." ]; then
	    last="$(echo "$(watson log -d)" | tail -n1)"
	    last2="$(echo "$last" | cut -d ' ' -f2-)"
	    choice=$(echo -e "no\nyes" | dmenu -p "Do you want to delete the LAST FRAME from watson? $last2" -l 3)
	    if [ "$choice" == "yes" ]; then
		watson remove -1 -f && notify "REMOVED LAST FRAME" 3 "info"
	    else
		notify "USER CANCELLED" 5 "warning"
	    fi
	else
	    notify "A project is running, stop it and try again." 3 "warning"
	fi
    fi
}

watson_remove () {
    if [ "$(watson projects)" == "" ]; then
	notify "No projects found" 3 "warning"
    else
	status="$(watson status)"
	if [ "$status" == "No project started." ]; then
	    choice=$(echo -e "no\nyes" | dmenu -p "Do you REALLY want to delete ALL projects from watson?" -l 3)
	    if [ "$choice" == "yes" ]; then
		echo "[]" > ~/.config/watson/frames && notify "REMOVED ALL WATSON ENTRIES" 3 "info"
	    else
		notify "USER CANCELLED" 5 "warning"
	    fi
	else
	    notify "A project is running, stop it and try again." 3 "warning"
	fi
    fi
}

watson_projects_last () {
    projects="$(watson projects)"
    if [ "$projects" == "" ]; then
	status="$(watson status)"
	if [ "$status" == "No project started." ]; then
	    notify "No projects found" 3 "warning"
	else
	    notify "No projects found but a new project is running. Check status." 3 "warning"
	fi
    else
	log="$(watson log --no-reverse | tail -n1)"
	stringarray=($log)
	project=${stringarray[-1]}
	echo $project
	notify "$(watson report -p "$project" -d -c) (TODAY)" 3 
    fi
}


notify () {
    #usage: notify message [time] [info|warning|error|hex color]
    pkill -9 dzen2
    if [ "$#" -gt 1 ]; then
	time=$2;
    else
	time=1;
    fi
    if [ "$#" -gt 2 ]; then
	case $3 in
	    "info") 	
		bgcolor="#dfa";;
	    "warning") 	
		bgcolor="#E1BB49";;
	    "error") 	
		bgcolor="#AF4646";;
	    *)
		bgcolor="$3";;
	esac
    else
	bgcolor="#dfa";
    fi
    echo $1 | dzen2 -p $time -bg "$bgcolor" -fg "#000" -h 26
    echo $1 > ~/.last_notification
}

case "$1" in 
  "projects")
    watson_projects
    ;;
  "stop")
    watson_stop
    ;;
  "status")
    watson_status
    ;;
  "start_last")
    watson_start_last
    ;;
  "start")
    watson_start
    ;;
  "show_last")
    watson_show_last
    ;;
  "restart")
    watson_restart
    ;;
  "report_yesterday")
    watson_yesterday
    ;;
  "report")
    watson_report
    ;;
  "remove_last")
    watson_remove_last
    ;;
  "remove")
    watson_remove
    ;;
  "projects_last")
    watson_projects_last
    ;;
  *) 
    notify "watson_bash.sh - wrong or no argument: '$1'" 3 error
    ;; 
esac

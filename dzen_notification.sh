#!/usr/bin/env bash

# Usage: dzen_notification.sh message [time] [info|warning|error|hex color]

# TODO: Specifiying color ($3) implies this script must be called with 3 arguments. Fix this.

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

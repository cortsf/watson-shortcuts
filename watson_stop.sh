#!/usr/bin/env bash

result="$(watson stop)"

if [ "$result" == "" ]; then
    dzen_notification.sh "No project started." 3 "warning"
else
    dzen_notification.sh "$result" 3 
fi

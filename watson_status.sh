#!/usr/bin/env bash

result="$(watson status)"

if [ "$result" == "No project started." ]; then
    dzen_notification.sh "$result" 3 "warning"
else
    dzen_notification.sh "$result" 3 "info"
fi

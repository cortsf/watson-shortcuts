#!/usr/bin/env bash

last_notification="$(cat ~/.last_notification)"
echo "$last_notification" | dzen2 -p 5 -bg "#dfa" -fg "#000" -h 26

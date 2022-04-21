#!/usr/bin/env bash

report="$(watson report -c -d | tail -n 1)"
dzen_notification.sh "$report (TODAY - ALL PROJECTS)" 3 "info"

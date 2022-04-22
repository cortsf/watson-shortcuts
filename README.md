Instructions:

0. install watson, dzen2 and dmenu. (bash is also required)
1. touch ~/.last_notification
2. call scripts as needed (read them!). Using hotkeys is recommended.
3. see `watson help` for additional functionality not covered by these scripts, like frame edits and reports from previous days.

Fix:
- Project names can't use spaces. Automatically replace spaces with "_".

TO-DO:
- Use colors to higlight the most relevant information in dzen messages.

Notes:
- You may have to use more specific paths on all calls to `dzen_notification.sh` for the windows manager to be able to use these scripts. I use `~/.bin/dzen_notification.sh`.

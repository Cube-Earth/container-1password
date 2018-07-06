#!/bin/bash
wine ~/'.wine/drive_c/Program Files (x86)/1Password 4/1password.exe' &
sleep 5
w=`xdotool search --name Frm1pWelcome`
xvkbd -window $w -text ' '
xdotool type -window $w ' '
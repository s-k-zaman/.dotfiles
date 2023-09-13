#!/usr/bin/env bash

notify-send "Phone Connection" "connecting to your realme6" -r 2001

adb tcpip 5555
sleep 3
adb connect 192.168.0.101:5555
notify-send "Phone Connection" "success | running scrcpy" -r 2001
scrcpy
notify-send "Phone Connection" "Done" -u low -r 2001



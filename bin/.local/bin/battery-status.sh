#!/bin/bash

notified=0
urgent_notified=0

while true
    do
       # export DISPLAY=:0.0
       battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
       on_ac_power=`acpi -b | grep -c "Charging"`
       battery_full=`acpi -b | grep -c "Full"`

       if [ $on_ac_power -eq 1 ]; then
           notified=0
           urgent_notified=0
           if [ $battery_full -eq 1 ]; then
              notify-send "Battery" " Charge Complete"
              # paplay /usr/share/sounds/freedesktop/stereo/suspend-error.oga
           fi
       else
           if [[ $battery_level -le 20 && $notified -eq 0 ]]; then
              notify-send --urgency=CRITICAL "Charge Battery" " Low: ${battery_level}%" -r 3001
              notified=1
              # paplay /usr/share/sounds/freedesktop/stereo/suspend-error.oga
           fi
           if [[ $battery_level -le 5 && $urgent_notified -eq 0 ]]; then
              notify-send --urgency=CRITICAL "Charge Battery URGENT" "Very Low: ${battery_level}%" -r 3001
              urgent_notified=1
              # paplay /usr/share/sounds/freedesktop/stereo/suspend-error.oga
           fi
       fi
     sleep 1
done

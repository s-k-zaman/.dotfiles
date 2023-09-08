#!/usr/bin/env bash


variety &
# script-wifi.sh & #enables nm-applet [no need if using networkmanager-dmenu]
sleep 0.50
dunst &
# urxvtc &
lxpolkit &
# picom --config "$HOME/.config/bspwm/picom.conf" &
picom --config "$HOME/.config/picom.conf" &
flameshot &


# ## Conky
# ### SETS CONKY STYLE BASED ON SCREEN RESOLUTION
# # Checks screen resolution.  If 1080p or higher, then we use '01' conky.
# # If less than 1080p (laptops?), then we use the smaller '02' conky.
# # You can also set these to values '03' and '04' if you want a fancier
# # conky that displays lua rings and sensor information.
# resolutionHeight=$(xrandr | grep "primary" | awk '{print $4}' | awk -F "+" '{print $1}' | awk -F 'x' '{print $2}')
#
# COLORSCHEME=Nord
# if [[ $resolutionHeight -ge 1080 ]]; then
#     killall conky || echo "Conky not running."
#     sleep 2
#     conky -c "$HOME"/.config/conky/qtile/02/"$COLORSCHEME".conf || echo "Couldn't start conky."
# elif [[ $resolutionHeight -lt 1080 ]]; then
#     killall conky || echo "Conky not running."
#     sleep 2
#     conky -c "$HOME"/.config/conky/qtile/02/"$COLORSCHEME".conf || echo "Couldn't start conky."
# else
#     killall conky || echo "Conky not running."
#     sleep 2
#     conky -c "$HOME"/.config/conky/qtile/02/"$COLORSCHEME".conf || echo "Couldn't start conky."
# fi

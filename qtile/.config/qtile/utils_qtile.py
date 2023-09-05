import os
from libqtile.utils import guess_terminal
from color_sets_qtile import colors

#########################################
# some var sets, functions to make life easier.
#########################################
#### var sets
## mod key
# run `xmodmap` -> to see the modifier keys.
mod_alt = "mod1"
mod_super = "mod4"
mod_num_lock = "mod2"
mod = mod_super
mod_other = mod_alt if mod == mod_super else mod_super
## bar
bar_size = 35
## applications [these are commands to execute]
launcher = "rofi -show drun"
terminal = guess_terminal()
browser = "brave-browser"
file_manager = "thunar"
thunderbird = "thunderbird"
whatsapp = "whatsapp-for-linux"
screenshot_full_screen = "flameshot full -p /home/zaman/Pictures/Screenshots/"
screenshot = "flameshot gui -p /home/zaman/Pictures/Screenshots/"
wallpaper_next = "variety -n"
wallpaper_prev = "variety -p"
## scripts
# powermenu script explicitly simulate keybinding for log-off.
# SHOULD BE same in script file also, on change.
powermenu = os.path.expanduser("~/.config/rofi/powermenu/powermenu.sh")
autostart = os.path.expanduser("~/.config/qtile/autostart.sh")
# alternate is nm-applet -> autostart file [enable it if needed]
networkmanager = os.path.expanduser(
    "~/.config/networkmanager-dmenu/networkmanager_dmenu"
)
# theme/color to use
colors = colors

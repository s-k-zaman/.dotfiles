import subprocess
from libqtile import bar, layout, hook
from libqtile.config import Click, Drag, Match, Screen
from libqtile.lazy import lazy


# file modules
import layouts_qtile
import groups_qtile
import scratchpads_qtile
import widgets_bars_qtile
import keys_shortcuts_qtile
from utils_qtile import colors, mod, autostart

#########################################
#   KEYS and SHORTCUTS
#########################################
keys = []
for key in keys_shortcuts_qtile.keys:
    keys.append(key)
#########################################
#   WINDOWS and GROUPS
#########################################
groups = groups_qtile.groups
keys.extend(groups_qtile.keys)
#########################################
# Scratchpads
#########################################
groups.append(scratchpads_qtile.scratchpads)
keys.extend(scratchpads_qtile.keys)
#########################################
#   LAYOUT
#########################################
layouts = layouts_qtile.layouts
#########################################
#   BAR AND WIDGETS/EXTENSIONS
#########################################
bar_size = 31  # used inside Screen()
widget_defaults = widgets_bars_qtile.widget_defaults
extension_defaults = widget_defaults.copy()
widgets = widgets_bars_qtile.bar_main_widgets
#########################################
#   INITIALIZE SCREEN
#########################################
# initialize widgets on the screen.
screens = [
    Screen(
        top=bar.Bar(
            widgets,
            bar_size,
            # border_width=[2, 0, 2, 0],
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]
            background=colors["transparent"],  # gives transparency to bar
        ),
    ),
]

#########################################
#   OTHER MISCELLANEOUS
#########################################
# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        #### allow floating to certain windows/apps
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None


#########################################
#   autostart
#########################################
@hook.subscribe.startup_once
def start_once():
    subprocess.call([autostart])


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

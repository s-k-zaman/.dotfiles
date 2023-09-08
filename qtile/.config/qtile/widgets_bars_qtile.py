import subprocess
from libqtile import qtile

# Make sure 'qtile-extras' is installed or this config will not work.
from qtile_extras import widget
from qtile_extras.widget.decorations import RectDecoration

# file
from utils_qtile import colors, terminal, powermenu, networkmanager, launcher

#########################################
#   BAR AND WIDGETS/EXTENSIONS
#########################################
font_ubuntu_bold = dict(font="Ubuntu Bold", size=12)
font_firaCode_regular = dict(font="FiraCode Nerd Font Regular", size=12)
font_firaCode_mono = dict(font="FiraCode Nerd Font Mono", size=18)
font_fontAwesome_brands = dict(font="Font Awesome 5 Brands", size=15)
font_fontAwesome_solid = dict(font="Font Awesome 5 Free Solid", size=15, size_l=18)
font_noto_emoji = dict(font="Noto Color Emoji", scale=20)
font_material_icons = dict(font="Material Design Icons", scale=20)

default_font = font_ubuntu_bold
widget_defaults = dict(
    font=default_font["font"],
    fontsize=default_font["size"],
    padding=None,
    background=colors["bar"],
    foreground=colors["light2"],
)
round_decoration_color = colors["shade2"]
# groupbox color
groupbox_decoration_color = colors["shade3"]
groupbox_active_color = colors["dark1"]
groupbox_inactive_color = colors["dark2"]
groupbox_highlight_color = colors["light2"]
groupbox_highlight_bar_color = colors["light2"]


## decorators , spacers, bars
def get_rounded_decoration(color=round_decoration_color):
    return [
        RectDecoration(colour=color, radius=10, filled=True, padding_y=4, group=True)
    ]


separator_bar = widget.TextBox(text="|", padding=2, fontsize=14)


## functions
def access_powermenu():
    subprocess.call([powermenu])


def access_network_menu():
    subprocess.call([networkmanager])


# widgets
bar_main_widgets = [
    widget.Prompt(font="Ubuntu Mono", fontsize=14, foreground=colors["highlight9"]),
    widget.TextBox(
        text="󱓞",
        fontsize=20,
        mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(launcher)},
    ),
    ### LEFT SIDE
    widget.GroupBox(
        fontsize=13,
        margin_y=4,
        margin_x=4,
        padding_x=4,
        markup=True,
        borderwidth=3,
        active=groupbox_active_color,
        inactive=groupbox_inactive_color,
        rounded=False,
        highlight_color=groupbox_highlight_bar_color,
        highlight_method="line",
        urgent_text=colors["red"],
        this_current_screen_border=groupbox_highlight_color,
        this_screen_border=colors["green"],
        other_current_screen_border=groupbox_highlight_color,
        other_screen_border=colors["green"],
        decorations=get_rounded_decoration(groupbox_decoration_color),
    ),
    widget.Spacer(length=8),
    widget.CurrentLayout(fmt="{} "),
    widget.CurrentLayoutIcon(
        # custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
        padding=0,
        scale=0.5,
    ),
    widget.Spacer(length=10),
    widget.PulseVolume(
        fmt="   {}  ",
        decorations=get_rounded_decoration(colors["shade1"]),
        foreground=colors['highlight1']
    ),
    widget.Spacer(length=10),
    widget.WindowName(max_chars=70),
    #### RIGHT SIDE
    widget.Net(
        format="{down:.3f}",
        prefix="M",
        fmt=" 󰓅  {} M/s",
        foreground=colors["highlight6"],
    ),
    widget.Wlan(
        # interface="wlp0s20f3",
        format="{essid} {percent:2.0%}",
        fmt="    {} ",
        mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(access_network_menu())},
        decorations=get_rounded_decoration(),
        foreground=colors["highlight5"],
    ),
    widget.Spacer(length=4),
    widget.Memory(
        mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(terminal + " -e htop")},
        format="{MemUsed: .0f}{mm}",
        fmt="󰂵 {} used",
        foreground=colors["highlight8"],
    ),
    widget.CPU(format="  {load_percent}% ", foreground=colors["highlight7"]),
    widget.Spacer(length=4),
    widget.OpenWeather(
        location="maheshtala",
        format="{main_temp}°{units_temperature} {icon}",
        fmt="󰷔  {} ",
    ),
    widget.Spacer(length=4),
    widget.Battery(
        battery="BAT1",
        low_percentage=0.15,
        low_foreground=colors["red"],
        update_interval=1,
        padding=0,
        format="{hour:d}:{min:02d}Hr",
        foreground=colors["highlight4"],
    ),
    widget.Battery(
        battery="BAT1",
        charge_char="󱐌",
        discharge_char="󰶹",
        empty_char="",
        full_char="",
        low_percentage=0.15,
        low_foreground=colors["red"],
        notify_below=10,
        update_interval=1,
        format="{char}󰁹{percent:2.0%}",
        fmt="{}",
        foreground=colors["highlight3"],
        fontsize=14,
    ),
    widget.Spacer(length=4),
    widget.Backlight(
        backlight_name="intel_backlight",
        change_command="brightnessctl set {}%",
        step=100 / 30,
        fmt="󰃠  {} ",
        padding=9,
        decorations=get_rounded_decoration(),
        foreground=colors["highlight9"],
    ),
    widget.Clock(
        format="    %a, %b %d",
        foreground=colors["highlight2"],
    ),
    widget.Clock(
        padding=0,
        fontsize=14,
        format="%I:%M %p    ",  # %H-> 24 hr, %I -> 12 hr
        foreground=colors["highlight1"],
    ),
    widget.TextBox(
        text=" ⏻ ",
        fontsize=14,
        mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(access_powermenu())},
        decorations=get_rounded_decoration(colors["danger"]),
        foreground=colors["white"],
    ),
    # # decoration end
    # # widget.Spacer(length=8),
    # # INFO: on enabling Systray -> google chrom, brave browser icon overlaping
    # # in left side. although reloading qtile makes it disappear.
    # # widget.Systray(padding=3),
    # # widget.Spacer(length=8),
]

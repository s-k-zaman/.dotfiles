from libqtile import layout

# files
from utils_qtile import colors

#########################################
#   LAYOUT
#########################################
layout_theme = {
    "border_width": 1,
    "margin": 5,
    "border_focus": colors["border_focus"],
    "border_normal": colors["border_normal"],
}
layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(
        border_width=0,
        margin=0,
    ),
    layout.MonadWide(ratio=0.7, **layout_theme),
    # layout.Stack(**layout_theme, num_stacks=2),
    layout.Bsp(**layout_theme),
    # layout.Columns(**layout_theme),
    layout.Zoomy(**layout_theme),
    # layout.Floating(**layout_theme)
    # layout.RatioTile(**layout_theme),
    # layout.Tile(shift_windows=True, **layout_theme),
    # layout.VerticalTile(**layout_theme),
    # layout.Matrix(**layout_theme),
    # layout.TreeTab(
    #     font="Ubuntu Bold",
    #     fontsize=11,
    #     border_width=0,
    #     bg_color=colors[0],
    #     active_bg=colors[8],
    #     active_fg=colors[2],
    #     inactive_bg=colors[1],
    #     inactive_fg=colors[0],
    #     padding_left=8,
    #     padding_x=8,
    #     padding_y=6,
    #     sections=["ONE", "TWO", "THREE"],
    #     section_fontsize=10,
    #     section_fg=colors[7],
    #     section_top=15,
    #     section_bottom=15,
    #     level_shift=8,
    #     vspace=3,
    #     panel_width=240,
    # ),
]

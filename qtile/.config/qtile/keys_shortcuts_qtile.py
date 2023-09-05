from libqtile.config import Key
from libqtile.lazy import lazy
from libqtile import qtile

# file
from utils_qtile import (
    mod,
    mod_alt,
    mod_other,
    launcher,
    terminal,
    browser,
    file_manager,
    powermenu,
    wallpaper_prev,
    wallpaper_next,
    screenshot_full_screen,
    screenshot,
)


#### functions
# Allows you to input a name when adding treetab section.
@lazy.layout.function
def add_treetab_section(layout):
    prompt = qtile.widgets_map["prompt"]
    prompt.start_input("Section name: ", layout.cmd_add_section)


# for minimizing all windows in current group/workspace.
@lazy.function
def minimize_all(qtile):
    for win in qtile.current_group.windows:
        if hasattr(win, "toggle_minimize"):
            win.toggle_minimize()


#########################################
#   KEYS and SHORTCUTS
#########################################
keys = [
    #### quick app + neccessary keys
    Key([mod], "space", lazy.spawn(launcher), desc="Run Launcher"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "b", lazy.spawn(browser), desc="open my browser"),
    Key([mod], "e", lazy.spawn(file_manager), desc="open my file manager"),
    Key(
        ["control"],
        "Print",
        lazy.spawn(screenshot_full_screen),
        desc="take full screenshot",
    ),
    Key([], "Print", lazy.spawn(screenshot), desc="open screenshot app"),
    Key([mod, "shift"], "n", lazy.spawn(wallpaper_next), desc="next wallpaper"),
    Key([mod, "shift"], "p", lazy.spawn(wallpaper_prev), desc="previous wallpaper"),
    # -------
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod_alt, "control"], "u", lazy.spawn(powermenu), desc="Shutdown Qtile"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    ##################### windows, layouts, groups etc. #####################
    #### Toggles + normalize + minimize etc.
    # group/workspace
    Key([mod], "Tab", lazy.screen.toggle_group(), desc="Toggle workspace"),
    # layouts
    Key([mod, "shift"], "Tab", lazy.next_layout(), desc="Toggle next layouts"),
    Key([mod, "control"], "Tab", lazy.prev_layout(), desc="Toggle previous layouts"),
    # windows
    Key(
        [mod_other], "Tab", lazy.layout.next(), desc="Move window focus to other window"
    ),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # minimize
    Key(
        [mod, "shift"],
        "m",
        minimize_all(),
        desc="Toggle hide/show all windows on current group",
    ),
    #### windows movements.
    ## Switch between windows
    # Some layouts like 'monadtall' only need to use j/k to move
    # through the stack, but other layouts like 'columns' will
    # require all four directions h/j/k/l to move around.
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    ## Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"],
        "h",
        lazy.layout.shuffle_left(),
        lazy.layout.move_left().when(layout=["treetab"]),
        desc="Move window to the left/move tab left in treetab",
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        lazy.layout.move_right().when(layout=["treetab"]),
        desc="Move window to the right/move tab right in treetab",
    ),
    Key(
        [mod, "shift"],
        "j",
        lazy.layout.shuffle_down(),
        lazy.layout.section_down().when(layout=["treetab"]),
        desc="Move window down/move down a section in treetab",
    ),
    Key(
        [mod, "shift"],
        "k",
        lazy.layout.shuffle_up(),
        lazy.layout.section_up().when(layout=["treetab"]),
        desc="Move window downup/move up a section in treetab",
    ),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    ## window size grow/shrik
    # grow_<direction>() works in 'bsp' and 'columns' layouts.
    # grow() works in 'monadtall' and 'monadwide' layouts.
    Key(
        [mod, "control"],
        "h",
        lazy.layout.grow_left(),
        lazy.layout.shrink().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left",
    ),
    Key(
        [mod, "control"],
        "l",
        lazy.layout.grow_right(),
        lazy.layout.grow().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the right",
    ),
    Key(
        [mod, "control"],
        "j",
        lazy.layout.grow_down(),
        lazy.layout.grow().when(layout=["monadwide", "monadtall"]),
        desc="Grow window down",
    ),
    Key(
        [mod, "control"],
        "k",
        lazy.layout.grow_up(),
        lazy.layout.shrink().when(layout=["monadwide", "monadtall"]),
        desc="Grow window up",
    ),
    # Following is specially for the 'monadtall' and 'monadwide' layouts,
    Key(
        [mod],
        "equal",
        lazy.layout.grow().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left",
    ),
    Key(
        [mod],
        "minus",
        lazy.layout.shrink().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left",
    ),
    #### layout specific
    # Treetab prompt
    Key(
        [mod, "shift"],
        "a",
        add_treetab_section,
        desc="Prompt to add new section in treetab",
    ),
    ##################### windows, layouts, groups etc. ENDS #####################
]

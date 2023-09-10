from libqtile.lazy import lazy
from libqtile.config import Key, ScratchPad, DropDown

# files
from utils_qtile import mod, whatsapp, thunderbird, terminal

#########################################
# Scratchpads
#########################################
# brave-browser dont work with scratchpads, thus using chromium or vivladi.
# chatgpt = "chromium --app=https://chat.openai.com"
chatgpt = "vivaldi --app=https://chat.openai.com"
text_editor_for_storing = "mousepad Documents/personal/scratchpad.txt"

scratchpad_group_name = "scratchpad"
scratchpads_to_show = [
    dict(
        pad=DropDown(
            chatgpt,
            chatgpt,
            # to the right side
            x=0.62,
            y=0.05,
            width=0.35,
            height=0.6,
            on_focus_lost_hide=False,
        ),
        key=Key(
            [mod], "F5", lazy.group[scratchpad_group_name].dropdown_toggle(chatgpt)
        ),
    ),
    dict(
        pad=DropDown(
            whatsapp,
            whatsapp,
            height=0.8,
            width=0.8,
            x=0.1,
            y=0,
            on_focus_lost_hide=False,
        ),
        key=Key(
            [mod], "F12", lazy.group[scratchpad_group_name].dropdown_toggle(whatsapp)
        ),
    ),
    dict(
        pad=DropDown(
            text_editor_for_storing,
            text_editor_for_storing,
            x=0.3,
            y=0.05,
            width=0.40,
            height=0.4,
            on_focus_lost_hide=False,
        ),
        key=Key(
            [mod],
            "f9",
            lazy.group[scratchpad_group_name].dropdown_toggle(text_editor_for_storing),
        ),
    ),
    dict(
        pad=DropDown(
            terminal,
            terminal,
            x=0.3,
            y=0.05,
            width=0.40,
            height=0.4,
            on_focus_lost_hide=False,
        ),
        key=Key(
            [mod], "F10", lazy.group[scratchpad_group_name].dropdown_toggle(terminal)
        ),
    ),
    dict(
        pad=DropDown(
            thunderbird,
            thunderbird,
            height=0.8,
            width=0.8,
            x=0.1,
            y=0,
            on_focus_lost_hide=False,
        ),
        key=Key(
            [mod], "F1", lazy.group[scratchpad_group_name].dropdown_toggle(thunderbird)
        ),
    ),
]

# DropDown(
#     "scrcpy",
#     "scrcpy -d",
#     x=0.8,
#     y=0.05,
#     width=0.15,
#     height=0.6,
#     on_focus_lost_hide=False,
# ),
## to run terminal commands
# DropDown(
#     "vimwiki",
#     [terminal, "-e", "vim", os.path.expanduser("~/readme.txt")],
#     height=0.35,
#     width=0.8,
#     x=0.1,
#     y=0.0,
#     on_focus_lost_hide=False,
#     opacity=0.85,
#     warp_pointer=False,
# ),

# getting all the keys
keys = []
keys.extend([scratchpad["key"] for scratchpad in scratchpads_to_show])
scratchpads_list = [scratchpad["pad"] for scratchpad in scratchpads_to_show]

scratchpads = ScratchPad(scratchpad_group_name, scratchpads_list)


# this key set is for toggling and accessing scratchpad group.
keys.extend(
    [
        Key(
            [mod, "control"],
            "s",
            lazy.window.togroup("scratchpad"),
            desc="Move Window to scratchpad",
        ),
        Key(
            [mod, "shift"],
            "s",
            lazy.group["scratchpad"].toscreen(toggle=True),
            desc="Toggle scratchpad group",
        ),
    ]
)

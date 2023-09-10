from libqtile.config import Group, Key
from libqtile.lazy import lazy

# files
from utils_qtile import mod

#########################################
#   WINDOWS and GROUPS
#########################################
#### var sets
# can be: number, text, symbol, symbol_text
group_label = "number"

all_groups = [
    # super + name to access that workspace.
    # label will be created later.
    # if layout is blank, will fall to first mentioned layout. currently -> monadtall
    {
        "name": "1",
        "label-symbol": "󰖟",
        "label-text": "WWW",
        "layout": "max",
        # "matches": [
        #     {
        #         "name": "Brave-browser",
        #         "match": Match(wm_class="Brave-browser"),
        #         "follow": True,
        #     },
        # ],
    },
    {
        "name": "2",
        "label-symbol": "",
        "label-text": "ACC",
        "layout": "",
    },
    {
        "name": "3",
        "label-symbol": "",
        "label-text": "VSC",
        "layout": "bsp",
    },
    {
        "name": "4",
        "label-symbol": "󱄢",
        "label-text": "GFX",
        "layout": "",
    },
    {
        "name": "5",
        "label-symbol": "",
        "label-text": "CHAT",
        "layout": "",
    },
    {
        "name": "6",
        "label-symbol": "󱍢",
        "label-text": "MISC",
        "layout": "",
    },
    {
        "name": "7",
        "label-symbol": "",
        "label-text": "FILE",
        "layout": "Zoomy",
    },
    {
        "name": "8",
        "label-symbol": "",
        "label-text": "CODE",
        "layout": "monadwide",
    },
    {
        "name": "9",
        "label-symbol": "󰧑",
        "label-text": "ORG",
        "layout": "",
    },
    {
        "name": "0",
        "label-symbol": "",
        "label-text": "DB",
        "layout": "max",
    },
]

# creating label
if group_label == "symbol_text":
    for g in all_groups:
        label = f'{g["label-symbol"]}  : {g["label-text"]}'
        g["label"] = label
if group_label == "text":
    for g in all_groups:
        label = g["label-text"]
        g["label"] = label
if group_label == "symbol":
    for g in all_groups:
        label = f'{g["label-symbol"]}'
        g["label"] = label
if group_label == "number":
    for g in all_groups:
        label = f'{g["name"]}'
        g["label"] = label

# creating groups
groups = []
window_to_follow = []
for g in all_groups:
    # handling matches
    if g.get("matches"):
        # Group -> matches = [Match, Match, Match,....]
        all_matches = g["matches"]
        matches = []
        for match_item in all_matches:
            matches.append(match_item["match"])
            # TODO: make follow work.
            if match_item.get("follow"):
                window_to_follow.append(match_item["name"])
        groups.append(
            Group(
                name=g["name"],
                layout=g["layout"].lower(),
                label=g["label"],
                matches=matches,
            )
        )
    else:
        groups.append(
            Group(
                name=g["name"],
                layout=g["layout"].lower(),
                label=g["label"],
            )
        )

# TODO: follow window after opening automaically.

# creating basic movements for all groups
keys = []
for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + control + letter of group = move focused window to group
            Key(
                [mod, "control"],
                i.name,
                lazy.window.togroup(i.name),
                desc="Move focused window to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
        ]
    )

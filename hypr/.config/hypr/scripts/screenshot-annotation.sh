#!/bin/bash

sDIR="$HOME/.config/hypr/scripts"

mkdir -p ~/Pictures/Screenshots

tmpfile=$(mktemp)
hyprshot -m output -r -s --clipboard-only >"$tmpfile"
"${sDIR}/Sounds.sh" --screenshot
satty --filename - --fullscreen --initial-tool crop --output-filename ~/Pictures/Screenshots/$(date '+%Y-%m-%d-%H%M%S')_satty.png --early-exit <"$tmpfile"
rm "$tmpfile"

#!/bin/bash

mkdir -p ~/Pictures/Screenshots

hyprshot -m output -r -s --clipboard-only | satty --filename - --fullscreen --initial-tool crop --output-filename ~/Pictures/Screenshots/$(date '+%Y-%m-%d-%H%M%S')_satty.png --early-exit

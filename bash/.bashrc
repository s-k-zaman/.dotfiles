#!/bin/bash
iatest=$(expr index "$-" i)

# Source zachbrownrc if it exists
if [ -f "$HOME/zachbrownrc" ]; then
    . "$HOME/zachbrownrc"
fi

## tmux-sessionizer
# not using 'tmux-sessionizer' instead using sesh
alias tk="tmux kill-server"
if [ -t 1 ]; then
    tmux_or_tss() {
        if tmux has-session 2>/dev/null; then
            tmux attach
        else
            tss
        fi
    }
    # "C-":ctrl, "e":alt
    bind -x '"\C-o":tmux_or_tss'
fi

# yazi file manager
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd <"$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

## GitHub
# copied from Titustech
gitcommit() {
    git add .
    git commit -m "$1"
}

gitlazy() {
    git add .
    git commit -m "$1"
    git push
}
alias lg="lazygit"

# PASSWORDS / API KEYS / ENV VARIABLES
# Source keys file if it exists
if [ -f "$HOME/keys" ]; then
    . "$HOME/keys"
fi

# paste clipboard content in x seconds...
alias clickpaste='sleep 3; xdotool type "$(xclip -o -selection clipboard)"'

# KITTY - alias to be able to use kitty features when connecting to remote servers(e.g use tmux on remote server)
alias kssh="kitty +kitten ssh"

# PYTHON
alias pythonvenv="python3 -m venv venv"
alias srve="source ./venv/bin/activate"
srpe() {
    source $(poetry env info --path)/bin/activate
}
# AI Related
alias ai="opencode"

### OTHER ALIASES
## loading other aliases in files
# Game aliases
if [ -f ~/.game_alias_bash ]; then
    . ~/.game_alias_bash
fi
# docker images
if [ -f ~/.docker_alias_bash ]; then
    . ~/.docker_alias_bash
fi
# epubs
if [ -f ~/.epub-bash ]; then
    . ~/.epub-bash
fi
# networkmanager-dmenu
alias networkmanager-dmenu="~/.config/networkmanager-dmenu/networkmanager_dmenu"
# HUGO: TODO: need to explore this
alias hug="hugo server -F --bind=10.0.0.210 --baseURL=http://10.0.0.210"
# Rofi
alias rofi-apps="~/.config/rofi/launchers/type-2/launcher.sh"
# lin-util(ChrisTitusTech)
alias linutil="curl -fsSL https://christitus.com/linux | sh"
alias linutil-dev="curl -fsSL https://christitus.com/linuxdev | sh"
# nb notes
alias todos="nb tasks open"
# dictionary
alias dictkonsole="konsole -e dict"
# api cli tool
alias api="posting"
# benchmark app/tool
alias benchm="hyperfine"
# liveserver
alias liveserve="live-server --ignorePattern='.*\\.(js|png|jpg|jpeg|gif|svg|json|md|log)$|node_modules|postcss2|postcss3|src'"

#######################################################
# AUTO ADDS / AUTO GENERATED ---- BY APPS
#######################################################
export PATH=$PATH:"$HOME/.local/bin:$HOME/.cargo/bin"

# Install Starship - curl -sS https://starship.rs/install.sh | sh
eval "$(starship init bash)"

# Use nala
if [ -f "/home/zaman/.use-nala" ]; then
    . "/home/zaman/.use-nala"
fi
if [ -f "$HOME/.use-nala" ]; then
    . "$HOME/.use-nala"
fi

# nvm- node version manager.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Set locale -- tmux to display glyphs in utf8
LANG="en_IN.utf8"
export LANG

# Added by Amplify CLI binary installer
export PATH="$HOME/.amplify/bin:$PATH"

PATH="/home/zaman/perl5/bin${PATH:+:${PATH}}"
export PATH
PERL5LIB="/home/zaman/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
export PERL5LIB
PERL_LOCAL_LIB_ROOT="/home/zaman/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_LOCAL_LIB_ROOT
PERL_MB_OPT="--install_base \"/home/zaman/perl5\""
export PERL_MB_OPT
PERL_MM_OPT="INSTALL_BASE=/home/zaman/perl5"
export PERL_MM_OPT
. "$HOME/.cargo/env"

## fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

## zoxide(instead of autoJump)
eval "$(zoxide init --cmd cd bash)"

## ZVM
export ZVM_INSTALL="$HOME/.zvm/self"
export PATH="$PATH:$HOME/.zvm/bin"
export PATH="$PATH:$ZVM_INSTALL/"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

[[ -s "/home/zaman/.gvm/scripts/gvm" ]] && source "/home/zaman/.gvm/scripts/gvm"

[ -s "${HOME}/.g/env" ] && \. "${HOME}/.g/env" # g shell setup

# Check if the alias 'g' exists before trying to unalias it
if [[ -n $(alias g 2>/dev/null) ]]; then
    unalias g
fi

# opencode
export PATH=/home/zaman/.opencode/bin:$PATH

#asdf
. <(asdf completion bash)

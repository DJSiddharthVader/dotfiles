#!/bin/sh

. $HOME/.cache/wal/colors.sh

cat > ~/.config/zathura/zathurarc << EOM
set recolor "true"
set recolor-darkcolor "$color0"
set recolor-lightcolor "$color1"
set default-bg "$color1"
set default-fg "$color0"

set completion-bg "$color1"
set completion-fg "$color0"
set completion-group-bg "$color1"
set completion-group-fg "$background"
set completion-highlight-bg "$color0"
set completion-highlight-fg "$color1"

set inputbar-bg "$color6"
set inputbar-fg "$color0"
set notification-bg "$color7"
set notification-fg "$color0"
set notification-error-bg "$color8"
set notification-error-fg "$color0"
set notification-warning-bg "$color9"
set notification-warning-fg "$color0"
set statusbar-bg "$color1"
set statusbar-fg "$color0"
set index-bg "$color11"
set index-fg "$color0"
set index-active-bg "$color12"
set index-active-fg "$color0"
set render-loading-bg "$color13"
set render-loading-fg "$color0"

set smooth-scroll true
set window-title-home-tilde true
set statusbar-basename true
set selection-clipboard clipboard
EOM


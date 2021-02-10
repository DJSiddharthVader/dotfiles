#!/bin/sh

. $HOME/.cache/wal/colors.sh

cat > ~/.config/zathura/zathurarc << EOM
set recolor "true"
set recolor-darkcolor "$foreground"
set recolor-lightcolor "$color1"
set default-bg "$color1"
set default-fg "$foreground"

set completion-bg "$color1"
set completion-fg "$foreground"
set completion-group-bg "$color1"
set completion-group-fg "$background"
set completion-highlight-bg "$foreground"
set completion-highlight-fg "$color1"

set inputbar-bg "$color6"
set inputbar-fg "$foreground"
set notification-bg "$color7"
set notification-fg "$foreground"
set notification-error-bg "$color8"
set notification-error-fg "$foreground"
set notification-warning-bg "$color9"
set notification-warning-fg "$foreground"
set statusbar-bg "$color1"
set statusbar-fg "$foreground"
set index-bg "$color11"
set index-fg "$foreground"
set index-active-bg "$color12"
set index-active-fg "$foreground"
set render-loading-bg "$color13"
set render-loading-fg "$foreground"

set smooth-scroll true
set window-title-home-tilde true
set statusbar-basename true
set selection-clipboard clipboard
EOM


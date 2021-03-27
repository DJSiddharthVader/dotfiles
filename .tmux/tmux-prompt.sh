# This tmux statusbar config was created by tmuxline.vim
# on wo, 18 nov 2015

set -g status-justify "left"
set -g status "on"
#set -g message-bg "colour2"
#set -g message-fg "colour0"
#set -g message-command-bg "colour3"
#set -g message-command-fg "colour0"
set -g status-bg "colour2"
#set -g status-attr "none"
#set -g status-right-length "100"
#set -g status-right-attr "none"
#set -g status-left-attr "none"
setw -g window-status-separator ""
set -g status-left ""
set -g status-right ' #{?client_prefix,#[bg=colour3]^A ,}#[fg=colour235,bg=colour5] #H | %m/%d | %H:%M '
setw -g window-status-format "#[fg=colour0,bg=colour2] #I #[fg=colour0,bg=colour2]#W "
setw -g window-status-current-format "#[fg=colour2,bg=colour1,nobold,nounderscore,noitalics]#[fg=colour0,bg=colour1] #W #[fg=colour1,bg=colour2,nobold,nounderscore,noitalics]"

#set -g pane-active-border-fg "colour"
#setw -g window-status-fg "colour0"
#setw -g window-status-attr "none"
#setw -g window-status-activity-bg "colour5"
#setw -g window-status-activity-fg "colour0"
#setw -g window-status-bg "colour6"
#setw -g window-status-activity-attr "none"

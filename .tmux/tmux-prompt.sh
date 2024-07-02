# This tmux statusbar config was created by tmuxline.vim
# on wo, 18 nov 2015

set -g status-justify "left"
set -g status "on"
set -g status-bg "colour2"
setw -g window-status-separator ""
set -g status-left ""
set -g status-right '#[fg=colour5,bg=colour2]#{?client_prefix,#[bg=colour3]^A ,}#[fg=colour235,bg=colour5] %m/%d | %H:%M '
setw -g window-status-format "#[fg=colour0,bg=colour2] #I #[fg=colour0,bg=colour2]#W "
setw -g window-status-current-format "#[fg=colour2,bg=colour1,nobold,nounderscore,noitalics]#[fg=colour0,bg=colour1] #W #[fg=colour1,bg=colour2,nobold,nounderscore,noitalics]"

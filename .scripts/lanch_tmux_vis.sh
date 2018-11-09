#!/bin/sh
tmux new-session -d 'cava'
tmux split-window -v 'pipes'
tmux split-window -h 'cmatrix'
tmux split-window -v 'neofetch'
tmux -2 attach-session -d



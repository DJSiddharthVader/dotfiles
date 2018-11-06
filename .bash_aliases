alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias rs='source ~/.bashrc'
alias ha='pactl set-card-profile 0 output:analog-stereo'
alias shln="ls -la | grep 'Assg/Paper\->'"
alias mtdr="sudo mount /devAssg/Paper/sdb1 /media/1tbdrive/"
alias umnt="umount /media/1tbdrive/"
alias fc-list="fc-list | cut -d':' -f2- | cut -d',' -f1"
alias ifs='ssh -t sid@info.mcmaster.ca ssh sid@info114'

alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'

alias gis='git status'
alias gia='git add'
alias gic='git commit'
alias gip='git push'
alias gid='git diff'

alias bi='vi'
alias mc='mv'
alias top='htop'
alias rm='rm -i'
alias pdf='qpdfview'
alias plx='pdflatex'
alias tmux='tmux -2'
alias cfh="grep -c '^>'"
alias bg='feh --bg-scale'
alias upm='~/.scripts/updatemusic.sh'
alias pipes='~/apps/pipes.sh/pipes.sh'
alias cpdots='rsync -avzP ~/dotfiles/'
alias ncmpcpp='ncmpcpp -b ~/.ncmpcpp/bindings'
alias matlab="/usr/local/MATLAB/R2018a/bin/matlab"
alias reset-wifi='sudo /etc/init.d/network-manager restart'
alias t='python ~/apps/t/t.py --task-dir ~/dotfiles/tasks --list tasks'
alias tl='python ~/apps/t/t.py --task-dir ~/dotfiles/tasks --list tasks | sort -k3'

alias grid='ssh -p 2207 reeds@magarveylab-gw.mcmaster.ca'
alias mserv='ssh reeds@mserv.magarveylab.ca'
alias adc="conda activate adapsyn_conda"
alias ct='conda activate thesis'

alias hoff="~/.scripts/togglescreen.sh hdmi 0"
alias hon="~/.scripts/togglescreen.sh hdmi 1"
alias voff="~/.scripts/togglescreen.sh vga 0"
alias von="~/.scripts/togglescreen.sh vga 1"
alias boff="~/.scripts/togglescreen.sh both 0"
alias bon="~/.scripts/togglescreen.sh both 1"



#ls
alias ls='ls -X --color=auto --group-directories-first'
alias ll='ls -alF --color=auto --group-directories-first'
alias la='ls -A'
alias l='ls -CF'
alias lc='colorls -A --sd'

#Typos
alias r,='rm'
alias e='nvim'
alias bi='nvim'
alias vi='nvim'
alias vim='nvim'
alias mc='mv'

#Options
alias rm='rm -i'
alias tmux='tmux -2'

#Git
alias grm='git rm'
alias gad='git add'
alias glo='git log'
alias gdi='git diff'
alias gph='git push'
alias gpl='git pull'
alias gco='git commit'
alias gbr='git branch'
alias gch='git checkout'
alias gst="git status | grep -v .vim/view | grep -v .varfiles | grep -v .config/qt5ct/colors/pywal.conf | grep -v .gitignore"
alias gsw="watch -n1 'git status | grep -v .vim/view | grep -v .varfiles | grep -v .config/qt5ct/colors/pywal.conf'"

#My Scripts
alias mon='~/.scripts/monitor.sh on'
alias mof='~/.scripts/monitor.sh off'
alias wll='~/.scripts/wallpaper.sh back'
alias upm='~/.scripts/update-music.sh'
alias rspb='~/.scripts/polybar-launch.sh'
alias pipes='~/apps/pipes.sh/pipes.sh'
alias rspa='~/.scripts/reset-pulseaudio.sh'
alias knit='~/.scripts/knit-pdf.sh'

#Apps
alias top='htop'
alias pdf='zathura'
alias tsm="transmission-remote"
alias ncmpcpp='ncmpcpp -b ~/.ncmpcpp/bindings'

#Shorten
alias ..='cd ..'
alias lc='ls | wc -l'
alias rs='source ~/.bashrc'
alias cof='conda deactivate'
alias mnt="~/.scripts/mount.sh on"
alias umt="~/.scripts/mount.sh off"
alias ip="hostname -I | cut -d' ' -f1"
alias brg='ssh slreed@bridges2.psc.edu'
alias school='cd /home/sidreed/CMU_MSCB/Current_Courses/'
alias haud='pactl set-card-profile 0 output:hdmi-stereo'
alias aud='pactl set-card-profile 0 output:analog-stereo'
alias ifs='ssh -t sid@info.mcmaster.ca ssh sid@info114'

#Print
alias cfh="grep -c '^>'"
alias shln="ls -la | grep '\-\>'"
alias fc-list="fc-list | cut -d':' -f2- | cut -d',' -f1"
alias bgal='feh -g 640x480 -d /home/sidreed/Pictures/wallpapers/*'
alias t='python ~/apps/t/t.py --task-dir ~/Personal/notes/tasks --list tasks'
alias tl='python ~/apps/t/t.py --task-dir ~/Personal/notes/tasks --list tasks | sort -k3'


#ls
alias ls='ls -X --color=auto --group-directories-first'
alias ll='ls -alF --color=auto --group-directories-first'
alias la='ls -A'
alias l='ls -CF'
alias lc='colorls -A --sd'

#Navigation
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'

#Typos
alias r,='rm'
alias bi='vi'
alias mc='mv'

#Options
alias top='htop'
alias rm='rm -i'
alias tmux='tmux -2'

#Git
alias grm='git rm'
alias add='git add'
alias log='git log'
alias diff='git diff'
alias push='git push'
alias pull='git pull'
alias com='git commit'
alias brch='git branch'
alias chk='git checkout'
alias statf="git status | less"
alias stat="git status | grep -v .vim/view | grep -v .varfiles | grep -v .config/qt5ct/colors/pywal.conf"
alias stwt="watch -n1 'git status | grep -v .vim/view | grep -v .varfiles | grep -v .config/qt5ct/colors/pywal.conf'"

#My Scripts
alias mon='~/.scripts/monitor.sh on'
alias mof='~/.scripts/monitor.sh off'
alias wll='~/.scripts/wallpaper.sh back'
alias upm='~/.scripts/update-music.sh'
alias rspb='~/.scripts/polybar-launch.sh'
alias pipes='~/apps/pipes.sh/pipes.sh'
alias rspa='~/.scripts/reset-pulseaudio.sh'
alias knit='~/.scripts/knit-pdf.sh'

#Shorten
alias school='cd /home/sidreed/Documents/CMU_MSCB/Courses/'
alias pdf='zathura'
alias bat='acpi -b'
alias plx='pdflatex'
alias lc='ls | wc -l'
alias rs='source ~/.bashrc'
alias cof='conda deactivate'
alias ct='conda activate thesis'
alias fuck='sudo $(history -p \!\!)'
alias jpy='~/anaconda3/bin/jupyter-lab'
alias mnt="~/.scripts/mount.sh on"
alias umt="~/.scripts/mount.sh off"
alias ip="hostname -I | cut -d' ' -f1"
alias saa='~/.scripts/set_album_art.sh'
alias cwp='~/.scripts/currentwallpaper.sh'
alias ncmpcpp='ncmpcpp -b ~/.ncmpcpp/bindings'
alias haud='pactl set-card-profile 0 output:hdmi-stereo'
alias aud='pactl set-card-profile 0 output:analog-stereo'
alias reset-wifi='sudo /etc/init.d/network-manager restart'
alias mkst='cd ~/apps/st/; sudo make clean; make; sudo make install'
alias ifs='ssh -t sid@info.mcmaster.ca ssh sid@info114'
alias psync="rsync -e 'ssh -p 2222' -rP --ignore-existing --human-readable --info=progress2"

#Print
alias cfh="grep -c '^>'"
alias shln="ls -la | grep '\-\>'"
alias fc-list="fc-list | cut -d':' -f2- | cut -d',' -f1"
alias bgal='feh -g 640x480 -d /home/sidreed/Pictures/wallpapers/*'
alias t='python ~/apps/t/t.py --task-dir ~/Personal/notes/tasks --list tasks'
alias tl='python ~/apps/t/t.py --task-dir ~/Personal/notes/tasks --list tasks | sort -k3'
alias neofetch='neofetch --ascii /home/sidreed/dotfiles/.config/neofetch/my_apreature.txt --config /home/sidreed/dotfiles/.config/neofetch/config'


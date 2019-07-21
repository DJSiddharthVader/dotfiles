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
alias stat="git status | less"
alias stwt="watch -n1 'git status'"

#Typos
alias r,='rm'
alias bi='vi'
alias mc='mv'

#Options
alias top='htop'
alias rm='rm -i'
alias tmux='tmux -2'

#My Scripts
alias mon='~/.scripts/monitor.sh on'
alias mof='~/.scripts/monitor.sh off'
alias wll='~/.scripts/wallpaper.sh back'
alias upm='~/.scripts/updatemusic.sh'
alias rspb='~/.scripts/polybar_launch.sh'
alias pipes='~/apps/pipes.sh/pipes.sh'
alias rspa='~/.scripts/reset-pulseaudio.sh'
alias knit='~/.scripts/knitpdf.sh'

#Shorten
alias pdf='zathura'
alias bat='acpi -b'
alias plx='pdflatex'
alias lc='ls | wc -l'
alias rs='source ~/.bashrc'
alias cof='conda deactivate'
alias ct='conda activate thesis'
alias umnt="umount /media/1tbdrive/"
alias cpdots='rsync -avzP ~/dotfiles/'
alias ip="hostname -I | cut -d' ' -f1"
alias saa='~/.scripts/set_album_art.sh'
alias jpy='~/anaconda3/bin/jupyter-lab'
alias kodos='ssh -x sreed@sshgw.uhnresearch.ca'
alias slack='/home/sidreed/apps/sclack/app.py'
alias ncmpcpp='ncmpcpp -b ~/.ncmpcpp/bindings'
alias mtdr="sudo mount /dev/sdb1 /media/1tbdrive/"
alias ifs='ssh -t sid@info.mcmaster.ca ssh sid@info114'
alias haud='pactl set-card-profile 0 output:hdmi-stereo'
alias aud='pactl set-card-profile 0 output:analog-stereo'
alias reset-wifi='sudo /etc/init.d/network-manager restart'
alias uhn='ssh -t sreed@sshgw.uhnresearch.ca ssh mhoffman10'
alias bbf='feh --bg-scale ~/.config/i3/bordered_background.png'
alias ubf='feh --bg-scale ~/.config/i3/unbordered_background.png'
alias mkst='cd ~/apps/st/; sudo make clean; make; sudo make install'
alias thesis='tmuxinator start thesis -n thesis -p ~/dotfiles/.tmuxinator/thesis.yml'
alias vpn='/opt/cisco/anyconnect/bin/vpn'
alias vpnui='/opt/cisco/anyconnect/bin/vpnui'

#Print
alias cfh="grep -c '^>'"
alias shln="ls -la | grep '\-\>'"
alias fc-list="fc-list | cut -d':' -f2- | cut -d',' -f1"
alias bgal='feh -g 640x480 -d /home/sidreed/Pictures/wallpapers/*'
alias t='python ~/apps/t/t.py --task-dir ~/dotfiles/tasks --list tasks'
alias tl='python ~/apps/t/t.py --task-dir ~/dotfiles/tasks --list tasks | sort -k3'
alias neofetch='neofetch --ascii /home/sidreed/dotfiles/.config/neofetch/my_apreature.txt --config /home/sidreed/dotfiles/.config/neofetch/config'


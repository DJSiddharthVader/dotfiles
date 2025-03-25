#!/usr/bin/env bash
# vim: fdm=marker:noai:ts=4:sw=4
## Setting Variables {{{
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true || _islinux=false
[[ -f /etc/arch-release ]] && _isarch=true || _isarch=false
[[ -n "$DISPLAY" ]] && _isxrunning=true || _isxrunning=false
[[ $UID -eq 0 ]] && _isroot=true || _isroot=false
# set vim readline bindings but keep regular C-l binding
set -o vi
bind "\C-l":clear-screen
bind "\C-e":end-of-line
bind "\C-k":kill-line
# }}}
## Linux TTY colors {{{
if [ "$TERM" = "linux" ]; then
    _sedcmd='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    for i in $(sed -n "$_sedcmd" $HOME/.Xdefaults | \
        awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
    echo -en "$i"; done
    clear
fi
## Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
(cat ~/.cache/wal/sequences &)
# }}}
## Exports {{{
export TERM='screen-256color'
export TERMINAL='st'
export EDITOR="nvim"
export VISUAL='nvim'
export STEAM_RUNTIME=1
# Default browser
BROWSER="firefox"
# MPD variables
export MPD_PORT=6600
export MPD_HOST=localhost
# SSH Askpass
unset SSH_ASKPASS
# Wrap output of journal
export SYSTEMD_LESS=FRXMK journalctl
# XFT fonts
export GDK_USE_XFT=1
# JAVA look and feel
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
# QT5 style
# export QT_QPA_PLATFORMTHEME=gtk2
export QT_QPA_PLATFORMTHEME=qt5ct
#export QT_STYLE_OVERRIDE=GTK+
# Python,VIM and UTF-8
export PYTHONIOENCODING=utf-8
# Ranger
export RANGER_LOAD_DEFAULT_RC=FALSE
# }}}
## BASH Options {{{
shopt -s cdspell                 # Correct cd typos
shopt -s checkwinsize            # Update windows size on command
shopt -s histappend              # Append History instead of overwriting
shopt -s cmdhist                 # Save multi-line commands as one
shopt -s extglob                 # Extended pattern
shopt -s no_empty_cmd_completion # No empty completion
# Prevent file overwrite on stdout redirection
# Use `>|` to force redirection to an existing file
set -o noclobber
# }}}
## History {{{
# make multiple shells share the same history file
export HISTTIMEFORMAT="%m/%d - %H:%M:%S: "
export HISTSIZE=500000 # bash history will save N commands
export HISTFILESIZE=100000 # bash will remember N commands
export HISTCONTROL="erasedups:ignoreboth" # ingore duplicates and spaces
export HISTIGNORE='&:[ ]*:bg:fg:ls:ll:la:cd:exit:x:clear:c:history:h' # Don't record some commands
HISTTIMEFORMAT='%D %a %T  ' # Useful timestamp format
# Enable incremental history search with up/down arrows
# Learn more about this here: http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'
# }}}
## Colored MAN Pages {{{
# @see http://www.tuxarena.com/?p=508
# For colourful man pages (CLUG-Wiki style)
if $_isxrunning; then
    export PAGER=less
    export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
    export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
    export LESS_TERMCAP_me=$'\E[0m'           # end mode
    export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
    export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
    export LESS_TERMCAP_ue=$'\E[0m'           # end underline
    export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
fi
# }}}
## Completion {{{
complete -cf sudo
[[ -f /etc/bash_completion ]] && . /etc/bash_completion
# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"
# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"
shopt -s cdable_vars 
export xdp="/home/sidreed/TalkowskiLab/Projects/XDP"
export scb="/home/sidreed/TalkowskiLab/Projects/NeuralBenchmarking"
# }}}
## Better directory navigation {{{
# Enter and list directory
function cd() { builtin cd -- "$@" && { [ "$PS1" = "" ] || ls -hrt --color; }; }
# Prepend cd to directory names automatically
#shopt -s autocd 2> /dev/null
# Correct spelling errors during tab-completion
shopt -s dirspell
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null
shopt -s cdable_vars
export hic="$HOME/TalkowskiLab/Projects/HiC"
export scb="$HOME/TalkowskiLab/Projects/NeuralBenchmarking"
export docs="$HOME/Documents"
export walls="$HOME/Pictures/wallpapers"
export dwns="$HOME/Downloads"
# }}}
## Aliases {{{
[ -f $HOME/.bash/bash-aliases ] && source $HOME/.bash/bash-aliases
# }}}
## Functions {{{
[ -f $HOME/.bash/bash-functions.sh ] && source $HOME/.bash/bash-functions.sh
# }}}
## Prompt {{{
[ -f $HOME/.bash/bash-prompt.sh ] && source $HOME/.bash/bash-prompt.sh
export  LS_COLORS="$(dircolors -b $HOME/.bash/dircolors_256 | head -1 | sed -n "s/^LS_COLORS='//p" | sed -n "s/:';$//p")"
# }}}
## fzf {{{
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# }}}
## Systemd Support {{{
if which systemctl &>/dev/null; then
    start() {
        sudo systemctl start $1.service
    }
    restart() {
        sudo systemctl restart $1.service
    }
    stop() {
        sudo systemctl stop $1.service
    }
    enable() {
        sudo systemctl enable $1.service
    }
    enable_now() {
        sudo systemctl enable --now $1.service
    }
    status() {
        sudo systemctl status $1.service
    }
    status_long() {
        sudo systemctl status -l $1.service
    }
    disable() {
        sudo systemctl disable $1.service
    }
    disable_now() {
        sudo systemctl disable --now $1.service
    }
    mask() {
        sudo systemctl mask $1.service
    }
    unmask() {
        sudo systemctl unmask $1.service
    }
    reload() {
        sudo systemctl daemon-reload
    }
fi
# }}}
## Set PATH {{{
# export GOPATH="$HOME/CMU_MSCB/Courses/Programming-02601/:$HOME/Projects/musman/:$HOME/Projects/go/src"
#PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
#PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
#PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
#PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;
#export PATH="$HOME/perl5/bin${PATH:+:${PATH}}"
#export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/.scripts:$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
# remove duplicate path entries
PATH="$(echo $PATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')"
# }}}
# Print a random quote on new terminal launch
~/.scripts/quote.sh
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/sidreed/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/sidreed/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/sidreed/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/sidreed/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


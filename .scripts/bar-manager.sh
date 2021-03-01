#!/bin/bash
shopt -s extglob

bgfile="$HOME/dotfiles/.varfiles/bordered_background.png"
unbgfile="$HOME/dotfiles/.varfiles/unbordered_background.png"

mode_file="$HOME/dotfiles/.varfiles/barmode"
modes=(float full mini none)

icon_file="$HOME/dotfiles/.varfiles/polysep"
icons=(arrow_sym trig_left trig_right circle arrow_tail trig_out trig_in arrow_curve)
icon_sets=(       )
#icons in order for module sepration
#symetric    ; ; ; ; ; ;
#directional ;  ;  ; ; ;【】

help() {
    name=$1[@]
    arr=("${!name}")
    echo "Error: usage ./$(basename $0) {style|sep|reload|restart} {stay|next|prev$(echo '|'${arr[*]} | tr ' ' '|')}"
}
cycle() {
    # cycle through modes either forwards or backwards
    # get index of current mode in the modes array, find index for next/previous mode and get the array value of that index and echo it
    # next mode index is:  (x+1) % n
    # prev mode index is:  (x+n-1) % n
    # x is current mode index, n is number of modes
    dir="$1"
    name=$2[@]
    arr=("${!name}")
    mode="$(cat $3)"
    idx="$(echo "${arr[*]}" | grep -o "^.*$mode" | tr ' ' '\n' | wc -l)"
    idx=$(($idx -1)) #current mode idx
    case "$dir" in
         'next') idx=$(($idx + 1)) ;;
         'prev') idx=$(($idx +${#arr[@]} -1)) ;;
         *) echo "Error cycle takes {next|prev}" && exit 1 ;;
    esac
    next_idx=$(($idx % ${#arr[@]})) #modulo to wrap back
    echo "${arr[$next_idx]}"
}
wallpaper() {
    case $1 in
        float|mini|none) feh --bg-scale "$unbgfile" ;;
        full) feh --bg-scale "$bgfile" ;;
        *) help 'style' && echo 'wall' && exit 1 ;;
    esac
}
separators() {
    mode="$1"
    tmp="@($(echo ${icons[*]} | sed -e 's/ /|/g'))"
    case "$mode" in
        'stay') dmode="$(head -1 $icon_file)" ;;
        'next') dmode="$(cycle 'next' icons $icon_file)" ;;
        'prev') dmode="$(cycle 'prev' icons $icon_file)" ;;
         $tmp ) dmode="$mode" ;; #capture any valid mode
        *) echo "failed: $mode" && help sep && exit 1 ;;
    esac
    idx="$(echo "${icons[*]}" | grep -o "^.*$dmode" | tr ' ' '\n' | wc -l | sed -s 's/$/-1/' | bc)"
    #idx=$(($idx -1)) #current mode idx
    icon_set="${icon_sets[$idx]}"
    echo -e "$mode\n$dmode\n$idx\n$icon_set"
    echo "$dmode
; icons to delimit polybar modules
leftprefix =  ${icon_set:0:1}
leftsuffix =  ${icon_set:1:1}
rightprefix = ${icon_set:2:1}
rightsuffix = ${icon_set:3:1}
" >| "$icon_file"
}
launch() {
    mode="$1"
    tmp="@($(echo ${modes[*]} | sed -e 's/ /|/g'))"
    case "$mode" in
        'stay') dmode="$(cat $mode_file)" ;;
        'next') dmode="$(cycle 'next' modes $mode_file)" ;;
        'prev') dmode="$(cycle 'prev' modes $mode_file)" ;;
         $tmp ) dmode="$mode" ;; #capture any valid mode
        *) echo "failed: $mode" && help style && exit 1 ;;
    esac
    echo "$dmode"  >| "$mode_file"
    wallpaper "$dmode"
    killall -q polybar && sleep 0.00001 # Terminate already running bar instances
    for m in $(xrandr | grep ' connected' | cut -d' ' -f1); do
        case "$dmode" in
            'float')
                MONITOR=$m polybar floating_top &
                MONITOR=$m polybar floating_bot &
                ;;
            'full' )
                MONITOR=$m polybar bordered_top &
                MONITOR=$m polybar bordered_bot &
                ;;
            'mini' ) MONITOR=$m polybar minimal & ;;
            'none' ) sleep 1 ;;
            *) help && echo 'launch' && exit 1 ;;
        esac
    done
}
main() {
    mode="$1"
    change="$2"
    echo "$mode $change"
    case $mode in
        'sep'    ) separators "$change"; launch 'stay' ;;
        'style'  ) launch "$change" ;;
        'reload' ) ! [[ -z "$(pgrep 'polybar')" ]] && polybar-msg cmd restart ;;
        'restart') separators "$(head -1 $icon_file)"; launch "$(cat $mode_file)" ;;
        *) echo "failed: $mode" && help $mode && exit 1 ;;
    esac
}

main "$@"

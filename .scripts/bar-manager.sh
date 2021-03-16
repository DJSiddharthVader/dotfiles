#!/bin/bash
shopt -s extglob

bgfile="$HOME/dotfiles/.varfiles/bordered_background.png"
unbgfile="$HOME/dotfiles/.varfiles/unbordered_background.png"
mode_file="$HOME/dotfiles/.varfiles/barmode"
modes=(float full mini none)

#Icons
icon_file="$HOME/dotfiles/.varfiles/polysep"
dl="." #arbitrary but might as well be a variable, allows for spaces in the icon sets
icons=(arrow_tail arrow_sym trig_in trig_out big_fade_in big_fade small_fade circle)
icon_sets=("$dl$dl$dl" "$dl$dl$dl" "$dl$dl$dl" "$dl$dl$dl" "$dl$dl$dl" "$dl$dl$dl" "$dl$dl$dl" "$dl $dl $dl ")
#symetric    ; ; ; ; ; ;
#directional ;  ;  ; ; ;【】

help() {
    icontable="Name,|,Icons\n ,|, "
    for ((i=0; i<${#icons[@]}; i++)); do
        line="$(echo "${icons[$i]},|,${icon_sets[$i]}" | tr -d "$dl" )"
        icontable="$icontable\n$line"
    done
    icontable="$(echo -e $icontable | column -s ',' -t)"
    echo "Usage $(basename $0) {style|sep|reload|restart}
                      style {stay|next|prev$(echo '|'${modes[*]} | tr ' ' '|')}
                      sep   {stay|next|prev$(echo '|'${icons[*]} | tr ' ' '|')}
$icontable"
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
        *) help && exit 1 ;;
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
        *) help && exit 1 ;;
    esac
    idx="$(echo "${icons[*]}" | grep -o "^.*$dmode" | tr ' ' '\n' | wc -l | sed -s 's/$/-1/' | bc)"
    #idx=$(($idx -1)) #current mode idx
    icon_set="${icon_sets[$idx]}"
    #echo -e "$mode\n$dmode\n$idx\n$icon_set"
    echo "$dmode
; icons to delimit polybar modules
leftprefix =  \"$(echo $icon_set | cut -d"$dl" -f1)\"
leftsuffix =  \"$(echo $icon_set | cut -d"$dl" -f2)\"
rightprefix = \"$(echo $icon_set | cut -d"$dl" -f3)\"
rightsuffix = \"$(echo $icon_set | cut -d"$dl" -f4)\"
" | sed -e 's/""//' >| "$icon_file"
}
launch() {
    mode="$1"
    tmp="@($(echo ${modes[*]} | sed -e 's/ /|/g'))"
    case "$mode" in
        'stay') dmode="$(cat $mode_file)" ;;
        'next') dmode="$(cycle 'next' modes $mode_file)" ;;
        'prev') dmode="$(cycle 'prev' modes $mode_file)" ;;
         $tmp ) dmode="$mode" ;; #capture any valid mode
        *) help style && exit 1 ;;
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
            *) help && exit 1 ;;
        esac
    done
}
main() {
    mode="$1"
    change="$2"
    case $mode in
        'sep'    ) separators "$change"; launch 'stay' ;;
        'style'  ) launch "$change" ;;
        'reload' ) ! [[ -z "$(pgrep 'polybar')" ]] && polybar-msg cmd restart ;;
        'restart') separators "$(head -1 $icon_file)"; launch "$(cat $mode_file)" ;;
        *) help && exit 1 ;;
    esac
}

main "$@"

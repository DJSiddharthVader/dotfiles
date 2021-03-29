#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
modes=(mini textual float cross full none)

#Icons
icon_file="$HOME/dotfiles/.config/polybar/separators.mode"
dl="." #arbitrary but might as well be a variable, allows for spaces in the icon sets
icons=(arrow_tail arrow_sym trig_in trig_out big_fade_in circle)
icon_sets=("$dl$dl$dl" "$dl$dl$dl" "$dl$dl$dl" "$dl$dl$dl" "$dl$dl$dl" " $dl$dl$dl ")
# small_fade "$dl$dl$dl"
# big_fade "$dl$dl$dl"
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
    mode="$(getMode $3)"
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
getMode() {
    if [ "$1" = 'style' ]; then
        grep '^bar:' "$mode_file" | cut -d':' -f2
    else
        grep '^separator:' "$mode_file" | cut -d':' -f2
    fi
}
setMode() {
    if [ "$1" = 'style' ]; then
        sed -i "/^bar:/s/:.*/:$2/" "$mode_file"
    else
        sed -i "/^separator:/s/:.*/:$2/" "$mode_file"
    fi
}

separators() {
    mode="$1"
    tmp="@($(echo ${icons[*]} | sed -e 's/ /|/g'))"
    case "$mode" in
        'stay') dmode="$(setMode 'separator')" ;;
        'next') dmode="$(cycle 'next' icons 'separator')" ;;
        'prev') dmode="$(cycle 'prev' icons 'separator')" ;;
         $tmp ) dmode="$mode" ;; #capture any valid mode
        *) help && exit 1 ;;
    esac
    idx="$(echo "${icons[*]}" | grep -o "^.*$dmode" | tr ' ' '\n' | wc -l | sed -s 's/$/-1/' | bc)"
    icon_set="${icon_sets[$idx]}"
    setMode 'separator' "$dmode"
    echo "$dmode
; icons to delimit polybar modules
leftprefix = \"$(echo $icon_set | cut -d"$dl" -f1)\"
leftsuffix = \"$(echo $icon_set | cut -d"$dl" -f2)\"
rightprefix = \"$(echo $icon_set | cut -d"$dl" -f3)\"
rightsuffix = \"$(echo $icon_set | cut -d"$dl" -f4)\"
" | sed -e 's/""//' >| "$icon_file"
}
getMonitors() {
    xrandr | sed -n '/ primary/,$p' | grep ' connected' | cut -d' ' -f1
}
launchOnAllMonitors() {
    for barname in "$@"; do
        for m in $(getMonitors); do
            MONITOR=$m polybar "$barname" &
        done
    done
}
launch() {
    mode="$1"
    tmp="@($(echo ${modes[*]} | sed -e 's/ /|/g'))"
    case "$mode" in
        'stay') dmode="$(getMode 'style')" ;;
        'next') dmode="$(cycle 'next' modes 'style')" ;;
        'prev') dmode="$(cycle 'prev' modes 'style')" ;;
         $tmp ) dmode="$mode" ;; #capture any valid mode
        *) help style && exit 1 ;;
    esac
    setMode 'style' "$dmode"
    killall -q polybar && sleep 0.00001 # Terminate already running bar instances
    case "$dmode" in
        'float'  ) launchOnAllMonitors floating-top floating-bottom ;;
        'full'   ) launchOnAllMonitors full-top full-bottom ;;
        'textual') launchOnAllMonitors textual-top textual-bottom ;;
        'cross'  )
            monitors=$(getMonitors)
            MONITOR="$(echo $monitors | cut -d' ' -f1)" polybar cross-left &
            MONITOR="$(echo $monitors | cut -d' ' -f2)" polybar cross-right &
            ;;
        'mini'   ) launchOnAllMonitors minimal ;;
        'none'   ) sleep 1 ;;
        *) help && exit 1 ;;
    esac
}

main() {
    mode="$1"
    change="$2"
    case $mode in
        'sep'    ) separators "$change"; launch 'stay' ;;
        'style'  ) launch "$change" ;;
        'reload' ) ! [[ -z "$(pgrep 'polybar')" ]] && polybar-msg cmd restart ;;
        'restart') separators "$(getMode 'separator')"; launch "$(getMode 'style')" ;;
        *) help && exit 1 ;;
    esac
}

main "$@"

#!/bin/bash
shopt -s extglob

# Styles
script_dir="$HOME/dotfiles/.config/polybar/scripts"
mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
styles=(laptop float standard text cross full mini none)
# Separators
dl="."
separator_file="$HOME/dotfiles/.config/polybar/separators.mode"
separator_names=(arrow_tail
                 tail_sym
                 arrow_sym
                 trig_in
                 trig_out
                 circle
                 circle_tail
                 small_fade
                 small_fade_in
                 big_fade
                 big_fade_in )
separator_icons=("$dl$dl$dl"
                 "$dl$dl$dl"
                 "$dl$dl$dl"
                 "$dl$dl$dl"
                 "$dl$dl$dl"
                 " $dl$dl$dl "
                 "$dl$dl$dl"
                 "$dl$dl$dl"
                 "$dl$dl$dl"
                 "$dl$dl$dl"
                 "$dl$dl$dl")

makeSeparatorTable() {
    separator_table="Name,|,Separators"
    for ((i=0; i<${#separator_names[@]}; i++)); do
        line="$(echo "${separator_names[$i]},|,${separator_icons[$i]} " | tr "$dl" ' ')"
        separator_table="$separator_table\n$line"
    done
    echo -e $separator_table | column -s ',' -t
}
help() {
    separator_table="$(makeSeparatorTable)"
    echo "Usage $(basename $0) {style|sep|reload|restart|pick}
                      menu {style|sep}
                      style {stay|next|prev} or {$(echo ${styles[*]} | tr ' ' '|')}
                      sep   {stay|next|prev} or {$(echo ${separator_names[*]} | tr ' ' '|')}
                      "
    echo "$separator_table" | pr -T -o 22
}

cycle() {
    # cycle through array elements either forwards or backwards
    # get index of current element in the array, find index for next/previous element and get the array value of that index and echo it
    # next element index is:  (x+1) % n
    # prev element index is:  (x+n-1) % n
    # x is current mode index, n is number of elements
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
    tmp="@($(echo ${separator_names[*]} | sed -e 's/ /|/g'))"
    case "$mode" in
        'stay') dmode="$(setMode 'separator')" ;;
        'next') dmode="$(cycle 'next' separator_names 'separator')" ;;
        'prev') dmode="$(cycle 'prev' separator_names 'separator')" ;;
         $tmp ) dmode="$mode" ;; #capture any valid mode
        *) echo "Error: Invalid separator" && help && exit 1 ;;
    esac
    idx="$(echo ${separator_names[@]/$dmode//} | cut -d/ -f1 | wc -w | tr -d ' ')"
    icons="${separator_icons[$idx]}"
    setMode 'separator' "$dmode"
    echo "$dmode
; icons to delimit polybar modules
leftprefix = \"$(echo "$icons" | cut -d"$dl" -f1)\"
leftsuffix = \"$(echo "$icons" | cut -d"$dl" -f2)\"
rightprefix = \"$(echo "$icons" | cut -d"$dl" -f3)\"
rightsuffix = \"$(echo "$icons" | cut -d"$dl" -f4)\"
" | sed -e 's/""//' >| "$separator_file"
}
getMonitors() {
    xrandr | sed -n '/ primary/,$p' | grep ' connected' | cut -d' ' -f1
}
launchOnAllMonitors() {
    for m in $(getMonitors); do
        if [[ $m = 'eDP-1' ]]; then
            MONITOR=$m polybar laptop-top &
            MONITOR=$m polybar laptop-bottom &
        else
            for barname in "$@"; do
                MONITOR=$m polybar "$barname" &
            done
        fi
    done
}
launch() {
    mode="$1"
    tmp="@($(echo ${styles[*]} | sed -e 's/ /|/g'))"
    case "$mode" in
        'stay') dmode="$(getMode 'style')" ;;
        'next') dmode="$(cycle 'next' styles 'style')" ;;
        'prev') dmode="$(cycle 'prev' styles 'style')" ;;
         $tmp ) dmode="$mode" ;; #capture any valid mode passed
        *) echo "Error: Invalid style" && help && exit 1 ;;
    esac
    setMode 'style' "$dmode" # set defualt polybar style
    killall -q polybar && sleep 0.001 # Terminate already running bar instances
    case "$dmode" in
        laptop  ) launchOnAllMonitors laptop-top laptop-bottom ;;
        float   ) launchOnAllMonitors floating-top floating-bottom ;;
        standard) launchOnAllMonitors standard-top standard-bottom ;;
        text    ) launchOnAllMonitors text-top text-bottom ;;
        full    ) launchOnAllMonitors full-top full-bottom ;;
        mini    ) launchOnAllMonitors minimal ;;
        none    ) sleep 1 ;;
        cross   )
            monitor=$(getMonitors | tail -2)
            m1="$(echo $monitor | cut -d' ' -f1)"
            m2="$(echo $monitor | cut -d' ' -f2)"
            MONITOR="$m1" polybar cross-left &
            MONITOR="$m2" polybar cross-right &
            ;;
        *) echo "Error: Invalid style" && help && exit 1 ;;
    esac
    case "$dmode" in
        standard|text) $script_dir/current-window.sh thresh 80 ;;
        *) $script_dir/current-window.sh thresh 40 ;;
    esac
}
rofiMenu() {
    mode="$1"
    if [[ $mode = 'style' ]]; then
        style="$(printf '%s\n' ${styles[@]} | rofi -m -1 -width 15 -lines ${#styles[@]} -dmenu -p 'Pick Polybar Style')"
        [[ -n $style ]] && launch $style
    elif [[ $mode = 'sep' ]]; then
        #separator="$(printf '%s\n' ${separator_names[@]} | rofi -m -1 -width 15 -lines ${#separator_names[@]} -dmenu -p 'Pick Polybar Separator')"
        separator="$(makeSeparatorTable | tail -n+2 | rofi -m -1 -width 20 -lines ${#separator_names[@]} -dmenu -p 'Pick Polybar Separator')"
        [[ -n $separator ]] && separators $separator && launch 'stay'
    fi
}
main() {
    mode="$1"
    option="$2"
    if [[ $mode = 'menu' ]]; then
        rofiMenu $option
    else
        case $mode in
            'sep'    ) separators "$option"; launch 'stay' ;;
            'style'  ) launch "$option" ;;
            'reload' ) ! [[ -z "$(pgrep 'polybar')" ]] && polybar-msg cmd restart ;;
            'restart') separators "$(getMode 'separator')"; launch "$(getMode 'style')" ;;
            *) help && exit 1 ;;
        esac
    fi
}

main "$@"

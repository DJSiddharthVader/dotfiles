#!/bin/bash
shopt -s extglob

# Styles
script_dir="$HOME/dotfiles/.config/polybar/scripts"
mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
styles=(float standard text cross press full mini laptop)
compact_bars=(laptop mini)
res_limit=1400
primary_screen="eDP-1"
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
    echo "Usage $(basename $0) CMD OPT
                      menu  {style|sep}
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
getConnectedMonitors() {
    xrandr |  grep ' connected' | sort -r | cut -d' ' -f1
}
getActiveMonitors() {
   # same as get all monitors but excludes eDP-1
    xrandr --listmonitors | tail -n+2 | rev | cut -d' ' -f1 | rev | sort -r
}
getResolution() {
    monitor="$1"
    xrandr | sed -ne "/$monitor/,/connected/p" | sort -n | tail -1 | grep -ao '[0-9]*x[0-9_\.]*'
}
launchBar() {
    bartype="$1"
    m="$2" # monitor
    res="$(getResolution $m | cut -d'x' -f1)"
    if [[ $bartype = "mini" ]]; then
        MONITOR=$m polybar mini &
    elif [[ $res -lt $res_limit ]]; then
        # if resolution is too low use trimmed bar
        tmp="@($(echo ${compact_bars[*]} | sed -e 's/ /|/g'))"
        case $bartype in
            $tmp) #already compact bartype
                MONITOR=$m polybar "$bartype"-top &
                MONITOR=$m polybar "$bartype"-bottom &
                ;;
               *)
                MONITOR=$m polybar compact-"$bartype"-top &
                MONITOR=$m polybar compact-"$bartype"-bottom &
                ;;
        esac
    else
        if [[ $m = $primary_screen ]]; then
            MONITOR=$m polybar laptop-top &
            MONITOR=$m polybar laptop-bottom &
        else
            MONITOR=$m polybar "$bartype"-top &
            MONITOR=$m polybar "$bartype"-bottom &
        fi
    fi
}
launchAllBars() {
    mode="$1"
    # cycle modes
    tmp="@($(echo "${styles[*]}" | sed -e 's/ /|/g'))"
    case "$mode" in
        'stay') dmode="$(getMode 'style')" ;;
        'next') dmode="$(cycle 'next' styles 'style')" ;;
        'prev') dmode="$(cycle 'prev' styles 'style')" ;;
         $tmp ) dmode="$mode" ;; #capture any valid mode passed
         none) dmode="none" ;; 
        *) echo "Error: Invalid style" && help && exit 1 ;;
    esac
    setMode 'style' "$dmode" # set defualt polybar style
    # launch bars
    killall -q polybar && sleep 0.001 # Terminate already running bar instances
    case "$dmode" in
        none) sleep 1 ;;
        cross)
            monitors=$(getActiveMonitors)
            echo "$monitors"
            m1="$(echo $monitors | cut -d' ' -f1)"
            m2="$(echo $monitors | cut -d' ' -f2)"
            MONITOR="$m1" polybar cross-left &
            MONITOR="$m2" polybar cross-right &
            for m in $(echo $monitors | cut -d' ' -f3-); do
                launchBar float $m
            done
            ;;
        $tmp)
            for m in $(getActiveMonitors); do
                launchBar $dmode $m
            done
            ;;
        press) launchBar float $primary_screen ;; #only put bar on laptop
        *) echo "Error: Invalid style" && help && exit 1 ;;
    esac
    # change size of some module depending on the bartype
    case "$dmode" in
        standard|text) $script_dir/current-window.sh thresh 80 ;;
        *) $script_dir/current-window.sh thresh 40 ;;
    esac
}
rofiMenu() {
    mode="$1"
    if [[ $mode = 'style' ]]; then
        styles+=("none")
        style="$(printf '%s\n' ${styles[@]} | rofi -m -1 -width 20 -lines ${#styles[@]} -dmenu -p 'Pick Polybar Style')"
        [[ -n $style ]] && launchAllBars $style
    elif [[ $mode = 'sep' ]]; then
        #separator="$(printf '%s\n' ${separator_names[@]} | rofi -m -1 -width 15 -lines ${#separator_names[@]} -dmenu -p 'Pick Polybar Separator')"
        separator="$(makeSeparatorTable | tail -n+2 | rofi -m -1 -width 25 -lines ${#separator_names[@]} -dmenu -p 'Pick Polybar Separator')"
        [[ -n $separator ]] && separators $separator && launchAllBars 'stay'
    fi
}
main() {
    mode="$1"
    option="$2"
    if [[ $mode = 'menu' ]]; then
        rofiMenu $option
    else
        case $mode in
            'sep'    ) separators "$option"; launchAllBars 'stay' ;;
            'style'  ) launchAllBars "$option" ;;
            'reload' ) ! [[ -z "$(pgrep 'polybar')" ]] && polybar-msg cmd restart ;;
            'restart') separators "$(getMode 'separator')"; launchAllBars "$(getMode 'style')" ;;
            *) help && exit 1 ;;
        esac
    fi
}

main "$@"

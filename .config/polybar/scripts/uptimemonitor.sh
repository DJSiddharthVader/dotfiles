#!/bin/bash

mode_file="$HOME/dotfiles/.varfiles/upmode"
modes=(short med long)

function getTime() {
    timeperiod="$1"
    pattern="[0-9]\{1,\}$timeperiod"
    #time=$(uptime -p | sed -re 's/ //g' | grep -Po "$pattern" | sed -re "s/[^0-9]//" )
    if [[ "$(uptime -p)" =~ "$timeperiod" ]]; then
        time=$(uptime -p | sed -rE "s/(^.*)( [0-9]{1,} $timeperiod).*$/\2/" | sed -re 's/[^0-9]//g')
        if [[ $time =~ [^0-9]+ ]]; then
            echo 0
        elif [[ $time =~ [0-9]{4} ]]; then
            echo 0
        else
            echo $time
        fi
    else
        echo 0
    fi
}
function display() {
    mode="$1"
    weeks=$(getTime 'week')
    days=$(getTime 'day')
    hours=$(getTime 'hour')
    minutes=$(getTime 'minute')
    case $mode in
        'short')
            total=$(($weeks*7*24 + $days*24 + $hours))
            uptime="H:$total"
            ;;
        'med')
            days=$((7*$weeks + $days))
            uptime="D:$days H:$hours"
            ;;
        'long')
            uptime="W:$weeks D:$days H:$hours M:$minutes"
            ;;
        *)
            echo "Usage $0 {short|med|long}"
            exit 1
            ;;
    esac
    echo "$uptime "
}
function cycleMode() {
    printf '%s ' "${modes[${i:=0}]}"
    ((i=i>=${#modes[@]}-1?0:++i))
}
function main() {
    mode="$1"
    case $mode in
        'short')
            echo 'short' >| $mode_file
            ;;
        'med')
            echo 'med' >| $mode_file
            ;;
        'long')
            echo 'long' >| $mode_file
            ;;
        'toggle')
            mode="$(cat $mode_file)"
            case $mode in
                'short')
                    echo 'med' >| $mode_file
                    ;;
                'med')
                    echo 'long' >| $mode_file
                    ;;
                'long')
                    echo 'short' >| $mode_file
                    ;;
            esac
            ;;
        '')
            sleep 0.001
            ;;
        *)
            echo "Usage $0 {toggle|short|med|long}"
            exit 1
            ;;
    esac
    mode="$(cat $mode_file)"
    display $mode
}

main "$1"

#DEPRECIATED
#    uptime --pretty | \
#          sed 's/^up //' | \
#          sed -E 's/[, ]//g' | \
#          sed -E 's/([0-9]*)week[s]*/W:\1 /' | \
#          sed -E 's/([0-9]*)day[s]*/D:\1 /' | \
#          sed -E 's/([0-9]*)hour[s]*/H:\1 /' | \
#          sed -E 's/([0-9]*)minute[s]*/M:\1/'
          #sed -E 's/([0-9]*)minute[s]*//'


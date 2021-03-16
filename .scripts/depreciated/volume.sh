#/bin/bash
#too slow in polybar but works as a wrapper for simple stuff

#Icons
ramp0=""
ramp1=""
ramp2=""
ramp3=""

help() { echo "Error: usage $0 {display|inc|dec|mute|sink}" ; }
sink() { pactl list short sinks | grep 'RUNNING' | cut -f2 | tail -1 ; }
volume() { pactl list sinks | grep -A7 "Name: $(sink)" | tail -1 | awk '{print $5}' | tr -d '%' ; }
icon() {
    if [[ $(amixer get Master | tail -2 | grep -c '\[on\]') = 0 ]]; then
        icon=$ramp0
    else
        vol=$(volume)
        case 1 in
            $(($vol < 33))) icon=$ramp1 ;;
            $(($vol < 66))) icon=$ramp2 ;;
            $(($vol < 101))) icon=$ramp3 ;;
        esac
    fi
    echo "$icon"
}
increase(){ pactl set-sink-volume "$(sink)" +2% ; }
decrease(){ pactl set-sink-volume "$(sink)" -2% ; }
mute(){ pactl-set-sink-mute "$(sink)" toggle; }
display(){ echo "$(icon) $(volume)%" ; }
main() {
    mode="$1"
    case "$mode" in
        'display') display ;;
        'inc'    ) increase ;;
        'dec'    ) decrease ;;
        'mute'   ) mute ;;
        'sink'   ) sink ;;
        *) help && exit 1 ;;
    esac
}

main "$1"


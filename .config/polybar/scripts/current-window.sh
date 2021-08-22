#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
#wsicon="" #$(echo -e '\uF260')"

help() {
    echo "Usage: $0 {text|icon|both}"
}
getThresh() {
    grep '^focus_thresh:' "$mode_file" | cut -d':' -f2
}
setThresh() {
    sed -i "/^focus_thresh:/s/:.*/:$1/" "$mode_file"
}

intToRoman() {
    case "$1" in
        1) numeral="I" ;;
        2) numeral="II" ;;
        3) numeral="III" ;;
        4) numeral="IV" ;;
        5) numeral="V" ;;
        6) numeral="VI" ;;
        7) numeral="VII" ;;
        8) numeral="VIII" ;;
        9) numeral="IX" ;;
        10) numeral="X" ;;
    esac
    echo $numeral
}
getWorkspace() {
    ws="$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true).name' | cut -d"\"" -f2)"
    echo "$ws"
    #intToRoman "$ws"
}
getIcon() {
    id="$1"
    wininfo="$(xprop -id $id)"
    if [ "$(echo "$wininfo" | grep '_NET_WM_NAME(UTF8_STRING)')" = "i3" ]; then
        icon=" "
    elif [ "$(echo "$wininfo" | grep -c 'GTK_APPLICATION')" -gt 0 ]; then
        icon=""
    else
        class="$(echo "$wininfo" | grep WM_CLASS | cut -d\" -f4)"
        name="$(echo "$wininfo" | grep WM_NAME | cut -d'=' -f2)"
        case "$class $name" in
            *st-256color*) icon="" ;;
            *Firefox*    ) icon="" ;;
            *Steam*      ) icon="" ;;
            *.pdf*       ) icon="" ;;
            *mpv*        ) icon="" ;;
            *) icon=" " ;;
        esac
    fi
    echo "$icon"
}
getName() {
    id="$1"
    name="$(xprop -id $id WM_NAME | cut -d'=' -f2 | tr -d '"' | tr -s " " | sed -e 's/[Nn]one//' | sed -e 's/^ //')"
    if [[ "$name" =~ ".pdf" ]]; then
        name="$(echo "$name" | rev | cut -d'/' -f-2 | rev | sed -e 's/^/...\//')"
    fi
    echo "$name" | tr -dc '\0-\177' # delete all non-ascii chars
}
display() {
    ws="$(getWorkspace)" # focused window workspace
    ws="$(intToRoman $ws)"
    id=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
    if [[ $id = 0x0 ]];then
        icon=""
        name=" "
    else
        icon="$(getIcon $id)"
        name="$(getName $id)"
    fi
    mode="$1"
    case "$mode" in
        'text'  ) str="$name" ;;
        'icon'  ) str="$ws $icon" ;;
        'both'  ) str="$ws $icon $name" ;;
        'thresh') setThresh "$2" ;;
        *) help && exit 1 ;;
    esac
    thresh="$(getThresh)"
    case "$mode" in
        text|both)
            if [[ $thresh -eq 0 ]]; then
                echo "$str"
            else
                echo "$str" | cut -c -$thresh
            fi
            ;;
        *) echo "$str" ;;
    esac
}

display "$1" "$2"

#!/bin/bash
shopt -s extglob

#wsicon="" #$(echo -e '\uF260')"
thresh=50

getIcon() {
    id="$1"
    wininfo="$(xprop -id $id)"
    if [ "$(echo "$wininfo" | grep '_NET_WM_NAME(UTF8_STRING)')" = "i3" ]; then
        icon=""
    elif [ "$(echo "$wininfo" | grep -c 'GTK_APPLICATION')" -gt 0 ]; then
        icon=""
    else
        class="$(echo "$wininfo" | grep WM_CLASS | cut -d\" -f4)"
        name="$(echo "$wininfo" | grep WM_NAME | cut -d'=' -f2)"
        case "$class $name" in
            *st-256color*) icon="" ;;
            *Firefox*    ) icon="" ;;
            *.pdf*       ) icon="" ;;
            *mpv*        ) icon="" ;;
            *) icon="" ;;
        esac
    fi
    echo "$icon"
}
getWorkspace() {
#    id="$1"
#    index="$(xprop -id $id _NET_WM_DESKTOP | cut -d'=' -f2 | tr -d '" ' | sed -s 's/$/+1/' | bc)"
#    wslist="$(i3-msg -t get_tree | grep -Eo '.num.:[0-9][0-9]*' | cut -d':' -f2)"
#    echo "$wslist" | head -"$index" | tail -1
    # get currently focused i3 workspace
    i3-msg -t get_workspaces | jq '.[] | select(.focused==true).name' | cut -d"\"" -f2
}
getName() {
    id="$1"
    name="$(xprop -id $id WM_NAME | cut -d'=' -f2 | tr -d '"' | tr -s " " | sed -e 's/[Nn]one//' | sed -e 's/^ //')"
    if [[ "$name" =~ ".pdf" ]]; then
        echo "$name" | rev | cut -d'/' -f-2 | rev | sed -e 's/^/...\//'
    else
        echo "$name" #| rev | cut -d'-' -f2- | rev
    fi
}
main() {
    id=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
    ws="$(getWorkspace)" # focused window workspace
    xprop -id $id > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        icon="$(getIcon $id)"
        name="$(getName $id)"
        # trucate output to desired length
        echo "$ws $icon $name" | cut -c -$thresh
    else
        echo "$ws"
    fi
}

main

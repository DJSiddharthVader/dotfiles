#!/bin/bash
shopt -s extglob

#wsicon="" #$(echo -e '\uF260')"
thresh=40

help() {
    echo "Usage: $0 {text|icon|both}"
}
getWorkspace() {
    i3-msg -t get_workspaces | jq '.[] | select(.focused==true).name' | cut -d"\"" -f2
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
        'text') str="$name" ;;
        'icon') str="$ws $icon" ;;
        'both') str="$ws $icon $name" ;;
        *) help && exit 1 ;;
    esac
    case "$mode" in
        #text|both) printf "%-${thresh}s" "$str" | cut -c -$thresh ;;
        text|both) echo "$str" | cut -c -$thresh ;;
        *) echo "$str" ;;
    esac
}

display "$1"

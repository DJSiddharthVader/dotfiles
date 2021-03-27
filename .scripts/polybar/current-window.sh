#!/bin/bash
shopt -s extglob

#wsicon="" #$(echo -e '\uF260')"
thresh=40

getIcon() {
    id="$1"
    if [ "$(xprop -id $id | grep -c 'GTK_APPLICATION')" -gt 0 ]; then
        icon=""
    else
        class="$(xprop -id $id WM_CLASS | cut -d\" -f4)"
        name="$(xprop -id $id WM_NAME | cut -d'=' -f2)"
        case "$class $name" in
            *st-256color*) icon="" ;;
            *Firefox*    ) icon="" ;;
            *.pdf*       ) icon="" ;;
            *) icon="" ;;
        esac
    fi
    echo "$icon"
}
getWorkspace() {
    id="$1"
    index="$(xprop -id $id _NET_WM_DESKTOP | cut -d'=' -f2 | tr -d '" ' | sed -s 's/$/+1/' | bc)"
    wslist="$(i3-msg -t get_tree | grep -Eo '.num.:[0-9][0-9]*' | cut -d':' -f2)"
    echo "$wslist" | head -"$index" | tail -1

}
getName() {
    id="$1"
    name="$(xprop -id $id WM_NAME | cut -d'=' -f2 | tr -d '"' | tr -s " " | sed -e 's/[Nn]one//' | sed -e 's/^ //')"
    if [[ "$name" =~ ".pdf" ]]; then
        echo "$name" | rev | cut -d'/' -f-2 | rev | sed -e 's/^/...\//'
    else
        echo "$name"
    fi
}
main() {
    id=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
    ws="$(getWorkspace $id)"
    icon="$(getIcon $id)"
    name="$(getName $id)"
    #left pad until length $thresh
    echo "$wsicon $ws $icon $name" | cut -c -$thresh
}

main

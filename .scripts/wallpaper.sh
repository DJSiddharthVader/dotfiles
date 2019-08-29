#!/bin/sh

bgfile="$HOME/dotfiles/.varfiles/bordered_background.png"
unbgfile="$HOME/dotfiles/.varfiles/unbordered_background.png"
picdir="$HOME/Pictures/wallpapers"
histfile="$HOME/dotfiles/.varfiles/fehbg"
idxfile="$HOME/dotfiles/.varfiles/wallidx"
tmp='/tmp/histfile'
bordercolor='Black'
resolution='1366x768!' #resolution, ignore aspect ratio
appendHist() {
    ls "$picdir" | shuf >> "$histfile"
}
resetHist() {
    ls "$picdir" | shuf >| "$histfile"
}
updateImageIdx() {
    mode="$1"
    expimg="$2"
    idx=$(cat "$idxfile")
    maxidx="$(wc -l "$histfile" | cut -d' ' -f1)"
    case "$mode" in
        'path')
            head -"$idx" "$histfile" >| "$tmp"
            echo "$(basename "$expimg")" >> "$tmp"
            remain="$(( $maxidx - $idx ))"
            tail -"$remain" "$histfile" >> "$tmp"
            mv "$tmp" "$histfile"
            nidx=$(( $idx + 1 ))
            ;;
        'prev')
            if [ $idx -lt 1 ]; then
                resetHist
                nidx=1
            else
                nidx=$(( $idx - 1 ))
            fi
            ;;
        'stay')
            nidx="$idx"
            ;;
        'next')
            if [ "$idx" -gt "$maxidx" ]; then
                appendHist
            fi
            nidx=$(( $idx + 1 ))
            ;;
        *)
            echo "Usage: $0 {stay|path|next|prev} path/to/image (optional)"
            exit 1
    esac
    echo "$nidx" >| "$idxfile"
    echo "$nidx"
}
idxToImage(){
    idx="$1"
    image="$picdir/$(head -"$idx" "$histfile" | tail -1)"
    echo "$image"
}
addBorderToImg() {
    image="$1"
    cp "$image" "$unbgfile"
    convert "$unbgfile" -resize "$resolution" -bordercolor "$bordercolor" -border 0x34 "$bgfile" #add borderes to image
}
setImg() {
    image="$1"
    addBorderToImg "$image"
    barmode="$(head -1 ~/dotfiles/.varfiles/bartoggle)" #get bar status
    case "$barmode" in
        float)
            feh --bg-scale "$unbgfile" #without borders
            ;;
        full)
            feh --bg-scale "$bgfile" #with borders
            ;;
        mini)
            feh --bg-scale "$unbgfile" #without borders
            ;;
        none)
            feh --bg-scale "$unbgfile" #without borders
            ;;
        *)
            echo "usage {float|full|mini|none}"
            exit 1
            ;;
    esac
}
main() {
    mode="$1"
    imode="$2"
    image="$(basename "$3")"
    if [ "$(wc -l $histfile | cut -d' ' -f1)" -lt 1 ]; then
        resetHist
    fi
    nidx=$(updateImageIdx "$imode" "$image")
    image="$(idxToImage "$nidx")"
    echo "$image"
    case "$mode" in
        'font')
            #wpg -ns "$unbgfile"
            wal -e -n -g -i "$image"  #font only
            #wpg -A "$unbgfile"
            ~/dotfiles/.scripts/bar_manager.sh auto >> /dev/null 2>&1
            ~/apps/oomox-gtk-theme/change_color.sh -o pywal ~/.cache/wal/colors.oomox #>> /dev/null 2>&1
            ;;
        'back')
            setImg "$image"
            ;;
        'both')
            #wpg -ns "$image"
            wal -e -n -g -i "$image"  #font only
            #wpg -A "$image"
            ~/dotfiles/.scripts/bar_manager.sh auto >> /dev/null 2>&1
            setImg "$image"
            ~/apps/oomox-gtk-theme/change_color.sh -o pywal ~/.cache/wal/colors.oomox #>> /dev/null 2>&1
            ;;
        *)
            echo "Usage: $0 {font|back|both} {stay|path|next|prev} path/to/image (optional)"
            exit 1
    esac
}

#main mode position img
main "$1" "$2" "$3"

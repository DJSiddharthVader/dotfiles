#!/bin/bash
shopt -s extglob

# Vars
bgfile="$HOME/dotfiles/.varfiles/bordered_background.png"
unbgfile="$HOME/dotfiles/.varfiles/unbordered_background.png"
picdir="$HOME/Pictures/wallpapers"
histfile="$HOME/dotfiles/.varfiles/fehbg"
idxfile="$HOME/dotfiles/.varfiles/wallidx"
resolution='1366x768!' #resolution, ignore aspect ratio


usage() { echo "Usage: $0 {path/to/image|rs|prev|stay|next} {font|back|both}" ; }
appendHist() { find "$picdir" -maxdepth 99 -type f >| "$histfile" ; }
resetHist() { find "$picdir" -maxdepth 99 -type f | shuf >| "$histfile" ; }
updateImageIdx() {
    [[ -f "$1" ]] && mode="path" || mode="$1"
    idx=$(cat "$idxfile")
    maxidx="$(wc -l "$histfile" | cut -d' ' -f1)"
    tmp="$(mktemp)"
    case "$mode" in
        'path')
            head -"$idx" "$histfile" >| "$tmp"
            echo "$(readlink -e "$1")" >> "$tmp"
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
        'next')
            [ "$idx" -gt "$maxidx" ] && appendHist
            nidx=$(( $idx + 1 ))
            ;;
        'stay') nidx="$idx" ;;
        *) usage && exit 1 ;;
    esac
    echo "$nidx" >| "$idxfile"
    echo "$nidx"
    rm $tmp
}
idxToImage(){ echo "$(head -"$1" "$histfile" | tail -1)" ; }
addBorderToImg() {
    image="$1"
    cp "$image" "$unbgfile"
    #bordercolor="$(convert "$image" -colorspace Gray -scale 1x1\! txt:- | grep -oP '#[A-Za-z0-9]{6}')" #average color of grayscale version of the image
    bordercolor="$(convert "$image" -scale 1x1\! txt:- | grep -oP '#[A-Za-z0-9]{6}')" #average color of grayscale version of the image
    convert "$unbgfile" -resize "$resolution" -bordercolor "$bordercolor" -border 0x34 "$bgfile" #add borderes to image
}
setImg() {
    image="$1"
    addBorderToImg "$image"
    barmode="$(head -1 ~/dotfiles/.varfiles/barmode)" #get bar status
    case "$barmode" in
        float|mini|none) feh --bg-scale "$unbgfile" ;; #without borders
        full) feh --bg-scale "$bgfile" ;; #with borders
        *) usage && exit 1 ;;
    esac
}
changeColors() {
    image="$1"
    wal -e -n -i "$image"  #font only
   ~/dotfiles/.scripts/bar-manager.sh reload >> /dev/null 2>&1
    ~/apps/oomox-gtk-theme/change_color.sh -o pywal ~/.cache/wal/colors.oomox > /dev/null 2>&1
    timeout 0.5s xsettingsd -c dotfiles/.varfiles/gtkautoreload.ini > /dev/null 2>&1
    ~/dotfiles/.scripts/zathura.sh
    #pywalfox update # update firefox css
}
main() {
    method="$1"
    if [ "$(wc -l $histfile | cut -d' ' -f1)" -lt 1 ]; then
        resetHist
        echo 1 >| "$idxfile"
    fi
    if [ "$method" = 'rs' ]; then
        resetHist
        echo 1 >| "$idxfile"
        exit 0
    else
        nidx=$(updateImageIdx "$method")
        image="$(idxToImage "$nidx")"
    fi
    mode="$2"
    case "$mode" in
        'font') changeColors "$image" ;;
        'back') setImg "$image" ;;
        'both') setImg "$image" && changeColors "$image" ;;
        *) usage && exit 1 ;;
    esac
}

#main mode position img
if (( $# < 1 )); then
    usage
    exit 1
elif (( $# == 1 )); then
    image="$1"
    mode="both"
else
    image="$1"
    mode="$2"
fi
    main "$image" "$mode"

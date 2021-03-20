#!/bin/bash
set -eo pipefail # -e causes gtkautoreload to fail since it relies on timeout
shopt -s extglob

# Vars
bgfile="$HOME/dotfiles/.varfiles/bordered_background.png"
unbgfile="$HOME/dotfiles/.varfiles/unbordered_background.png"
picdir="$HOME/Pictures/wallpapers"
histfile="$HOME/dotfiles/.varfiles/fehbg"
indexfile="$HOME/dotfiles/.varfiles/wallindex"
icon=""

usage() {
    name="$(basename $0)"
    blnk="$(echo $name | sed -e 's/./ /g')"
    echo \
"Usage: ./$name {path/to/image|rh|reload|display|prev|stay|next} {font|back|both}
          $blnk rh
          $blnk reload
          $blnk display
          $blnk path/to/image {font|back|both}
          $blnk prev          {font|back|both}
          $blnk stay          {font|back|both}
          $blnk next          {font|back|both}"
}

appendHistory() {
    find "$picdir" -maxdepth 99 -type f >| "$histfile"
}
resetHistory() {
    find "$picdir" -maxdepth 99 -type f | shuf >| "$histfile"
    echo 1 >| "$indexfile"
}

currentIndex() {
    head -1 "$indexfile" | sed -e 's/^\([0-9]*\)[^0-9]*$/\1/'
}
indexToImage(){
    head -"$1" "$histfile" | tail -1
}
updateImageIndex() {
    [[ -f "$1" ]] && mode="path" || mode="$1"
    index="$(currentIndex)"
    maxindex="$(wc -l "$histfile" | cut -d' ' -f1)"
    case "$mode" in
        'path')
            tmp="$(mktemp)"
            head -"$index" "$histfile" >| "$tmp"
            echo "$(readlink -e "$1")" >> "$tmp"
            remain=$(( $maxindex - $index ))
            tail -"$remain" "$histfile" >> "$tmp"
            mv "$tmp" "$histfile"
            index=$(( $index + 1 ))
            ;;
        'prev')
            [ $index -lt 1 ] && resetHistory && index=2
            index=$(( $index - 1 ))
            ;;
        'next')
            [ "$index" -gt "$maxindex" ] && appendHistory
            index=$(( $index + 1 ))
            ;;
        'stay') index="$index" ;;
        *) usage && exit 1 ;;
    esac
    echo "$index"
}

addBorder() {
    image="$1"
    resolution="$(xrandr | grep ' primary' | grep -o '[0-9]\{3,\}x[0-9]\{3,\}')"
    bordercolor="$(convert "$image" -scale 1x1\! txt:- | grep -oP '#[A-Za-z0-9]{6}')" #average color of grayscale version of the image
    convert "$unbgfile" -resize "$resolution" -bordercolor "$bordercolor" -border 0x34 "$bgfile" #add borderes to image
}
setWallpaper() {
    image="$1"
    cp "$image" "$unbgfile"
    addBorder "$image"
    case "$(head -1 ~/dotfiles/.varfiles/barmode)" in
        float|mini|none) feh --bg-scale "$unbgfile" ;; #without borders
        full           ) feh --bg-scale "$bgfile" ;; #with borders
        *              ) usage && exit 1 ;;
    esac
}
colorFirefox() {
    window_id="$(xwininfo -tree -root | grep '\"Navigator\" \"Firefox\"' | head -1 | grep -o '0x[0-9a-Z]*' | head -1)" #get window id for a firefox windown (doesnt matter which one)
    xdotool key --window "$window_id" --clearmodifiers "ctrl+h" # send ctrl+h keypress to firefox window
    # this triggers a script to reload style sheets, specificalls colors.css
}
changeColors() {
    image="$1"
    wal -geni "$image"  #font only
    colorFirefox
    ~/dotfiles/.scripts/bar-manager.sh reload >> /dev/null 2>&1
    timeout 0.5s xsettingsd -c ~/dotfiles/.varfiles/gtkautoreload.ini
    ~/apps/oomox-gtk-theme/change_color.sh -o pywal ~/.cache/wal/colors.oomox > /dev/null 2>&1
    ~/dotfiles/.scripts/zathura.sh
}
wall() {
    mode="$1"
    index=$(updateImageIndex "$mode")
    echo "$index" >| "$indexfile"
    image="$(indexToImage "$index")"
    polybar-msg hook wall 1

    [ -z "$2" ] && change='back' || change="$2"
    case "$change" in
        'font') changeColors "$image" ;;
        'back') setWallpaper "$image" ;;
        'both') setWallpaper "$image" && changeColors "$image" ;;
        *) usage && exit 1 ;;
    esac
}

display() {
    wallpaper="$(head -n $(currentIndex) "$histfile" | tail -1 | sed -E 's/^.*wallpapers\/(.*)$/...\/\1/')"
    echo "$wallpaper"
    #echo "$icon $wallpaper"
}

main() {
    [ "$(wc -l $histfile | cut -d' ' -f1)" -lt 1 ] && resetHistory
    [ -f "$1" ] && mode='path' || mode="$1"
    change="$2"
    case "$mode" in
        'path'        ) wall "$1" "$change" ;;
        stay|prev|next) wall "$mode" "$change" ;;
        'reload'      ) wall 'stay' 'both'     ;;
        'rh'          ) resetHistory && exit 0 ;;
        'display'     ) display && exit 0      ;;
        *) usage && exit 1 ;;
    esac
}

case 1 in
    $(( $# == 1 )))
        mode="$1"
        change="back"
        ;;
    $(( $# == 2 )))
        mode="$1"
        change="$2"
        ;;
    $(( $# < 1  ))) usage && exit 1 ;;
    $(( $# > 2  ))) usage && exit 1 ;;
esac

main "$mode" "$change"


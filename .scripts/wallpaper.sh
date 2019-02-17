#!/bin/sh

i3dir='/home/sidreed/dotfiles/.config/i3/' #store bordered image
picdir='/home/sidreed/Pictures/wallpapers' #dir with all wallpapers
resolution='1366x768!' #resolution, ignore aspect ratio

backgroundPath() { #pick background image
    if [ -n "$1" ]; then #string not null
        imgname=$(basename "$1")
    else
        imgname=$(ls  ~/Pictures/wallpapers | shuf -n 1) #pick rnd image
    fi
    walp="$picdir/$imgname" #need abs paths or convert fails
    echo "$walp"
}

fullOrBordered() {
    image="$1"
    barmode="$(head -1 ~/dotfiles/.bartoggle)" #get bar status
    bgfile="$i3dir"bordered_background.png
    unbkbgfile="$i3dir"unbordered_background.png
    echo "feh --bg-scale $image" >> ~/.scripts/.fehbg #record image in file
    convert "$image" -resize "$resolution" -bordercolor Black -border 0x5% "$bgfile" #add borderes to image
    cp "$image" "$unbkbgfile"

    case "$barmode" in
        full)
            feh --bg-scale "$bgfile" #with borders
            ;;
        mini)
            feh --bg-scale "$unbkbgfile" #without borders
            ;;
        none)
            feh --bg-scale "$unbkbgfile" #without borders
            ;;
        *)
            echo "usage {full|mini|none}"
            exit 1
            ;;
    esac
}

main() {
    mode="$1"
    imagefile="$2"
    case "$mode" in
        'font')
            wal -e -n -i "$imagefile" & #font only
            ;;
        'back')
            fullOrBordered "$imagefile"
            ;;
        'both')
            fullOrBordered "$imagefile"
            wal -e -n -i "$imagefile" & #font only
            ;;
        *)
            echo "Usage: $0 {font|back|both}"
            exit 1
    esac
}

mode="$1"
explicitBackgroundImage="$2"
walp=$(backgroundPath "$explicitBackgroundImage")
main "$mode" "$walp"




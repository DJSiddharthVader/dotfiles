#!/bin/sh
imgname=`ls  ~/dotfiles/wallpapers | shuf -n 1` #pick rnd image
walp="/home/sidreed/dotfiles/wallpapers/$imgname" #need abs paths or convert fails
i3dir="/home/sidreed/dotfiles/.config/i3/" #store bordered image
resolution="1366x768\!" #resolution, ignore aspect ratio

case "$1" in
    'font')
        wal -e -n -i $walp #font only
        ;;
    'background')
        bgfile="$i3dir"bordered_background.png
        convert "$walp" -resize "$resolution" "$bgfile"
        convert "$bgfile" -bordercolor Black -border 0x5% "$bgfile"
        feh --bg-scale "$bgfile"
        echo "feh --bg-scale $walp" >> .fehbg
        ;;
    'both')
        wal -e -n -i $walp #font only
        bgfile="$i3dir"bordered_background.png
        convert "$walp" -resize "$resolution" "$bgfile"
        convert "$bgfile" -bordercolor Black -border 0x5% "$bgfile"
        feh --bg-scale "$bgfile"
        echo "feh --bg-scale $walp" >> .fehbg
        ;;
    *)
        echo "Usage: $0 {font|background|both}"
        exit 1
esac



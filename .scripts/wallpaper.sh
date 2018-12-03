#!/bin/sh

imgname=`ls  ~/Pictures/wallpapers | shuf -n 1` #pick rnd image
if [ "$2" = "" ]; then
    imgname=`ls  ~/Pictures/wallpapers | shuf -n 1` #pick rnd image
    #imgname='cyber_living_pod.png'
else
    imgname=`basename "$2"`
fi
walp="/home/sidreed/Pictures/wallpapers/$imgname" #need abs paths or convert fails
i3dir="/home/sidreed/dotfiles/.config/i3/" #store bordered image
resolution='1366x768!' #resolution, ignore aspect ratio

case "$1" in
    'font')
        wal -e -n -i $walp & #font only
        ;;
    'background')
        bgfile="$i3dir"bordered_background.png
        convert "$walp" -resize "$resolution" "$bgfile"
        convert "$bgfile" -bordercolor Black -border 0x5% "$bgfile"
        feh --bg-scale "$bgfile"
        cp "$walp" ~/dotfiles/.config/i3/unbordered_background.png
        ;;
    'both')
        wal -e -n -i $walp & #font only
        bgfile="$i3dir"bordered_background.png
        convert "$walp" -resize "$resolution" "$bgfile"
        convert "$bgfile" -bordercolor Black -border 0x5% "$bgfile"
        feh --bg-scale "$bgfile"
        cp "$walp" ~/dotfiles/.config/i3/unbordered_background.png
        ;;
    'sback')
        bgfile="$i3dir"bordered_background.png
        convert "$walp" -resize "$resolution" "$bgfile"
        convert "$bgfile" -bordercolor Black -border 0x5% "$bgfile"
        feh --bg-scale "$bgfile"
        echo "feh --bg-scale $walp" >> .fehbg
        echo "feh --bg-scale $bgfile" >> .fehbg
        ;;
    *)
        echo "Usage: $0 {font|background|both|sback}"
        exit 1
esac



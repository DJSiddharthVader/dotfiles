#!/bin/sh

i3dir="/home/sidreed/dotfiles/.config/i3/" #store bordered image
resolution='1366x768!' #resolution, ignore aspect ratio

imgname=`ls  ~/Pictures/wallpapers | shuf -n 1` #pick rnd image
if [ "$2" = "" ]; then
    imgname=`ls  ~/Pictures/wallpapers | shuf -n 1` #pick rnd image
else
    imgname=`basename "$2"`
fi
walp="/home/sidreed/Pictures/wallpapers/$imgname" #need abs paths or convert fails

case "$1" in
    'font')
        wal -e -n -i $walp & #font only
        ;;
    'back')
        echo "feh --bg-scale $walp" >> ~/.scripts/.fehbg
        bgfile="$i3dir"bordered_background.png
        convert "$walp" -resize "$resolution" -bordercolor Black -border 0x5% "$bgfile"
        feh --bg-scale "$bgfile"
        cp "$walp" ~/dotfiles/.config/i3/unbordered_background.png
        ;;
    'both')
        echo "feh --bg-scale $walp" >> ~/.scripts/.fehbg
        bgfile="$i3dir"bordered_background.png
        convert "$walp" -resize "$resolution" -bordercolor Black -border 0x5% "$bgfile"
        feh --bg-scale "$bgfile"
        wal -e -n -i $walp & #font only
        cp "$walp" ~/dotfiles/.config/i3/unbordered_background.png
        ;;
    'sback')
        echo "feh --bg-scale $walp" >> ~/.scripts/.fehbg
        bgfile="$i3dir"bordered_background.png
        convert "$walp" -resize "$resolution" -bordercolor Black -border 0x5% "$bgfile"
        feh --bg-scale "$bgfile"
        ;;
    *)
        echo "Usage: $0 {font|back|both|sback}"
        exit 1
esac



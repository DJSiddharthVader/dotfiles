#!/bin/sh

i3dir='/home/sidreed/dotfiles/.config/i3' #store bordered image
bgfile="$i3dir"/bordered_background.png
unbgfile="$i3dir"/unbordered_background.png
picdir='/home/sidreed/Pictures/wallpapers' #dir with all wallpapers
histfile='/home/sidreed/.scripts/.fehbg'
idxfile='/home/sidreed/.scripts/.wallidx'
tmp='/tmp/histfile'
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
        'expi')
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
    echo $nidx >| "$idxfile"
    echo $nidx

}
idxToImage(){
    idx="$1"
    image="$picdir/$(head -"$idx" "$histfile" | tail -1)"
    echo "$image"
}
addBorderToImg() {
    image="$1"
    cp "$image" "$unbgfile"
    convert "$unbgfile" -resize "$resolution" -bordercolor Black -border 0x40 "$bgfile" #add borderes to image
}
setImg() {
    image="$1"
    addBorderToImg "$image"
    barmode="$(head -1 ~/dotfiles/.bartoggle)" #get bar status
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
    image="$3"
    cat "$idxfile"
    nidx=$(updateImageIdx "$imode" "$image")
    echo "$nidx"
    image="$(idxToImage "$nidx")"
    echo "$image"
    case "$mode" in
        'font')
            wal -e -n -i "$image" & #font only
            ;;
        'back')
            setImg "$image"
            ;;
        'both')
            setImg "$image"
            wal -e -n -i "$image" & #font only
            ;;
        *)
            echo "Usage: $0 {font|back|both} {stay|path|next|prev} path/to/image (optional)"
            exit 1
    esac
}

#main back next
main "$1" "$2" "$3"

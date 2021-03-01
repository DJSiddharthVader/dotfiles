#!/bin/bash
set -e

#colors,text,font
ringcolor=ffffffff
keyhlcolor=3cc908ff
bshlcolor=d23c3dff
separatorcolor=00000000
insidecolor=00000000
insidevercolor=00000000
ringvercolor=ffffffff
insidewrongcolor=00000000
ringwrongcolor=ff0000ff
wrongcolor=ffffffff
verifcolor=ffffffff
timecolor=ffffffff
datecolor=ffffffff
loginbox=00000066
datestring=
font='Terminus:style=Bold'
locktext="$(date +'%A, %B %d %Y' )"
screensaverpath="$HOME/.screen.png"

lockbox() { #drawing rectangles
    rectangles=" "
    SR="$(xrandr -q | grep ' connected' | grep -o '[0-9]*x[0-9]*+[0-9]*+[0-9]*')"
    for RES in $SR; do
        SRA=(${RES//[x+]/ })
        CX=$((${SRA[2]} + 35))
        CY=$((${SRA[1]} - 40))
        rectangles+="rectangle $CX,$CY $((CX+300)),$((CY-80)) "
    done
    echo "$rectangles"
}
main(){
    mpc pause > /dev/null 2>&1
    rectangles="$(lockbox)"
    scrot "$screensaverpath"
    convert "$screensaverpath" -scale 20% -scale 500% -draw "fill black fill-opacity 0.8 $rectangles" "$screensaverpath"
    #lock command
    /home/sidreed/apps/i3lock-color/build/i3lock \
        -i "$screensaverpath" -t             \
        --indpos='x+290:h-80'                \
        --noinputtext=''                     \
        --clock                              \
        --timepos='x+115:h-80'               \
        --timecolor="$timecolor"             \
        --time-font="$font"                  \
        --datestr "$locktext"                \
        --datepos='x+145:h-60'               \
        --datecolor="$datecolor"             \
        --date-font="$font"                  \
        --layout-font="$font"                \
        --radius=25                          \
        --ring-width=4                       \
        --ringcolor=$ringcolor               \
        --insidecolor=$insidecolor           \
        --line-uses-inside                   \
        --keyhlcolor=$keyhlcolor             \
        --bshlcolor=$bshlcolor               \
        --separatorcolor=$separatorcolor     \
        --veriftext=''                       \
        --verif-font="$font"                 \
        --verifcolor="$verifcolor"           \
        --ringvercolor=$ringvercolor         \
        --insidevercolor=$insidevercolor     \
        --wrongtext=''                       \
        --wrong-font="$font"                 \
        --wrongcolor="$wrongcolor"           \
        --ringwrongcolor=$ringwrongcolor     \
        --insidewrongcolor=$insidewrongcolor
    rm $screensaverpath
}

main


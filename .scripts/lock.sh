#!/bin/bash

screensaverpath="/tmp/screen.png"
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
#drawing rectangles
rectangles=" "
SR=$(xrandr --query | grep ' connected' | grep -o '[0-9][0-9]*x[0-9][0-9]*[^ ]*')
for RES in $SR; do
    SRA=(${RES//[x+]/ })
    CX=$((${SRA[2]} + 35))
    CY=$((${SRA[1]} - 40))
    rectangles+="rectangle $CX,$CY $((CX+300)),$((CY-80)) "
done

scrot "$screensaverpath" && convert "$screensaverpath" -scale 20% convert -scale 500% -draw "fill black fill-opacity 0.8 $rectangles" "$screensaverpath"
mpc pause
#lock command
/home/sidreed/apps/i3lock-color/build/i3lock \
    -i "$screensaverpath" \
    --timepos='x+115:h-80' \
    --datepos='x+145:h-60' \
    --indpos='x+290:h-80' \
    --clock --datestr "$locktext" \
    --insidecolor=$insidecolor --ringcolor=$ringcolor --line-uses-inside \
    --keyhlcolor=$keyhlcolor --bshlcolor=$bshlcolor --separatorcolor=$separatorcolor \
    --insidevercolor=$insidevercolor --insidewrongcolor=$insidewrongcolor \
    --ringvercolor=$ringvercolor --ringwrongcolor=$ringwrongcolor \
    --radius=20 --ring-width=4 --veriftext='' \
    --wrongtext='' --wrongcolor="$wrongcolor" \
    --verifcolor="$verifcolor" --timecolor="$timecolor" \
    --datecolor="$datecolor" \
    --time-font="$font" --date-font="$font" --layout-font="$font" \
    --verif-font="$font" --wrong-font="$font" \
    --noinputtext='' #--force-clock


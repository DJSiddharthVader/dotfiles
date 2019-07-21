#!/bin/bash

# Take /tmp/screen.pnga screenshot:
#colors
insidecolor=00000000
ringcolor=ffffffff
keyhlcolor=d23c3dff
bshlcolor=d23c3dff
separatorcolor=00000000
insidevercolor=00000000
insidewrongcolor=d23c3dff
ringvercolor=ffffffff
ringwrongcolor=ffffffff
verifcolor=ffffffff
timecolor=ffffffff
datecolor=ffffffff
loginbox=00000066
font='Terminus:style=Bold'
locktext='Type password to unlock...'
screensaverpath="/tmp/screen.png"
scrot "$screensaverpath" && convert "$screensaverpath" -scale 20% convert -scale 500% "$screensaverpath"
#lock command
/home/sidreed/apps/i3lock-color/build/i3lock \
    -i "$screensaverpath" \
    --timepos='x+110:h-70' \
    --datepos='x+43:h-45' \
    --clock --date-align 1 --datestr "$locktext" \
    --insidecolor=$insidecolor --ringcolor=$ringcolor --line-uses-inside \
    --keyhlcolor=$keyhlcolor --bshlcolor=$bshlcolor \
    --separatorcolor=$separatorcolor \
    --insidevercolor=$insidevercolor --insidewrongcolor=$insidewrongcolor \
    --ringvercolor=$ringvercolor --ringwrongcolor=$ringwrongcolor \
    --indpos='x+280:h-70' \
    --radius=20 --ring-width=4 --veriftext='' --wrongtext='' \
    --verifcolor="$verifcolor" --timecolor="$timecolor" \
    --datecolor="$datecolor" \
    --time-font="$font" --date-font="$font" --layout-font="$font" \
    --verif-font="$font" --wrong-font="$font" \
    --noinputtext='' --force-clock


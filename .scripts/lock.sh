#!/bin/bash
set -e
source "$HOME/.cache/wal/colors.sh"
#colors,text,font
alpha="ff"
background="$(echo "$color1" | tr -d '#')"
background="$color1"
ringcolor="$(echo "$color2$alpha" | tr -d '#')"
keyhlcolor="$(echo "$color3$alpha" | tr -d '#')"
bshlcolor="$(echo "$color4$alpha" | tr -d '#')"
insidecolor=00000000
separatorcolor=00000000
wrongcolor="$(echo "$color5$alpha" | tr -d '#')"
ringwrongcolor="$(echo "$color5$alpha" | tr -d '#')"
insidewrongcolor=00000000
verifcolor="$(echo "$color6$alpha" | tr -d '#')"
ringvercolor="$(echo "$color6$alpha" | tr -d '#')"
insidevercolor=00000000
timecolor="$(echo "$foreground$alpha" | tr -d '#')"
datecolor="$(echo "$foreground$alpha" | tr -d '#')"
loginbox="$(echo "$color1 66" | tr -d ' #')"
#loginbox=00000066
datestring=
font='Terminus:style=Bold'
locktext="$(date +'%A, %B %d %Y' )"

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
    screen="$(mktemp).png"
    scrot "$screen"
    convert "$screen" -scale 20% -scale 500% -draw "fill $background fill-opacity 0.8 $rectangles" "$screen.png"
    #lock command
    /home/sidreed/apps/i3lock-color/build/i3lock \
        -i "$screen.png" -t             \
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
}

main


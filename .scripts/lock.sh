#!/bin/bash
set -e
SCREEN="$HOME/.varfiles/screen.png"
# source curremt theme colors
tmp="$(mktemp)"
tail -n+4 $HOME/.cache/wal/colors.sh >| $tmp
source $tmp
# set colors for lock screen elements
font="GohuFont 11 Nerd Font Mono:style=Regular:size=18"
locktext="$(date +'%A, %B %d %Y' )"
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
lockbox() {
    #drawing rectangles
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
    # actions for locking
    mpc pause > /dev/null 2>&1
    # bw lock # lock bitwarden
    ~/.config/polybar/scripts/pulseaudio-control.sh mute
    #~/.scripts/mullvad.sh disconnect
    #prep lockscreen
    rectangles="$(lockbox)"
    scrot -o "$SCREEN"
    convert "$SCREEN" -scale 20% -scale 500% -draw "fill $background fill-opacity 0.8 $rectangles" "$SCREEN"
    #lock command
    i3lock                                    \
        -i "$SCREEN"                          \
        -t                                    \
        --ind-pos='x+290:h-80'                \
        --noinput-text=''                     \
        --clock                               \
        --time-pos='x+115:h-80'               \
        --time-color="$timecolor"             \
        --time-font="$font"                   \
        --date-str "$locktext"                \
        --date-pos='x+145:h-60'               \
        --date-color="$datecolor"             \
        --date-font="$font"                   \
        --layout-font="$font"                 \
        --radius=25                           \
        --ring-width=4                        \
        --ring-color=$ringcolor               \
        --inside-color=$insidecolor           \
        --line-uses-inside                    \
        --keyhl-color=$keyhlcolor             \
        --bshl-color=$bshlcolor               \
        --separator-color=$separatorcolor     \
        --verif-text=''                       \
        --verif-font="$font"                  \
        --verif-color="$verifcolor"           \
        --ringver-color=$ringvercolor         \
        --insidever-color=$insidevercolor     \
        --wrong-text=''                       \
        --wrong-font="$font"                  \
        --wrong-color="$wrongcolor"           \
        --ringwrong-color=$ringwrongcolor     \
        --insidewrong-color=$insidewrongcolor
}
main

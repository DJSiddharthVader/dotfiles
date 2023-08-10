#!/bin/bash
set -e
# Variables
SCREEN="$HOME/.varfiles/screen.png"
FONT="GohuFont 11 Nerd Font Mono:style=Regular:size=18"
DATE="$(date +'%A, %B %d %Y')"
# source current theme colors
tmp="$(mktemp)"
tail -n+4 $HOME/.cache/wal/colors.sh >| $tmp
source $tmp
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
    # prep lockscreen
    rectangles="$(lockbox)"
    scrot -o "$SCREEN"
    convert "$SCREEN" \
            -scale 20% \
            -scale 500% \
            -draw "fill $color1 fill-opacity 0.85 $rectangles" \
            "$SCREEN"
    #lock command
    i3lock                                    \
        -i "$SCREEN"                          \
        -e -f                                 \
        --clock                               \
        --radius=29                           \
        --ring-width=7                        \
        --ind-pos='x+290:h-80'                \
        --time-pos='x+145:h-80'               \
        --date-pos='x+145:h-55'               \
        --noinput-text=''                     \
        --verif-text=''                       \
        --wrong-text='!!!'                    \
        --date-str="$DATE"                    \
        --layout-font="$FONT"                 \
        --time-font="$FONT"                   \
        --date-font="$FONT"                   \
        --verif-font="$FONT"                  \
        --wrong-font="$FONT"                  \
        --time-color="$foreground"            \
        --date-color="$foreground"            \
        --ring-color=$color2                  \
        --keyhl-color=$color3                 \
        --bshl-color=$color4                  \
        --wrong-color=$color5                 \
        --ringwrong-color=$color5             \
        --verif-color=$color6                 \
        --ringver-color=$color6               \
        --line-uses-inside                    \
        --inside-color=00000000               \
        --insidever-color=00000000            \
        --separator-color=00000000            \
        --insidewrong-color=00000000
}
main

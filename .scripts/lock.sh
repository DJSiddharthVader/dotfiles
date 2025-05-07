#!/bin/bash
set -e
# Variables
SCREEN="$HOME/.varfiles/screen.png"
FONT="GohuFont 11 Nerd Font Mono:style=Regular"
DATE="$(date +'%A, %B %d %Y')"
# Source current theme colors
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
lock(){
    # actions for locking
    mpc pause > /dev/null 2>&1
    # bw lock # lock bitwarden
    ~/.config/polybar/scripts/pulseaudio-control.sh mute
    # prep lockscreen
    scrot -o "$SCREEN"
    convert "$SCREEN" \
            -scale 20% \
            -scale 500% \
            "$SCREEN"
            # -draw "fill $color1 fill-opacity 0.85 $(lockbox)" \
    #lock command
     systemctl suspend && $HOME/Apps/i3lock-color/build/i3lock \
        --nofork                      \
        --pass-volume-keys            \
        -e                            \
        -f                            \
        --clock                       \
        --time-color="$foreground"    \
        --time-font="$FONT"           \
        --time-size=75                \
        --date-str="$DATE"            \
        --date-font="$FONT"           \
        --date-size=20                \
        --date-color="$foreground"    \
        --radius=200                  \
        --ring-width=20               \
        --ring-color=$color2          \
        --inside-color=$color3        \
        --verif-text='...'            \
        --verif-color=$color4         \
        --ringver-color=$color4       \
        --insidever-color=$color4     \
        --wrong-text='!!!'            \
        --wrong-color=$color5         \
        --ringwrong-color=$color5     \
        --insidewrong-color=$color5   \
        -i "$SCREEN"
        # --no-verify                   \
}
# systemctl suspend & lock
lock 
# systemctl suspend && lock

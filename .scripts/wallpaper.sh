#!/bin/bash
set -o pipefail # -e causes gtkautoreload to fail since it relies on timeout
shopt -s extglob # for pattern matching in case statements
## Manage wallpaper and colorschemes
# First the script creates a the $HIST_FILE, file (wallpapers.txt) which is just a list of paths to all wallpapers in $WALLPAPER_DIR.
# It keeps track of the index of the current wallaper (line number in $HIST_FILE) in the $MODE_FILE.
#The index and $HIST_FILE easily allows one to switch between next and previous wallpaper by just changing the index, getting the wallpaer associated with that index and setting all colors and the wallpaper.
# Since it uses `find` to generate the $HIST_FILE the directory structure of the $WALLPAPER_DIR can be arbitrairily complicated
#
# One can also pass an explicit path to a file in the wallpapers dir and the script will handle the indexing accordingly i.e. `./wallpaper.sh path/to/image {font|back|both}`.
# If one changed filenames or add new files inside $WALLPAPER_DIR you need to run with the rh arg to reset the $HIST_FILE, although this could probably be automated with `entr` or something like that to trigger rh when the $WALLPAPER_DIR directory contents changes
#
# After getting the wallpaper image the script can set the wall paper and/or change the colorscheme for basically everything I use based on the wallpaper.
# I use pywal to generate the color palette and colorscheme files based on the wallpaper image.
# Then I run some commands (in change_colors()) to update the colors of apps, specifically
#    - polybar (use custom pywal template and reload the bar, might not need the explicit reload if I use Xressources
#    - GTK apps (generate oomox theme and xsettings for live update)
#    - Firefox (send keypress to firefox that triggers js to reload colors.css file)
#    - zathura (re-write config with new colors using custom script, no live update)
#
# Default behaviour is to only change the wallpaper and then run `./wallpaper.sh` stay both to update the colors.
# I do this since I often scroll through many images before settling on a wallpaper so avoids needlessly running the change_colors() function so many times.
# You can easily scroll through wallpapers using `./wallpaper.sh` next and `./wallpaper.sh` prev and once you get one you like run `./wallpaper.sh stay both` to set the colorschemes.
# For convieniece I have all of these bound to key in i3 because I am fickle and impatient.

# Vars
THRESH=50
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
MODE_FILE="$HOME/dotfiles/.config/polybar/modules.mode"
HIST_FILE="$HOME/.varfiles/wallpapers.txt"
WALLPAPER_FILE="$HOME/.varfiles/wallpaper.png"
ICON=""
# Help messages
usage() {
    name="$(basename $0)"
    blnk="$(echo $name | sed -e 's/./ /g')"
    echo \
"Usage: ./$name {path/to/image|rh|reload|display|prev|stay|next} {font|back|both}
          $blnk rh                              reset wallpaper history
          $blnk reload                          reload colors for current wallpaper
          $blnk print                           print current wallpaper path
          $blnk display                         fprint current wallpaper
          $blnk path/to/image {font|back|both}  set the wallpaper using explicit path to image
                                                can also specify just a directroy and a random
                                                image from that dir will be chosen
          $blnk prev          {font|back|both}  set the wallpaper to previous image
          $blnk stay          {font|back|both}  keep current wallpaper
          $blnk next          {font|back|both}  set the wallpaper to current wallpaper
                              font updates the colorschemes but doesnt update the wallpaper with new image
                              back updates the wallpaper but doesnt update the colorscheme with new image
                              both updates the wallpaper and colorscheme
"
}
# Handle indexing of wallpapers
append_history() {
    # append all wallpapers to history file (append list all wallpapers to history file in random order)
    find "$WALLPAPER_DIR" -maxdepth 99 -type f | shuf >> "$HIST_FILE"
}
reset_history() {
    # re-write history file (list all wallpapers to a file in random order)
    find "$WALLPAPER_DIR" -maxdepth 99 -type f | shuf >| "$HIST_FILE"
    set_index 1
}
get_index() {
    # get index of current wallpaper (read from config file
    grep '^wallpaper_index:' "$MODE_FILE" | cut -d':' -f2
}
set_index() {
    # modify line in config file with $1, must be a number between 0 and maxindex (number of wallpapers)
    sed -i "/^wallpaper_index:/s/:.*/:$1/" "$MODE_FILE"
}
get_image_index(){
    # get the image file for a given index
    head -"$1" "$HIST_FILE" | tail -1
}
update_index() {
    [[ -f "$1" ]] && mode="path" || mode="$1" # check if input is a path to an image
    index="$(get_index)" # get index of current wallpaper
    maxindex="$(wc -l "$HIST_FILE" | cut -d' ' -f1)" # total number of wallpapers
    case "$mode" in
        'path')
            tmp="$(mktemp)"
            # insert image path at the index+1 position in the wallpaper list file and set index++
            head -"$index" "$HIST_FILE" >| "$tmp"
            echo "$(readlink -e "$1")" >> "$tmp"
            remain=$(( $maxindex - $index ))
            tail -"$remain" "$HIST_FILE" >> "$tmp"
            mv "$tmp" "$HIST_FILE"
            index=$(( $index + 1 ))
            ;;
        'prev')
            # if at first index, reset wallpaper list and stay at first index
            [ $index -lt 1 ] && reset_history && index=2
            index=$(( $index - 1 ))
            ;;
        'next')
            # if at last index, append wallpaper list and index++
            [ "$index" -gt "$maxindex" ] && append_history
            index=$(( $index + 1 ))
            ;;
        'stay') index="$index" ;; #nothing changes
        *) usage && exit 1 ;;
    esac
    echo "$index" # return new index
}
# Set wallpaper + update colors
set_wallpaper() {
    image="$1"
    polybar-msg action "#wall.hook.0" # update polybar wallpaper module
    cp "$image" "$WALLPAPER_FILE"     # copy to generic wallpaper location
    feh --bg-scale "$WALLPAPER_FILE"  # set wallpaper
}
change_firefox() {
    # get window id for a firefox window
    window_id="$(xwininfo -tree -root | grep -i '\"Navigator\" \"Firefox\"' | grep -o '0x[0-9a-Z]* ' | head -1)" 
    # send keypress to firefox window, triggers a script to reload the colors.css style sheet produced by pywal
    xdotool key --window $window_id --clearmodifiers "ctrl+h" # send ctrl+h keypress to firefox window
}
change_colors() {
    image="$1"
    wal -a 93 -n -e -i "$image"  # generate colorschemes 
    zathura.sh # re-write zathura config with new colors
    xrdb ~/.cache/wal/colors.Xresources
    if [[ -z "$(pgrep 'polybar')" ]]; then
        bar-manager.sh style stay 
    else
        bar-manager.sh reload > /dev/null 2>&1 # reload polybar with new colors
    fi
    ~/bin/oomox-gtk-theme/change_color.sh -o pywal ~/.cache/wal/colors.oomox  > /dev/null 2>&1 # theme for GTK apps and whatnot
    timeout 0.1s xsettingsd -c ~/.varfiles/gtkautoreload.ini # live reload all GTK app colors
    i3-msg reload
    # restart firefox, extension automatically places windows correctly
    pkill -f firefox && firefox 2>/dev/null &
}
wall() {
    mode="$1"
    if [[ -d "$mode" ]]; then
         mode="$(find "$mode" -maxdepth 99 -type f | shuf | head -1)"
    fi
    index=$(update_index "$mode") # get index of new wallpaper
    set_index "$index" # write index to file
    image="$(get_image_index "$index")" # get image path of index
    [ -z "$2" ] && change='back' || change="$2" #default behaviour is to only change the wallpaper (background)
    case "$change" in
        'font') change_colors "$image" ;;
        'back') set_wallpaper "$image" ;;
        'both') set_wallpaper "$image" && change_colors "$image" ;;
        *) usage && exit 1 ;;
    esac
}
display() {
    wallpaper="$(get_image_index "$(get_index)" | sed -E 's/^.*wallpapers\/(.*)$/...\/\1/')"  # replace WALLPAPER_DIR with ... in wallpaper path
    echo "$wallpaper"
#    if [[ ${#wallpaper} -gt $THRESH ]]; then
#        ( zscroll -l "$THRESH" -d 0.20 -b "" -a "" -p " /// " "$wallpaper" ) &
#        wait
#    else
#        # right pad with spaces until total length $THRESH
#        # keeps module width constant no matter article length
#        printf "%-${THRESH}s" "$wallpaper"
#    fi
}
# Main
main() {
    [ "$(wc -l $HIST_FILE | cut -d' ' -f1)" -lt 1 ] && reset_history
    if [[ -f "$1" || -d "$1" ]]; then
        mode='path' 
    else 
        mode="$1"
    fi
    change="$2"
    case "$mode" in
        rh            ) reset_history                        ;;
        path          ) wall "$1" "$change"                  ;;
        stay|prev|next) wall "$mode" "$change"               ;;
        reload        ) wall 'stay' 'both'                   ;;
        display       ) display                              ;;
        print         ) get_image_index "$(get_index)"       ;;
        *) usage && exit 1 ;;
    esac
    # Update polybar module
    # case "$mode" in
    #     path|prev|next) polybar-msg action "#wallpaper.hook.0" ;;
    # esac

}
case 1 in
    $(( $# == 1 )))
        mode="$1"
        change="both"
        ;;
    $(( $# == 2 )))
        mode="$1"
        change="$2"
        ;;
    $(( $# < 1  ))) usage && exit 1 ;;
    $(( $# > 2  ))) usage && exit 1 ;;
esac
main "$mode" "$change"

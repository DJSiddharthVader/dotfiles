#!/bin/bash
cheat_sheet_dir="$HOME/Documents/cheatsheets"
vimconfig="$HOME/dotfiles/.config/nvim/cheat_vimrc"
pdfgeom="=1000x800"
termgeom="=100x50"

pick() {
   sheet="$(find "$cheat_sheet_dir"/*.* -exec basename {} \; |\
            rev | cut -f2- -d'.' | rev |\
            rofi -m -1 -width 20 -lines 10 -dmenu)"
   [[ -z "$sheet" ]] && echo "" || find "$cheat_sheet_dir"/*.* -name "$sheet.*"
}
open() {
    sheet="$1"
    [[ -z "$sheet" ]] && echo "no selection" && exit
    ext="${sheet##*.}"
    case "$ext" in
        'pdf') tabbed -n 'cheatsheet' -g "$pdfgeom"  zathura "$sheet" -e ;;
        'txt') st     -n 'cheatsheet' -g "$termgeom" -e nvim -R -u "$vimconfig" "$sheet" ;;
        'md' ) st     -n 'cheatsheet' -g "$termgeom" -e sh -c "pandoc $sheet | w3m -T text/html" ;;
        *) echo "Error: invalid extension in $1" && exit 1 ;;
    esac
    #i3-msg floating enable > /dev/null
    #i3-msg move position center > /dev/null
}
main() {
    open "$(pick)"
}

main

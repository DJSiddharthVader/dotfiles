#!/bin/bash
CHEAT_SHEET_DIR="$HOME/.cheatsheets"
VIMCONFIG="$HOME/.config/nvim/cheat_vimrc"
PDFGEOM="=1000x800"
TERMGEOM="=100x50"

pick() {
   sheet="$(find "$CHEAT_SHEET_DIR"/*.* -exec basename {} \; |\
            rev | cut -f2- -d'.' | rev |\
            rofi -m -1 -width 20 -lines 10 -dmenu)"
   [[ -z "$sheet" ]] && echo "" || find "$CHEAT_SHEET_DIR"/*.* -name "$sheet.*"
}
open() {
    sheet="$1"
    [[ -z "$sheet" ]] && echo "no selection" && exit
    ext="${sheet##*.}"
    case "$ext" in
        pdf) tabbed -n 'cheatsheet' -g "$PDFGEOM"  zathura "$sheet" -e ;;
        txt|tex) st -n 'cheatsheet' -g "$TERMGEOM" -e nvim -R -u "$VIMCONFIG" "$sheet" ;;
        md ) st -n 'cheatsheet' -g "$TERMGEOM" -e sh -c "pandoc $sheet | w3m -T text/html" ;;
        *) echo "Error: invalid extension in $1" && exit 1 ;;
    esac
    #i3-msg floating enable > /dev/null
    #i3-msg move position center > /dev/null
}
main() {
    open "$(pick)"
}

main

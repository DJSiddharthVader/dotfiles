#!/bin/bash
CHEAT_SHEET_DIR="$HOME/.cheatsheets"
# VIMCONFIG="$HOME/.config/nvim/cheat_vimrc"
PDFGEOM="=1000x800"
ST_PATH="st"
EDITOR_CMD="${HOME}/bin/nvim-linux-x86_64/bin/nvim"

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
        pdf    ) tabbed -n 'cheatsheet' -g "$PDFGEOM"  zathura "$sheet" -e ;;
        txt|tex) ${ST_PATH} -n 'cheatsheet' -e ${EDITOR_CMD} -R "$sheet" ;;
        sh     ) ${ST_PATH} -n 'cheatsheet' -e ${EDITOR_CMD} -R "$sheet" ;;
        md     ) ${ST_PATH} -n 'cheatsheet' -e sh -c "pandoc $sheet | w3m -T text/html" ;;
        *) echo "Error: invalid extension in $1" && exit 1 ;;
    esac
    #i3-msg floating enable > /dev/null
    #i3-msg move position center > /dev/null
}

open "$(pick)"

#! /bin/bash

dotdir="$HOME/dotfiles"
message="updated miscelanoues/variable/colorscheme/stats files"
to_ignore=(
    "" #status seems to skip this idk why
    ".vim/view/*"
    ".vim/spell/*"
    ".config/mpd/playlists/*"
    ".config/polybar/modules.mode"
    ".config/polybar/separators.mode"
    ".config/qt5ct/colors/pywal.conf"
    ".config/zathura/zathurarc"
    ".config/transmission-daemon/stats.tsv"
    ".gitignore"
    )

help() {
    echo "Error: usage $0 {status|commit|short}"
}
filter() {
    pattern=""
    for i in ${!to_ignore[@]}; do
        files="${to_ignore[$i]}"
        pattern="$pattern\|$files"
    done
    pattern="'$(echo "$pattern" | sed -e 's/^\\|//')'"
    echo "$pattern"
}
short() {
    pattern="$(filter)"
    git status --short 2> /dev/null | grep -v "$pattern"
}
status() {
    pattern="$(filter)"
    git status 2> /dev/null | grep -v "$pattern"
}
commit() {
    cd $dotdir
    for i in ${!to_ignore[@]}; do
        git add "${to_ignore[$i]}"
    done
    git commit -m "$message"
    cd -
}
main() {
    case "$1" in
        'short')  short  ;;
        'status') status ;;
        'commit') commit ;;
        *) help && exit 1 ;;
    esac
}

main "$@"

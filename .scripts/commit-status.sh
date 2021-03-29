#! /bin/bash

dotdir="$HOME/dotfiles"
message="updated miscelanoues/variable/colorscheme/stats files"
to_ignore=(
    "" #status seems to skip this idk why
    ".vim/view/*"
    ".vim/spell/*"
    ".config/polybar/modules.mode"
    ".config/polybar/wallpapers.txt"
    ".config/qt5ct/colors/pywal.conf"
    ".varfiles/*"
    ".config/zathura/zathurarc"
    ".config/deluge/stats.tsv"
    ".gitignore"
    ".config/zathura/zathurarc"
    )

help() {
    echo "Error: usage $0 {status|commit}"
}
status() {
    pattern=""
    for i in ${!to_ignore[@]}; do
        files="${to_ignore[$i]}"
        pattern="$pattern\|$files"
    done
    pattern="'$(echo "$pattern" | sed -e 's/^\\|//')'"
    git status | grep -v "$pattern"
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
        'status') status ;;
        'commit') commit ;;
        *) echo help && exit 1 ;;
    esac
}

main "$@"

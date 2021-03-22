#! /bin/bash

dotdir="$HOME/dotfiles"
to_ignore=(
    "" #status seems to skip this idk why
    ".vim/.netrwhist"
    ".vim/view"
    ".vim/spell"
    ".varfiles"
    ".config/qt5ct/colors/pywal.conf"
    ".config/zathura/zathurarc"
    ".config/deluge/stats.tsv"
    ".gitignore"
    ".config/zathura/zathurarc"
    )
#messages=(
#    "update vim folds"
#    "update vim/netrwhist"
#    "update vim folds "
#    "update background tracking files"
#    "update QT5 colors as set by pywal"
#    "update zathura colors as set by pywal"
#    "torrent stats"
#    "update ignore files"
#    "zathura colors"
#    )

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
    for i in ${to_ignore[@]}; do
        files=${to_ignore[$i]}
        git add $files
    done
    cd -
}
main() {
    case "$1" in
        'status') status ;;
        'commit') commit ;;
        *) echo 'invalid arg' && exit 1 ;;
    esac
}

main "$@"

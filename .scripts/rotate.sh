#!/bin/bash

BACKUP_CMD="joplin export --format jex $HOME/Backups/joplin/joplin_backup-$(date +'%Y%m%d%_H%M').jex"
DEST="$HOME/Backups/joplin/"
ROTATE_LIMIT=5

help() {
    echo "Rotate joplin backups for notes
Usage: $0 [OPTIONS] 
        -c      command that generates log/backup to be rotated
        -l      rotation limit for files
        -h      print this message"
}
rotate() {
    dest="$1"
    limit="$2"
    file_count="$(find $dest -maxdepth 1 -type f | wc -l)"
    echo $file_count
    if [[ $file_count -gt $limit ]]; then
        find $dest -mtime +$limit -exec rm {} \;
    fi
    
}
main() {
    limit=$ROTATE_LIMIT
    cmd=$BACKUP_CMD
    dest="$DEST"
    while getopts "h:r:c" arg; do
        case $arg in
            r) limit="$OPTARG" ;;
            c) cmd="$OPTARG"   ;;
            \?) echo "Invalid option -$arg $OPTARG"
                help && exit 2
                ;;
            h) help && exit 0 ;;
        esac
    done
    shift "$((OPTIND-1))"
    [[ -z "$dest" ]] && dest="$1"
    $cmd
    rotate $dest $limit
}

main "$@"

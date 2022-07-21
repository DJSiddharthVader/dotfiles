#!/bin/bash

# default backup up joplin notes
BACKUP_CMD="joplin export --format jex $HOME/Backups/joplin/joplin_backup-$(date +'%Y%m%d_%H%M').jex"
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
    limit=$2
    file_count=$(find $dest -maxdepth 1 -type f | wc -l)
    if [[ $file_count -gt $limit ]]; then
        find $dest -type f  | xargs -d '\n' stat -c '%z %N' | sort \
            | head -n-$limit | cut -d' ' -f4- | xargs rm  
        # find $dest -type f                   # get all files
        #     | xargs -d '\n' stat -c '%z %N'  # print modification times
        #     | sort                           # sort by time last modified
        #     | head -n-$limit                 # exclude the $limit most recent files
        #     | cut -d' ' -f4-                 # get the file names
        #     | xargs rm                       # pass to rm
    fi
    
}
main() {
    limit=$ROTATE_LIMIT
    cmd=$BACKUP_CMD
    dest=$DEST
    while getopts "h:r:c:" arg; do
        case $arg in
            r) limit="$OPTARG" ;;
            c) cmd="$OPTARG"   ;;
            # d) dest="$OPTARG"   ;;
            \?) echo "Invalid option -$arg $OPTARG"
                help && exit 2
                ;;
            h) help && exit 0 ;;
        esac
    done
    shift "$((OPTIND-1))"
    [[ -n "$1" ]] && dest="$1"
    echo $limit $dest $cmd 
    $cmd
    rotate $dest $limit
}

main "$@"

#!/bin/bash
BACKUP_DRIVE="/media/4tbdrive"
RSYNC_CMD="rsync -ah --ignore-existing --info=progress2"
TO_SYNC=(Music Pictures .varfiles)
TO_UPDATE=(Backups Games Documents Projects Reading)
TO_IGNORE=(dotfiles .steam Torrents Videos)


help() {
    echo "Usage: ./$(basename $0) {backup|sync|update|all}"
}
sync() {
    mountpoint $BACKUP_DRIVE || return 0
    for dir in ${TO_SYNC[@]}; do
        echo "Syncing $dir..."
        $RSYNC_CMD --delete "$HOME/$dir" "$BACKUP_DRIVE"
    done
}
update() {
    mountpoint $BACKUP_DRIVE || return 0
    for dir in ${TO_UPDATE[@]}; do
        echo "Updating $dir..."
        $RSYNC_CMD "$HOME/$dir" "$BACKUP_DRIVE"
    done
}
backup() {
    mountpoint $BACKUP_DRIVE && drive="$BACKUP_DRIVE" || drive="$HOME/Backups/homedir"
    backup_file="$drive/homedirE560_$(date +'%Y%m%d-%H%M').tar.gz"
    echo "Backing up to $backup_file"
    exclude_flags="$(echo ${TO_SYNC[@]} ${TO_UPDATE[@]} ${TO_IGNORE[@]} | sed -e "s:[^ ]*:--exclude=${HOME}\/&:g")"
    tar -pcf - --ignore-failed-read --warning=none $exclude_flags $HOME \
        | pv -s "$(du -sh $exclude_flags $HOME 2> /dev/null | awk '{print $1}')" \
        | gzip -9 > $backup_file
}
main(){
    [[ -z "$@" ]] && help && exit 0
    for mode in $@; do
        case "$mode" in
            'sync'  ) sync   ;;
            'update') update ;;
            'backup') backup ;;
            'all')    update && sync && backup;;
            *) help && exit 1;;
        esac
    done
}

main "$@"

#!/bin/bash
home=~
backup_drive="/media/4tbdrive"
rsync_cmd="rsync -ah --ignore-existing --info=progress2"
to_sync=(CMU_MSCB Music Pictures)
to_update=(Backups Games Documents Projects Reading)
to_ignore=(dotfiles .steam Torrents ToOrganize)


help() {
    echo "Usage: ./$(basename $0) {backup|sync|update|all}"
}
sync() {
    for dir in ${to_sync[@]}; do
        echo "Syncing $dir..."
        $rsync_cmd --delete "$home/$dir" "$backup_drive"
    done
}
update() {
    for dir in ${to_update[@]}; do
        echo "Updating $dir..."
        $rsync_cmd "$home/$dir" "$backup_drive"
    done
}
backup() {
    mountpoint $backup_drive && drive="$backup_drive" || drive="$home"
    backup_file="$drive/Backups/homedirE560_$(date +'%Y%m%d-%H%M').tar.gz"
    echo "Backing up to $backup_file"
    exclude_flags="$(echo ${to_sync[@]} ${to_update[@]} ${to_ignore[@]} | sed -e "s:[^ ]*:--exclude=${home}\/&:g")"    
    tar -pcf - --ignore-failed-read --warning=none $exclude_flags $home \
        | pv -s "$(du -sh $exclude_flags $home 2> /dev/null | awk '{print $1}')" \
        | gzip -9 > $backup_file
}
main(){
    [[ -z "$@" ]] && help && exit 0
    for mode in $@; do
        case "$mode" in
            'backup') backup ;;
            'sync'  ) sync   ;;
            'update') update ;;
            'all')    update && sync && backup;;
            *) help && exit 1;;
        esac
    done
}

main "$@"

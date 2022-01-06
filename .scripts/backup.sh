#!/bin/bash
home="/home/sidreed"
backup_drive="/media/4tbdrive"
rsync_cmd="rsync -a --ignore-existing --info=progress2"
sync=(Apps CMU_MSCB Music Pictures)
update=(Games Documents Projects Reading ToOrganize Torrent)
ignore=(dotfiles)


help() {
    echo "Usage: ./$(basename $0) {backup|sync|update|all}"
}
sync_dir() {
    for dir in ${dirs_to_sync[@]}; do
        echo "Syncing $dir..."
        $rsync_cmd --delete "$home/$dir" "$backup_drive"
    done
}
update_dir() {
    for dir in ${dirs_to_update[@]}; do
        echo "Updating $dir..."
        $rsync_cmd "$home/$dir" "$backup_drive"
    done
}
backup_home() {
    exclude_flags="$(echo ${sync[@]} ${update[@]} ${ignore[@]} \
                     | sed -e "s:[^ ]*:--exclude=${home}\/&:g")"    
    total_size="$(du -sb $exclude_flags "$home" | awk '{print $1}')"
    tar -pcf - $exclude_flags "$home" \
        | pv -s $total_size \
        | gzip > "$backup_drive/Backups/homedirE560_$(date +'%Y-%m-%d-%H-%M').tar.gz"
}
main(){
    mode="$1"
    case "$mode" in
        'backup') backup_home ;;
        'sync')   sync_dir    ;;
        'update') update_dir  ;;
        'all')    backup_home
                  sync_dir
                  update_dir
        ;;
        *) help && exit 1;;
    esac
}

main "$1"

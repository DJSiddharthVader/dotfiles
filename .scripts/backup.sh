#!/bin/bash
home="/home/sidreed"
backup_drive="/media/4tbdrive"
rsync_cmd="rsync -a --ignore-existing --info=progress2"
to_sync=(Apps CMU_MSCB Music Pictures)
to_update=(Games Documents Projects Reading ToOrganize Torrent)
to_ignore=(dotfiles)


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
    exclude_flags="$(echo ${to_sync[@]} ${to_update[@]} ${to_ignore[@]} | sed -e "s:[^ ]*:--exclude=${home}\/&:g")"    
    total_size="$(du -sb $exclude_flags "$home" | awk '{print $1}' 2> /dev/null)"
    tar -pcf - $exclude_flags "$home" \
        | pv -s $total_size \
        | gzip > "$backup_drive/Backups/homedirE560_$(date +'%Y-%m-%d-%H-%M').tar.gz"
}
main(){
    mode="$1"
    case "$mode" in
        'backup') backup ;;
        'sync'  ) sync   ;;
        'update') update ;;
        'all')    backup && sync && update ;;
        *) help && exit 1;;
    esac
}

main "$1"

#!/bin/bash

drive="/media/1tbdrive"
rsyncdirs=(Documents dotfiles Music Personal Pictures)
function rsyncBackup(){
    for dir in "${rsyncdirs[@]}"
    do
        echo $dir
        rsync -r \
              --info=progress2 \
              --human-readable \
              $HOME/$dir/ $drive/$dir
    done
}
function tarBackup(){
    backupfile="$drive/backups/backup_$(date +"%H:%M-%d-%m-%Y").tar.gz"
    sudo tar \
        -zpcf "$backupfile" \
        --exclude=$HOME/.cache \
        --exclude=$HOME/.steam \
        --exclude=$HOME/dotfiles\
        --exclude=$HOME/Music \
        --exclude=$HOME/Videos \
        --exclude=$HOME/Pictures \
        --exclude=$HOME/Personal \
        --one-file-system $HOME
#        --exclude=/media \
#        --exclude=/var/log \
#        --exclude=/var/cache/apt \
#        --exclude=/usr/src/linux-headers* \
}
function checkDrive(){
    mounts="$(lsblk | grep "$drive" | wc -l)"
    [ $mounts -ne 1 ] && \
    echo "Nothing mounted to $drive" && \
    exit 1
}
function main(){
    checkDrive
    mode="$1"
    case $mode in
        'both')
            tarBackup
            rsyncBackup
            ;;
        'rsync')
            rsyncBackup
            ;;
        'tar')
            tarBackup
            ;;
        *)
            echo "Usage $0 {both|rsync|tar}"
            exit 1
            ;;
    esac
    echo 'done'
}

main "$1"

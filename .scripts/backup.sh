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
              $HOME/$dir $drive/$dir
    done
}
function tarBackup(){
    backupfile="$drive/backups/backup_$(date +"%H:%M-%d-%m-%Y").tar.gz"
    tar -cvpzf "$backupfile" \
        --exclude=$HOME/dotfiles\
        --exclude=$HOME/.cache \
        --exclude=$HOME/Music \
        --exclude=$HOME/Videos \
        --exclude=$HOME/Pictures \
        --exclude=$HOME/Personal \
        --exclude=/media \
        --exclude=/var/log \
        --exclude=/var/cache/apt \
        --exclude=/usr/src/linux-headers* \
        --one-file-system /
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
            rsyncBackup
            tarBackup
            ;;
        'rsync')
            rsyncBackup
            ;;
        'tar')
            tarBackup
            ;;
        *)
            echo "Usage $0 {both|rsyn|tar}"
            exit 1
            ;;
    esac
    echo 'done'
}

main "$1"

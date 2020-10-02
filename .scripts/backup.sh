#!/bin/bash

# Vars
drive="/media/1tbdrive"
backupdir="$drive/BackUps"
snapshotfile="$drive/tar-snapshot.file"
rsyncdirs=(Documents dotfiles Games Music Projects Pictures)


function checkDrive(){
    mounts="$(lsblk | grep "$drive" | wc -l)"
    [ $mounts -ne 1 ] && \
    echo "Nothing mounted to $drive" && \
    exit 1
}
function rsyncBackup(){
    for dir in "${rsyncdirs[@]}"
    do
        echo $dir
        rsync -ur                   \
              --human-readable      \
              --info=progress2      \
              --delete              \
               $HOME/$dir/ $drive/$dir
    done
}
function tarBackup(){
    backupfile="$backupdir/backup_$(date +"%F").tar.bz2"
    sudo tar \
        --exclude=$HOME/.cache               \
        --exclude=$HOME/.steam               \
        --exclude=$HOME/Documents            \
        --exclude=$HOME/dotfiles             \
        --exclude=$HOME/Games                \
        --exclude=$HOME/Music                \
        --exclude=$HOME/Projects             \
        --exclude=$HOME/Pictures             \
        --exclude=$HOME/Videos               \
        --exclude=/media                     \
        --exclude=/var/log                   \
        --exclude=/var/cache/apt             \
        --exclude=/usr/src/linux-headers*    \
        --exclude=/swapfile                  \
        --listed-incremental="$snapshotfile" \
        -I pbzip2                            \
        -cvf "$backupfile"                  \
        --one-file-system /
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

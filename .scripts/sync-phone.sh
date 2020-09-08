#!/bin/bash

#Dirs
music_local="$HOME/Music/songs/everything"
music_phone="~/SDCard/Music/Songs"
notes_local="$HOME/Documents/Notes"
notes_phone="~/SDCard/Notes"
read_local="$HOME/Documents/Reading"
read_phone="~/SDCard/Reading"
pic_local="$HOME/Pictures/phone"
pic_phone="~/SDCard/{DCIM,Pictures}"

function sync_notes() {
    main_branch="laptop"
    phone_branch="phone"
    ip="$1"
    port="$2"
    # Update local changes
    cd $notes_local
    commit_msg="local changes on $(date)"
    git add -A
    git commit -am "$commit_msg" #commit local changes
    # Copy phone files in new branch
    git checkout -b $phone_branch #switch to tmp branch
    rsync --exclude="^.*"    \
          -e "ssh -p $port" \
          -r                \
          --human-readable  \
          --info=progress2  \
          "$ip:$notes_phone" ./
    # Resolve merge
    git merge $main_branch
    vim -p "$(git diff --name-only | uniq)"
    git add -A
    commit_msg="merge changes on $(date)"
    git commit -am "$commit_msg" #commit post merge changes
    #Sync to phone
    rsync --exclude=".*"    \
          -e "ssh -p $port" \
          -r                \
          --human-readable  \
          --info=progress2  \
          --delete          \
          ./ "$ip:$notes_phone/"
    git checkout "$main_branch"
    cd -
}
function syncdir() {
    ip="$1"
    port="$2"
    source="$3"
    dest="$4"
    mode="$5"
    case "$mode" in
        'merge')
            rsync -e "ssh -p $port" \
                  -r                \
                  -u                \
                  --human-readable  \
                  --info=progress2  \
                  $ip:$dest/ $source/
            rsync -e "ssh -p $port" \
                  -r                \
                  -u                \
                  --human-readable  \
                  --info=progress2  \
                  $source/ $ip:$dest/
            ;;
        'update')
            rsync -e "ssh -p $port"     \
                  -r                    \
                  --human-readable      \
                  --info=progress2      \
                  $source/ $ip:$dest/
            ;;
        'source')
            rsync -e "ssh -p $port"     \
                  -r                    \
                  --human-readable      \
                  --info=progress2      \
                  --delete              \
                  $source/ $ip:$dest/
            ;;
        'dest')
            rsync -e "ssh -p $port"     \
                  -r                    \
                  --human-readable      \
                  --info=progress2      \
                  --delete              \
                  $ip:$dest/ $source/
            ;;
        *)
            echo 'invalid mode, use {merge|update|source|dest}'
            ;;
    esac
}
function main() {
    ip="$1"
    port="$2"
    echo Music
    syncdir $ip $port $music_local $music_phone source
    echo Reading
    syncdir $ip $port $read_local $read_phone source
    echo Pictures
    syncdir $ip $port $pic_local $pic_phone merge
    echo Notes
    rsync -qr --delete $notes_local/ "$notes_local"_Backup/
    sync_notes $ip $port
    #syncdir $ip $port $notes_local/ $notes_phone merge
}

#Args
if [[ $# -eq 0 ]];then
    ip='10.0.0.229'
    port=2222
else
    ip="$1"
    port="$2"
fi
#sync_notes "$ip" "$port"
main "$ip" "$port"

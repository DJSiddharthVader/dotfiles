#!/bin/bash

#Dirs
music_local="$HOME/Music/songs/everything/"
music_phone="~/SDCard/Music/Songs/"
read_local="$HOME/Documents/Reading/"
read_phone="~/SDCard/Reading/"
notes_local="$HOME/Documents/Notes"
notes_phone="~/SDCard/Notes/"
pic_local="$HOME/Pictures/phone/"
pic_phone="~/SDCard/{DCIM/,Pictures/}"

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
                  --append           \
                  --human-readable  \
                  --info=progress2  \
                  $ip:$dest $source
            rsync -e "ssh -p $port" \
                  -r                \
                  --append           \
                  --human-readable  \
                  --info=progress2  \
                  $source $ip:$dest
            ;;
        'update')
            rsync -e "ssh -p $port"     \
                  -r                    \
                  --human-readable      \
                  --info=progress2      \
                  $source $ip:$dest
            ;;
        'source')
            rsync -e "ssh -p $port"     \
                  -r                    \
                  --human-readable      \
                  --info=progress2      \
                  --delete              \
                  $source $ip:$dest
            ;;
        'dest')
            rsync -e "ssh -p $port"     \
                  -r                    \
                  --human-readable      \
                  --info=progress2      \
                  --delete              \
                  $ip:$dest $source
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
    echo Notes
    cp -r $notes_local "$notes_local"_Backup
    syncdir $ip $port $notes_local/ $notes_phone merge
    echo Reading
    syncdir $ip $port $read_local $read_phone source
    echo Pictures
    syncdir $ip $port $pic_local $pic_phone merge
}

#Args
if [[ $# -eq 0 ]];then
    ip='10.0.0.229'
    port=2222
else
    ip="$1"
    port="$2"
fi
main "$ip" "$port"

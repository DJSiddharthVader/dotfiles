#!/bin/bash

#Dirs
music_local="$HOME/Music/songs"
music_phone="~/SDCard/Music/Songs"
notes_local="$HOME/Documents/Notes"
notes_phone="~/SDCard/Notes"
read_local="$HOME/Documents/Reading"
read_phone="~/SDCard/Reading"
pic_local="$HOME/Pictures/phone"
pic_phone="~/SDCard/{DCIM,Pictures}"

#Defaults args
ip='10.0.0.229'
port=2222
notes_only='false'
rsync_args=("-r" "--human-readable" "--info=progress2")


function help(){
    echo "Usage: $0 \
            -i \$ip    #ip of target phone   \
            -p \$port  #port on target phone \
            -n #only sync notes to save time \
         "
    exit 1
}
function check_phone_open(){
    ip="$1"
    port="$2"
    nc -z "$ip" "$port"
    if [ "$?" = 1 ] ;then
        echo "Phone connection refused, exiting..."
        #exit 1
    fi
}
function sync_notes() {
    main_branch="laptop"
    remote_branch="phone"
    ip="$1"
    port="$2"
    rsync -rq --delete $notes_local/ ~/Archive/Notes/Local/
    rsync -e "ssh -p $port" --exclude=".*" "${rsync_args[@]}" "$ip:$notes_phone"/ ~/Archive/Notes/Phone/
    # Update local changes
    cd $notes_local
    git checkout $main_branch #switch to tmp branch
    git add -A && git commit -vam "local changes"
    # Copy phone files in new branch
    git checkout $remote_branch #switch to tmp branch
    rsync -e "ssh -p $port" --exclude=".*" "${rsync_args[@]}" "$ip:$notes_phone"/ ./
    # Resolve merge
    git add -A && git commit -vam "remote changes"
    git checkout $main_branch #switch to tmp branch
    git merge --no-commit -v $remote_branch
    diffs="$(git diff --name-only | uniq | tr '\n' ' ')"
    [[ ! -z "$diffs" ]] && vim -p $diffs
    git add -A && git commit -vam "merged changes"
    #Sync to phone
    rsync -e "ssh -p $port" --exclude=".*" --delete "${rsync_args[@]}" ./ "$ip:$notes_phone"/
    cd -
}
function sync_dir() {
    ip="$1"
    port="$2"
    source="$3"
    dest="$4"
    mode="$5"
    case "$mode" in
        'merge')
            rsync -e "ssh -p $port" "${rsync_args[@]}" -u $ip:$dest/ $source/
            rsync -e "ssh -p $port"  "${rsync_args[@]}" -u $source/ $ip:$dest/
            ;;
        'update')
            rsync -e "ssh -p $port" "${rsync_args[@]}" -u $source/ $ip:$dest/ ;;
        'source')
            rsync -e "ssh -p $port" "${rsync_args[@]}" --delete  $source/ $ip:$dest/ ;;
        'dest')
            rsync -e "ssh -p $port" "${rsync_args[@]}" --delete $ip:$dest/ $source/ ;;
        *)
            echo 'invalid mode, use {merge|update|source|dest}' ;;
    esac
}
function sync_all() {
    ip="$1"
    port="$2"
    echo Music
    sync_dir $ip $port $music_local $music_phone source
    echo Reading
    sync_dir $ip $port $read_local $read_phone source
    echo Pictures
    sync_dir $ip $port $pic_local $pic_phone merge
    echo Notes
    sync_notes $ip $port
    #sync_dir $ip $port $notes_local/ $notes_phone merge
}
function main() {
    #Args
    port="2222"
    while getopts 'i:np:' flag; do
        case "${flag}" in
            i) ip="${OPTARG}" ;;
            p) port="${OPTARG}" ;;
            n) notes_only='true' ;;
            *) help ;;
        esac
    done
    #[[ -z $ip ]] && ip="192.168.1.72"
    check_phone_open "$ip" "$port"
    if [ "$notes_only" = true ]; then
        sync_notes "$ip" "$port"
    else
        sync_all "$ip" "$port"
    fi
}

main "$@"

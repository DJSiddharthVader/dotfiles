#!/bin/bash

port=2222
#Dirs
musicindir="$HOME/Music/songs/everything/"
musicoutdir="~/SDCard/Music/Songs/"
picindir="~/SDCard/{DCIM/,Pictures/}"
picoutdir="$HOME/Pictures/phone/"


function syncdir() {
    indir="$1"
    outdir="$2"
    rsync -e "ssh -p $port"     \
          -r                    \
          --human-readable      \
          --info=progress2      \
          $indir $outdir
}
function main() {
    ip="$1"
    echo Music
    syncdir $musicindir $ip:$musicoutdir
    echo Pictures
    syncdir $ip:$picindir $picoutdir
}

[[ $# -eq 0 ]] && echo "Usage $0 {phone ip}" && exit 1
main "$1"

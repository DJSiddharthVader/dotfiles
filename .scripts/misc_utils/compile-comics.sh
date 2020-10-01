#!/bin/bash
digits=000

function padNumber(){
    num="$1"
    tmp="$digits$num"
    echo ${tmp:(-${#digits})}
}
function fixName(){
    #pads numbers in comic name
    #converts tower_of_god_1_1.jpg to tower_of_god_001_001.jpg
    image="$1"
    chapter="$(echo $image | rev | cut -d'_' -f 2 | rev)"
    new_chapter="$(padNumber $chapter)"
    panel="$(echo $image | rev | cut -d'_' -f 1 | rev | cut -d'.' -f1)"
    new_panel="$(padNumber $panel)"
    mv $image "$(dirname $image)"/tower_of_god_"$new_chapter"_"$new_panel".jpg
}
function makeChapter(){
    chapdir="$1"
    for file in $(ls $chapdir); do
        fixName "$chapdir/$file"
    done
    chapnum="$(echo $chapdir | cut -d'.' -f2)"
    padded="$(padNumber $chapnum)"
    rar a Chapter_"$padded".cbr $chapdir
}
function main(){
    for dir in $(ls);
    do
        makeChapter $dir
        echo $dir
    done
}
function CbzToCbr(){
    cbz="$1"
    unziped="${cbz%.*}"
    cbr="$unziped".cbr
    unzip $cbz -d "$unziped"
    rar a $cbr $unziped
    \rm -rf "$unziped" $cbz
}

#makeChapter "$1"
#main
CbzToCbr "$1"

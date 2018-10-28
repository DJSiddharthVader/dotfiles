#!/bin/sh
#Script to scroll song name of current mpd song in polybar

if ! mpc >/dev/null 2>&1; then
    echo Server offline
    exit 1
elif mpc status | grep -q playing; then
    ( zscroll -l 20 -d 0.30 -b "" -a "" -p " /// " -u true "mpc current"  | sed -e :a -ue 's/^.\{1,20\}$/& /;ta' | sed -uEn 's/(^.*$)/───|\1|───/p' ) &
    #( zscroll -l 20 -d 0.30 -b "" -a "" -p " /// " -u true "mpc current"  use zscroll to scroll the output of mpc current with /// as the delim between the end of text
    #| sed -e :a -ue 's/^.\{1,20\}$/& /;ta'#pad with space to be 20 chars if not
    #| sed -uEn 's/(^.*$)/───| \1|───/p' surround text in ───| |─── for asthetic
    #) & capture, run in background
elif mpc status | grep -q paused; then
    echo "───| Paused |───"
else
    echo "───| Stopped |───"
fi

mpc idle >/dev/null


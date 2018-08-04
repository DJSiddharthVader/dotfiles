#!/bin/sh

if ! mpc >/dev/null 2>&1; then
    echo Server offline
    exit 1
elif mpc status | grep -q playing; then
    #( mpc current  | zscroll -l 20 -d 0.30 -b " " -a " " -p " " | sed -e :a -ue 's/^.\{1,20\}$/& /;ta'| sed -uEn 's/(^.*$)/───|\1|───/p' ) &
    ( zscroll -l 20 -d 0.30 -b "" -a "" -p " /// " -u true "mpc current"  | sed -e :a -ue 's/^.\{1,20\}$/& /;ta'| sed -uEn 's/(^.*$)/───| \1|───/p' ) &
    #( mpc current | sed -e :a -ue 's/^.\{1,20\}$/& /;ta' | sed -uEn 's/(^.*$)/───| \1 |───/p' | zscroll -l 20 -d 0.25 -p " " ) &
elif mpc status | grep -q paused; then
    echo "───| Paused |───"
    #echo "   Paused   "
else
    echo "───| Stopped |───"
    #echo "Not playing"
fi
# Block until an event is emitted
mpc idle >/dev/null


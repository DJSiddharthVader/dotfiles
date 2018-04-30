#!/bin/sh

walp=~/Pictures/Pics/`ls  ~/Pictures/Pics | shuf -n 1`
wal -i $walp
feh --bg-scale $walp --bg-scale $walp

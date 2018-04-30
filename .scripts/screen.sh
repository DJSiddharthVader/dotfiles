#!/bin/bash

#Feed this script either:
#	"l" for laptop screen only,
#	"v" for vga screen only,
#	or "d" for dual vga/laptop.

#d() { if [[ $(xrandr -q | grep DP-2\ con)  ]]
#	then vdual
#    elif [[ $(xrandr -q | grep HDMI-1\ con ) ]]
#    then param hdual
#	else echo "No input detected."
#	fi ;}
#hdual() { xrandr --output eDP-1 --auto --output HDMI-1 --auto --right-of eDP-1;}
#vdual() { xrandr --output eDP-1 --auto --output DP-2 --auto --right-of eDP-1;}
#laptop() { xrandr --output LVDS1 --auto --output VGA1 --off ;}
#vga() { xrandr --output VGA1 --auto --output LVDS1 --off ;}
#hdmi() { xrandr --output VGA1 --auto --output LVDS1 --off ;}
##mirror() { xrandr --addmode VGA1 $lapres && xrandr --output LVDS1 --mode $lapres --output VGA1 --mode $lapres ;}
#
#param() {
#case $1 in
#	h) hdual ;;
#	v) vdual ;;
#	l) laptop ;;
#	*) echo -e "Invalid parameter. Add one of the following:\n\"d\" for dualscreen laptop and VGA.\n\"l\" for laptop only\n\"v\" for VGA only." ;;
#esac ;}
#d $1

m=$(xrandr --query | grep " connected" | cut -d" " -f1 | tail -1);
if [ $m != 'eDP-1' ];
then
    echo $m
    xrandr --output eDP-1 --auto --output $m --auto --right-of eDP-1;
fi

#!/bin/bash

#Ramp icons
ramp0=""
ramp1=""
ramp2=""


function showTemp() {
    temp=$(sensors | grep Core | sed -e 's/ \{2,\}/ /g' | cut -d' ' -f3 | tr -d '+' |  head -1 )
    echo $temp
}
function showIcon() {
    temp=$(showTemp | tr -dc '[:digit:].' | cut -d'.' -f1)
    case 1 in
        $(($temp <= 40)))
            icon=$ramp0
            ;;
        $(($temp <= 50)))
            icon=$ramp1
            ;;
        $(($temp <= 60)))
            icon=$ramp2
            ;;
    esac
    echo "$icon"
}
function main(){
    temp="$(showIcon) $(showTemp)"
    echo $temp
}

main

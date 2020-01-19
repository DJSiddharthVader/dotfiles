#!/bin/bash

mode_file="$HOME/dotfiles/.varfiles/cpumode"

function short() {
    mpstat -P ALL 1 1 | grep "Average: *all" | sed -e 's/ \{1,\}/\t/g' | cut -f3 | sed -uEn 's/(^[0-9]*)\..*$/0\1/p' | grep -o '..$' | sed -uEn 's/(^.*$)/  \1\%/p'
}
function long() {
    mpstat -P ALL 1 1 | awk '/Average:/ && $2 ~ /[0-9]/ {print $3}' | sed -uEn 's/(^[0-9]*)\..*$/0\1\%/p' | grep -o '...$' | tr '\n' ' ' | sed -E 's/(^.*$)/  \1/'
#mpstat -P ALL 1 1 | #get cpu loads
#awk '/Average:/ && [ ~ /[0-9]/ {print {}' | #magic to get only load values
#sed -uEn 's/(^[0-9]*)\..*$/0\1\%/p' | #trim decimals, pad 0 if < 10, add % after
#tr '\n' ' ' # join lines togethre
}
function cpuLoad() {
    mode="$1"
    case $mode in
        'short')
            short
            ;;
        'long')
            long
            ;;
        *)
            echo "Usage $0 {short|long}"
            exit 1
            ;;
    esac
}
function main() {
    mode="$1"
    case $mode in
        'short')
            echo 'short' >| $mode_file
            ;;
        'long')
            echo 'long' >| $mode_file
            ;;
        'toggle')
            mode="$(cat $mode_file)"
            if [[ $mode == "short" ]]; then
                echo 'long' >| $mode_file
            else
                echo 'short' >| $mode_file
            fi
            ;;
        '')
            sleep 0.001
            ;;
        *)
            echo "Usage $0 {toggle|short|long}"
            exit 1
            ;;
    esac
    mode="$(cat $mode_file)"
    cpuLoad $mode
}

main "$1"


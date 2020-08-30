#!/bin/bash
task_file="$HOME/Documents/Notes/tasks/tasks"
mode_file="$HOME/dotfiles/.varfiles/taskmode"
#Task Icons
#task_icon="Tasks"
#task_icon=""
#task_icon=""
#task_icon=""
task_icon=""

#Task Seperators
#task_seperator=" "
#task_seperator="|"
#task_seperator=""
#task_seperator=""
#task_seperator=""
task_seperator="  "


function short() {
    total=$(wc -l "$task_file" | cut -d" " -f1)
    out="$task_icon $total"
    echo $out
}
function long() {
    task_categories=$(cut -d':' -f1 "$task_file" | sort | uniq -c | sort -rn )
    total=$(wc -l "$task_file" | cut -d" " -f1)
    out="$task_icon $total"
    while read -r task_count; do
        catagory=$(echo "$task_count" | cut -d' ' -f2)
        count=$(echo "$task_count" | cut -d' ' -f1)
        out+="$task_seperator $catagory:$count"
    done <<< "$task_categories"
    echo "$out"
}
function display(){
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
    display $mode
}

main "$1"

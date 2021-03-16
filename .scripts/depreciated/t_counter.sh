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

help() { echo "Error: usage ./$(basename $0) {display|next|prev|$(echo ${modes[*]} | tr ' ' '|')}" ; }
cycle() {
    # cycle through modes either forwards or backwards
    # get index of current mode in the modes array, find index for next/previous mode and get the array value of that index and echo it
    # next mode index is:  (x+1) % n
    # prev mode index is:  (x+n-1) % n
    # x is current mode index, n is number of modes
    dir="$1"
    mode="$(cat $mode_file)"
    idx="$(echo "${modes[*]}" | grep -o "^.*$mode" | tr ' ' '\n' | wc -l)"
    idx=$(($idx -1)) #current mode idx
    case "$dir" in
         'next') idx=$(($idx + 1)) ;;
         'prev') idx=$(($idx +${#modes[@]} -1)) ;;
         *) echo "Error cycle takes {next|prev}" && exit 1 ;;
    esac
    next_idx=$(($idx % ${#modes[@]})) #modulo to wrap back
    echo "${modes[$next_idx]}"
}

total() { wc -l "$task_file" | cut -d" " -f1 ; }
long() {
    task_categories=$(cut -d':' -f1 "$task_file" | sort | uniq -c | sort -rn )
    out="$task_icon $(total)"
    while read -r task_count; do
        catagory=$(echo "$task_count" | cut -d' ' -f2)
        count=$(echo "$task_count" | cut -d' ' -f1)
        out+="$task_seperator $catagory:$count"
    done <<< "$task_categories"
    echo "$out"
}
function display(){
    mode="$(cat $mode_file)"
    case $mode in
        'short') "$task_icon $(total)" ;;
        'long') long ;;
        *) help && exit 1 ;;
    esac
}
main() {
    mode="$1"
    if [[ "$mode" == 'display' ]]; then
        display
    else
        tmp="@($(echo ${modes[*]} | sed -e 's/ /|/g'))"
        case "$mode" in
            'next') dmode="$(cycle 'next')" ;;
            'prev') dmode="$(cycle 'prev')" ;;
            $tmp  ) dmode="$mode" ;; #capture any valid mode
            *) help && exit 1 ;;
        esac
        echo "$dmode"  >| "$mode_file"
    fi
}

main "$1"

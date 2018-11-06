#!/bin/bash

tskfile=~/dotfiles/tasks/tasks
task_cats=$(grep -o -P '^.*?:' "$tskfile" | sort -u)
total=$(cat "$tskfile" | wc -l)
outp="Tasks:$total|"
while read -r catg; do
    count=`grep "^$catg" "$tskfile" | wc -l | cut -d' ' -f2`
    outp+="$catg$count|"
done <<< "$task_cats"
echo "${outp::-1}|"

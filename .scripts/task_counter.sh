#!/bin/bash

tskfile=~/dotfiles/tasks/tasks
task_cats=$(grep -o -P '^.*?:' "$tskfile" | sort -u)
#echo "$task_cats"
outp='Tasks |'
while read -r catg; do
    count=`grep "^$catg" "$tskfile" | wc -l`
    outp+="$catg$count|"
done <<< "$task_cats"
echo "${outp::-1}|"

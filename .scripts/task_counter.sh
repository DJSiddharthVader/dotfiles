#!/bin/bash
tskfile="$HOME/dotfiles/tasks/tasks"
task_cats=$(cut -d':' -f1 "$tskfile" | sort | uniq -c | sort -n)
total=$(wc -l "$tskfile" | cut -d" " -f1)
outp="Tasks:$total|"
while read -r catg; do
    catg=$(echo "$catg" | cut -d' ' -f2)
    count=$(grep -c "^$catg" "$tskfile" | cut -d' ' -f2)
    outp+="$catg:$count|"
done <<< "$task_cats"
echo "${outp::-1}|"

#tskfile=~/dotfiles/tasks/tasks
#task_cats=$(cat "$tskfile" | cut -d':' -f1 | sort | uniq -c | sort -n)
#total=$(cat "$tskfile" | wc -l)
#outp="Tasks:$total|"
#while read -r catg; do
#    catg=`echo "$catg" | cut -d' ' -f2`
#    count=`grep "^$catg" "$tskfile" | wc -l | cut -d' ' -f2`
#    outp+="$catg:$count|"
#done <<< "$task_cats"
#echo "${outp::-1}|"

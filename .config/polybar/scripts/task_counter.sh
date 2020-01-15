#!/bin/bash
task_file="$HOME/Personal/notes/tasks/tasks"
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


task_categories=$(cut -d':' -f1 "$task_file" | sort | uniq -c | sort -n)
total=$(wc -l "$task_file" | cut -d" " -f1)
out=" $task_icon $total$task_seperator"
while read -r task_count; do
    catagory=$(echo "$task_count" | cut -d' ' -f2)
    count=$(echo "$task_count" | cut -d' ' -f1)
    out+="$catagory:$count$task_seperator"
done <<< "$task_categories"
echo "${out::-2} $task_icon"


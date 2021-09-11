#!/bin/bash

mat_dir="Materials"

# unzip
zip="$1"
unzip "$zip" > /dev/null
mv "$zip" ./zips
dir="${zip%.zip}"
cd "$dir"
# move code
mv ./Finished\ Code/* ../go_src/finished_code
mv ./Starter\ Code/* ../go_src/starter_code
# make
name="$(echo $dir | rev | cut -d'-' -f1 | rev | sed -e 's/^ *\(.*\) *$/\1/' | tr ' ' '_')"
num="$(ls ../$mat_dir | wc -l)"
num="$(printf %02d $num)"
rec_dir="../$mat_dir/R$num-$name"
mkdir "$rec_dir"
# convert all files to pdf
find . -maxdepth 2 -type f -print0 |
    while IFS= read -r -d '' line; do
        file="$line"
        name=${file%.*}
        ext=${file##*.}
        case "$ext" in
            docx) pandoc "$file" -s -o "$name.pdf" ;;
            pptx) libreoffice6.0 --convert-to pdf "$file" ;;
            *) mv "$files" $rec_dir ;;
        esac
    done
mv *.pdf $rec_dir
#find ./ -maxdepth 1 -type d -exec mv {} "$rec_dir" \;
cd .. && \rm -rf "$dir"

#!/bin/bash
#$1 is new repor name
#$2 is a one sentence description in single quotes

mkdir -p "$1"
#curl -u 'DJSIddharthVader' https://api.github.com/user/repos -d '{"name":"$1"}'
cd "$1"
#git init
#cat "$2"  > README.md
#git add README.md
#git commit -m "first commit"
originurl="https://github.com/DJSiddharthVader/$1"
echo "$originurl"
#git remote add origin "$originurl"
#git push -u origin master

search="github.com"
replace="DJSiddharthVader@github.com"
sed -i -e "s/$search/$replace/" ./.git/config
cat ./.git/config



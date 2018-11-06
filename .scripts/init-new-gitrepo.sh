#!/bin/bash
#$1 is new repor name
#$2 is a one sentence description in single quotes

user='DJSIddharthVader'

mkdir -p "$1"
dflag='{"name":'"\"$1\""}
#curl -u "$user" https://api.github.com/user/repos -d "$dflag"
echo "curl -u $user https://api.github.com/user/repos -d $dflag"
cd "$1"

git init
search="github.com"
replace="$user@github.com"
sed -i -e "s/$search/$replace/" ./.git/config

echo "$2" > README.md
git add README.md
git commit -m "first commit"

originurl="git@github.com:$user/$1.git"
git remote add origin "$originurl"
git push -u origin master

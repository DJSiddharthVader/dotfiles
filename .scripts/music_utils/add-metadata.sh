#!/bin/bash

source "$HOME/dotfiles/.scripts/music_utils/variables.sh"
credentials="$HOME/dotfiles/.varfiles/discogs.credentials"
api_url="https://api.discogs.com/database/search"
feature_patterns_title='(featuring|feat\.|ft\.| ft | feat | w\/ )'
feature_patterns='(featuring|feat\.|ft\.| ft | feat | w\/ | x | & )'


function usage(){
    echo "
Usage $0 { parallel | iter |\$ARGS[@]}

   parallel: runs gnu parallel to for all songs in music dir
   iter:     run on a single input file
   \$FILE:    run on a single input file
   \$ARGS[@]: list of file(s) to run, uses debug function to print information
" && exit 0
}
function deleteParens(){
     sed -E 's/\(.*\)//' | sed -E 's/\[.*\]//'
}
function trimCharacters() {
    tr '~' '-' | tr -d "'" | tr -cd '[:print:]' | sed -E 's/(lyrics|official|music|video|audio)//gi'
}
function trimSpaces(){
    sed -E 's/ {2,}/ /' | sed -E 's/^ //' | sed -E 's/ $//'
}
function capitalizeWords() {
    tr '[:upper:]' '[:lower:]' \
        | sed -E "s/([0-9 \.\$\/\-])(.)/\1\u\2/g" \
        | sed -E "s/^(.)/\u\1/g"
}
function formatString() {
    trimCharacters | deleteParens | capitalizeWords | trimSpaces
}

function getVideoTitle(){
    songfile="$1"
    basename "$songfile" | perl -pe 's/^(.+?)__.*$/\1/'
}
function getTitle(){
    songfile="$1"
    #basename "$songfile" | perl -pe  "s/^.+? - (.+)__.*__.*$/\1/"   \
    basename "$songfile" | perl -pe  "s/^.+?( -|- )(.+)__.*__.*$/\2/" \
                         | sed -E 's/#.*$//'                          \
                         | sed -E "s/$feature_patterns_title.*$//i"   \
                         | sed -E "s/ *_ */\//"                       \
                         | sed -E "s/ - .*//"                         \
                         | formatString
}
function getArtist(){
    songfile="$1"
    mode="$2"
    case $mode in
        'short') patterns="$feature_patterns" ;;
        #'long') patterns='(featuring|feat\.|ft\.)' ;;
        'long') patterns="$feature_patterns_title" ;;
    esac
    #basename "$songfile" | perl -pe  's/^(.+?) - .+$/\1/' \
    basename "$songfile" | perl -pe  's/^(.+?)( -|- ).+$/\1/' \
                         | sed -E "s/$patterns.*$//i"   \
                         | sed -E 's/( and | X | \+ |, )/ \& /i'   \
                         | formatString
}
function getComment(){
    songfile="$1"
    basename "$songfile" | perl -pe "s/^.+?__([0-9]{1,})__(.*)\.$format$/\1,\2/"
}
function _getFeatures(){
    echo "$1" \
        | perl -pe "s/^.*?$feature_patterns_title(.*$)/\2/i" \
        | perl -pe  's/^(.+?) -.+$/\1/' \
        | sed -E 's/ (\&|and) /, /i'  \
        | tr -d "()" | tr -d '(' | sed 's/ ( //' \
        | formatString
}
function getFeatures(){
    songfile="$1"
    #title="$(getVideoTitle "$songfile" | perl -pe  "s/^.+? - (.+)__[0-9]{3,}__.*$/\1/")"
    title="$(getVideoTitle "$songfile" | perl -pe  "s/^.+?( -|- )(.+)__[0-9]{3,}__.*$/\2/")"
    shopt -s nocasematch
    if [[ "$title" =~ $feature_patterns_title ]]; then
        _getFeatures "$title"
    else
        echo "" #no featured/collaborator artists
    fi
    shopt -u nocasematch
}
function getGenreCode(){
    genre="$(echo "$1" | sed -E 's/Hip Hop/Hip-Hop/')"
    if [[ -z "$genre" ]]; then
       code="None"
    else
        #id3v2 uses numbers, so get number matcing genre from spotify
        code="$(id3v2 -L | grep "$genre" | head -1 | cut -d':' -f1)"
    fi
    echo "$code"
}

function getSongData(){
    songfile="$1" #file with name specified by $youtubedl_format_str
    token="$(cat $credentials | grep "Token" | cut -d':' -f2)"
    header="Authorization: Discogs token=$token"
    artist="$(getArtist "$songfile" 'long' | sed -E 's/ x / \& /i')"
    title="$(getTitle "$songfile")"
    url="$(echo "$api_url?q=$artist&track=$title" | tr ' ' '+' | tr '_' '/' | tr -d "\'" )"
    datafile="$(mktemp song_data.XXXXXXXXXX)"
    trap "rm -rf $datafile" EXIT
    curl -s "$url" -H "$header" | tail -1 > "$datafile"
    sleep 5 #since request is being made
    ~/dotfiles/.scripts/music_utils/parse_discog_json.py "$datafile" "$artist" "$title"
}
function getTagValue(){
    data="$1"
    field="$2"
    case $field in
        'title')  value="$(echo "$data" | awk -F'__' '{print $1}')" ;;
        'artist') value="$(echo "$data" | awk -F'__' '{print $2}')" ;;
        'album')  value="$(echo "$data" | awk -F'__' '{print $3}')" ;;
        'year')   value="$(echo "$data" | awk -F'__' '{print $4}')" ;;
        'genre')  value="$(echo "$data" | awk -F'__' '{print $5}')"
                  value="$(getGenreCode "$value")" ;;
        *) echo "invalid metadata field $field" && exit 1 ;;
    esac
    echo "$value" | formatString
}
function setSongTag(){
    file="$1" #file with name specified by $youtubedl_format_str
    field="$2"
    value="$3"
    case $field in
        'title')   id3v2 -t "$value" "$file" ;;
        'artist')  id3v2 -a "$value" "$file" ;;
        'album')   id3v2 -A "$value" "$file" ;;
        'year')    id3v2 -y "$value" "$file" ;;
        'genre')   id3v2 -g "$value" "$file" ;;
        'comment') id3v2 -c "$value" "$file" ;;
        'track')   id3v2 -T "$value" "$file" ;;
        *) echo "invalid metadata field $field" && exit 1 ;;
    esac
}
function completeSongData(){
    songfile="$1"
    data="$(getSongData "$songfile")"
    title="$(getTagValue "$data" 'title')"
    features="$(getFeatures "$songfile")"
    [[ -z "$features" ]] || title="$title ft. $features"
    setSongTag "$songfile" 'title'   "$title"
    setSongTag "$songfile" 'artist'  "$(getTagValue "$data" 'artist')"
    setSongTag "$songfile" 'comment' "$(getComment "$songfile")"
    if ! [[ "$data" =~ "no_results" ]]; then
        setSongTag "$songfile" 'album' "$(getTagValue "$data" 'album')"
        setSongTag "$songfile" 'year'  "$(getTagValue "$data" 'year')"
        setSongTag "$songfile" 'genre' "$(getTagValue "$data" 'genre')"
        #setSongTag "$songfile" 'track'
    fi
}
function main_parallel(){
    echo 'Adding metadata in parallel...'
    find -L "$music_dir" -maxdepth 1 -type f -name '*.mp3' \
        | parallel --max-args=1 --jobs 4 --bar \
                  "$script_dir"/add-metadata.sh 'iter' {}
}

function makeURL() {
    songfile="$1" #file with name specified by $youtubedl_format_str
    token="$(cat $credentials | grep "Token" | cut -d':' -f2)"
    header="Authorization: Discogs token=$token"
    artist="$(getArtist "$songfile" 'long' | sed -E 's/ x / \& /i')"
    title="$(getTitle "$songfile")"
    url="$(echo "$api_url?q=$artist&track=$title&token=$token" | tr ' ' '+' | tr '_' '/')"
    echo "$url"
}
function printMetadata(){
    title="$1"
    metadata="$2"
    #mediainfo "$songfile" | awk '/^General$/,/^Audio$/' | grep -P '(Album|Track|Performer|Genre|Comment|Recorded Date)'
    cats="Title:  \nArtist: \nAlbum:  \nYear:   \nGenre:  "
    values="$(echo "$metadata" | sed -E 's/__/\n/g' | tail -n+3 | sed -E 's/$/-/')"
    paste <(echo -e "$cats") <(echo -e "$title-\n$values") --delimiters ''
    echo '--------------------------------'
}
function debugSongData(){
    songfile="$1"
    data="$(getSongData "$songfile" "$datafile")"
    title="$(getTagValue "$data" 'title' | sed 's/[()]//g' | formatString )"
    features="$(getFeatures "$songfile")"
    artist="$(getArtist "$songfile" 'long')"
    [[ -z "$features" ]] || title="$title ft. $features"
#    echo "$(getArtist "$songfile" 'long')"
#    echo "$(getTitle "$songfile")"
#    url="$(makeURL "$songfile")"
##    echo "$url"
#    curl -s "$url" | jq . | head -50 >| discog.json
#    echo "$title"
    setSongTag "$songfile" 'title'   "$title"
    setSongTag "$songfile" 'artist'  "$artist"
    setSongTag "$songfile" 'comment' "$(getComment "$songfile")"
    if ! [[ "$data" =~ "no_results" ]]; then
        setSongTag "$songfile" 'album' "$(getTagValue "$data" 'album')"
        setSongTag "$songfile" 'year'  "$(getTagValue "$data" 'year')"
        setSongTag "$songfile" 'genre' "$(getTagValue "$data" 'genre')"
        #setSongTag "$songfile" 'track'
    fi
    printMetadata "$title-\n$artist" " $data"
}

if (( $# < 1 )); then
    usage
elif [[ "$1" == 'parallel' ]]; then
    main_parallel #doesnt work
elif [[ "$1" == 'iter' ]]; then
    completeSongData "$2"
else
    for file in "$@"; do
        debugSongData "$file"
    done
fi


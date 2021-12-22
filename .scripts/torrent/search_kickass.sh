#!/bin/bash
# set -euo pipefail
shopt -s extglob

# BASE_URL="https://katcr.to"
# BASE_URL="https://kat2.xyz"
BASE_URL="https://thekat.info"
BASE_SEARCH_URL="$BASE_URL/usearch"
BASE_RESULT_URL="$BASE_URL"

USER_AGENT="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"

help() {
    echo "Usage: ./$(basename $0) query max_pages"
}
get_results() {
    # download the search results for a torrent query from 1337x.to
    query="${1:-}"
    max_pages="${2:-}"
    total_pages=$max_pages
    for page_num in $(seq 1 $total_pages); do
        search_url="$BASE_SEARCH_URL/${query// /%20}/$page_num/"
        echo "$search_url" 1>&2
        curl -Ss -A "$USER_AGENT" "$search_url" 
    done
}
extract_from_page() {
    grep -A1 '^ *<td class=.*center' "${1:-}" \
         | sed -e 's/<[^<>]*>//g' \
         | tr '\n' '\t' \
         | sed -e 's/[\t \r]*--[\t \r]*/\n/g' 
}
get_magnets() {
    grep 'Torrent magnet link' "${1:-}" \
         | sed -e 's/^.*href="https:\/\/mylink.cx\/?url=\([^ ]*\)".*$/\1/' \
               -e 's/%25/%/g' \
               -e 's/%26/\&/g' \
               -e 's/%3A/:/g' \
               -e 's/%3D/=/g' \
               -e 's/%3F/?/g'
}
parse_results() {
    # parse downloaded torrent results into a tab delimited table for display
    page="${1:-}"
    links="$(get_magnets "$page")"
    names="$(grep -A4 "torrentname" $page \
             | grep "cellMainLink" \
             | sed -e 's/<[^<>]*>//g')"
    data="$(extract_from_page "$page")"
    paste <(echo "$links") <(echo "$data") <(echo "$names")
}
main() {
    query="${1:-}"
    max_pages="${2:-}"
    results="$(mktemp)"
    get_results "$query" "$max_pages" >| "$results"
    parse_results "$results" | grep -vi 'xxx\|Porn\|N/A'
}

[[ $# -eq 2 ]] || (help && exit 1)
query="${1:-}"
max_pages="${2:-}"
main "$query" "$max_pages"

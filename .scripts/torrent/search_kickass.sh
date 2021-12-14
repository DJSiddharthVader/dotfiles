#!/bin/bash
# set -euo pipefail
shopt -s extglob

# BASE_URL="https://katcr.to"
BASE_URL="https://kat2.xyz"
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
        search_url="$BASE_URL/usearch/${query// /%20}/$page_num/"
        # search_url="$BASE_URL/usearch/${query// /+}/$page_num/"
        echo "$search_url"
        curl -Ss -A "$USER_AGENT" "$search_url" 
    done
}
# get_magnet() {
#     page="${1:-}"
#     curl -Ss -A "$USER_AGENT" "$page" |\
#               grep 'Magnet link' | head -1 |\
#               sed -e 's/^.*href="\(magnet[^"<>]*\)".*$/\1/'
# }
# get_magnets() {
#     page="${1:-}"
#     links="$(grep -A1 "torrentname" "$page" | grep href |\
#              sed -e 's/^.*href="\(.*\.html\).*$/\1/')"
#     magnets=""
#     while read link; do
#         magnet="$(get_magnet "$BASE_URL/$link")"
#         [[ -n "$magnet" ]] && magnets="$magnets$magnet\n"
#     done <<< "$(echo $links | tr ' ' '\n')"
#     echo "$magnets"
# }
get_magnets() {
    grep 'Torrent magnet link' "${1:-}" |\
         sed -e 's/^.*href="https:\/\/mylink.cx\/?url=\([^ ]*\)".*$/\1/'
}
extract_from_page() {
    grep -A1 '^ *<td class=.*center' "${1:-}" |\
         sed -e 's/<[^<>]*>//g' |\
         tr '\n' '\t' |\
         sed -e 's/[\t \r]*--[\t \r]*/\n/g' 
}
parse_results() {
    # parse downloaded torrent results into a tab delimited table for display
    page="${1:-}"
    links="$(get_magnets "$page")"
    names="$(grep -A4 "torrentname" $page |\
             grep "cellMainLink" |\
             sed -e 's/<[^<>]*>//g' |\
             cut -c -60)"
    data="$(extract_from_page "$page")"
    paste <(echo "$links") <(echo "$names") <(echo "$data")
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

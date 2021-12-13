#!/bin/bash
set -euo pipefail
shopt -s extglob

help() {
    echo "Usage: ./$(basename $0) query max_pages"
}
get_results() {
    # download the search results for a torrent query from 1337x.to
    query="${1:-}"
    max_pages="${2:-}"
    # search_url="https://katcr.to/usearch/${query// /%20}/"
    # total_pages="$(curl -Ss "$search_url" | grep 'Last' | sed -s 's/^.*class=.last.><a href=.\/search\/.*\/\([0-9]*\)\/.>.*$/\1/')"
    # [[ $max_pages -lt $total_pages ]] && total_pages=$max_pages
    total_pages=$max_pages
    for page_num in $(seq 1 $total_pages); do
        search_url="https://katcr.to/usearch/${query// /%20}/$page_num/"
        curl -Ss "$search_url" 
    done
}
extract_from_page() {
    grep -A1 '^ *<td class=.*center' "${1:-}" |\
         grep -v '^ *<td' |\
         sed -e 's/<[^<>]*>//g' |\
         tr '\n' '\t' | 
         sed -e 's/[\t \r]*--[\t \r]*/\n/g' 
}
get_magnet(){
    curl -Ss "${1:-}" |\
         grep 'Magnet link' | head -1 |\
         sed -e 's/^.*href="\(magnet[^"<>]*\)".*$/\1/'
}
get_magnets(){
    links="$(grep "Download torrent file" "${1:-}" |\
             sed -e 's/^.*href="\/download\/\(.*\.html\).*$/\1/')"
    echo "$links" 1>&2
    magnets=""
    while read link; do
        magnet="$(get_magnet "https://katcr.to/$link")"
        [[ -n "$magnet" ]] && magnets="$magnets$magnet\n"
    done <<< "$(echo $links | tr ' ' '\n')"
    echo "$magnets"
}
parse_results() {
    # parse downloaded torrent results into a tab delimited table for display
    page="${1:-}"
    links="$(get_magnets "$page")"
    names="$(grep '<strong class=' "$page" | sed -e 's/<[^<>]*>//g')"
    data="$(extract_from_page "$page")"
    paste <(echo "$links") <(echo "$names") <(echo "$data" | cut -f1,3-)
}
main() {
    query="${1:-}"
    max_pages="${2:-}"
    results="$(mktemp)"
    get_results "$query" "$max_pages" >| "$results"
    parse_results "$results" | grep -v 'Porn' | cut -f2- 
}

[[ $# -eq 2 ]] || (help  && exit 1)
query="${1:-}"
max_pages="${2:-}"
main "$query" "$max_pages"

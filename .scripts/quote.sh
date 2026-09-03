#!/bin/bash
# Data
# all quotes start with " and have an author on the next line, no other lines should start with a "
# quote_files=(~/.varfiles/quotes.md ~/.varfiles/quotes.txt)
# quote_files=('/home/vizier/Documents/Vizier\'s Codex/Thinkies/Quotes.md')
quote_file="/home/vizier/Documents/Vizier's Codex/Thinkies/Quotes.md"
# dir with ascii art for various thinkers
thinker_dir="$HOME/dotfiles/.ascii/thinkers" 
# Default Args
colwrap=50
border_string="(~)~"
thinker_line_offset=10
thinker_line=3

help() {
    thinker_list="$(find $thinker_dir -type f -name "*.ascii" -exec basename {} \; | cut -d'.' -f1 | tr '\n' '|' | sed -e 's/|$//' )"
    echo "Print a quote and something thinking it (basically fortune | cowsay)
Usage: $0 [OPTIONS]
        -p      print only the random quote (plain)
        -q      quote (string, defualt is random from ${quote_file})
        -c      column wrap width for quote text (int, default $colwrap)
        -b      border string specifiying bubble boundaries (left top right bottom, no spaces, default is '$border_string')
        -o      thinker offset from left side (float in [0,1], default is $thinker_line_offset)
        -l      length of diagonal line connecting thinker to text box (int, default is $thinker_line)
        -t      thinker ascii art (file, defualt is random file from $thinker_dir)
                possible thinkers are {$thinker_list} or any filepath
        -h      print this message"
}

random_quote() {
    # pick random quote from local files
    quote="$(cat "${quote_file}" | grep '^"' | shuf -n1 | tr -d '"')"
    author="$(cat "${quote_file}" | grep -A1 "$quote" | tail -1 )"
    if [[ -z $author ]]; then
        echo "$quote"
    else
        echo "$quote\n  $author"
    fi
}

get_width() {
    # get width  of longest line (not including trailing spaces) of quote when wrapped to colwrap chars
    quote_string="$1"
    colwrap="$2"
    echo -e "${quote_string}" | fold -w ${colwrap} -s | awk '{ print length }' | sort -n | tail -1
}

bubble() {
    # Arguments
    quote_string="$1"
    colwrap="$2"
    box_width="$3"
    border_string="$4"
    # split border string
    left_rule="${border_string:0:1}"
    top_rule="${border_string:1:1}"
    right_rule="${border_string:2:1}"
    bottom_rule="${border_string:3:1}"
    # Print top rule
    printf "%.0s${top_rule}" $(seq 1 ${box_width}) | sed -e 's/^/ /' -e 's/$/ \n/'
    # Print wraped quote and author surrounded by though bubble
    printf "%-${colwrap}s\n" "$(echo -e "${quote_string}")" |\
            fold -w $((${box_width})) -s |\
            sed -e "s/^/${left_rule}/" -e "s/$/~${right_rule}/" |\
            column -s'~' -t -c2 |\
            sed -e "s/\s\s${right_rule}/${right_rule}/"
    # Print bottom rule
    printf "%.0s${bottom_rule}" $(seq 1 ${box_width}) | sed -e 's/^/ /' -e 's/$/ \n/'
}

thinker() {
    # Print text line and thinker, padding by thinker_line_offset characters
    thinker_file="$1"    # ascii art file for the thinker
    thinker_line_offset="$2" 
    thinker_line="$3"    # length of line connecting thinker to bubble
    thinker_width=$(wc -L "${thinker_file}" | cut -d' ' -f1)
    # total_width=$((${thinker_line_offset}+${thinker_width}))
    # if [[ ${total_width} -gt ${COLUMNS} ]]; then
    if [[ $((${thinker_line_offset}+${thinker_width})) -gt ${COLUMNS} ]]; then
        thinker_line_offset=$((${COLUMNS}-${thinker_width}-1))
    fi
    # print whatever is thinking the bubble
    if [[ ${thinker_line} -gt 0 ]]; then
        # for i in $(seq ${thinker_line} -1 1); do
        for i in $(seq 0 1 $((${thinker_line}-1)) ); do
            padding=$((${i}+${thinker_line_offset}))
            printf "%${padding}s\ \n"
            # echo '\' | pr -T -o $((${thinker_padding}-${i}))
        done
        # incrementally add spaces before a \ char, so a value of 3 would be
        #bubble
        #      \  |
        #       \ |
        #        \|
        #{       }| speaker art
        #{} is $thiknker_padding chars long
    fi
    # "push" (left pad with spaces) thinker left
    # cat "${thinker_file}" 
    # while read i; do printf "%${thinker_line_offset}s ${i} \n"; done < "${thinker_file}"
    while IFS= read -r line; do 
        printf "%${thinker_line_offset}s${line}\n"; 
    done < "${thinker_file}"
}

display() {
    # print quote in a though bubble and some ascii art thinking it
    quote_string="$1"
    colwrap="$2"
    border_string="$3"
    thinker_file="$4"
    thinker_line_offset="$5"
    thinker_line="$6"
    # get width of thought bubble
    box_width="$(get_width "${quote_string}" "${colwrap}")"
    # print thought bubble wraped and decorated
    bubble "${quote_string}" ${colwrap} ${box_width} "${border_string}"
    thinker ${thinker_file} ${thinker_line_offset} ${thinker_line}
}

main() {
    # pick random quote and thinker, will be updated if specified by a CLI flag
    quote_string="$(random_quote)"
    author=""
    thinker_file="$(find $thinker_dir -type f -name "*.ascii" | shuf -n1)"
    while getopts "hpa:q:c:b:l:o:t:" arg; do
        case $arg in
            a) author="$OPTARG"                ;;
            q) quote_string="$OPTARG"          ;;
            c) colwrap="$OPTARG"               ;;
            b) border_string="$OPTARG"         ;;
            l) thinker_line="$OPTARG"          ;;
            o) thinker_line_offset="$OPTARG"        ;;
            p) echo -e "$quote_string" && exit 0 ;;
            t) if [ -f "$OPTARG" ]; then
                    thinker_file="$OPTARG"
                else
                    thinker_file="$thinker_dir/$OPTARG.ascii"
                    if [ ! -f $thinker_file ]; then
                        echo "Invalid option -$arg $OPTARG"
                        help && exit 1
                    fi
                fi
                ;;
            \?) echo "Invalid option -$arg $OPTARG"
                help && exit 2
                ;;
            h) help && exit 0 ;;
        esac
    done
    shift "$((OPTIND-1))"
    [[ -n "$author" ]] && quote_string="$quote_string\n --$author"
    display "${quote_string}" ${colwrap} ${border_string} ${thinker_file} ${thinker_line_offset} ${thinker_line}
}

main "$@"

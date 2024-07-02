#!/bin/bash

# Functions
up() { # Goes up many dirs as the number passed as argument, if none goes up by 1 by default
    local d=""
    limit=$1
    for ((i=1 ; i <= limit ; i++)); do
        d=$d/..
    done
    d=$(echo $d | sed 's/^\///')
    if [[ -z "$d" ]]; then
        d=..
    fi
    cd $d
}
dirsize () { # List sub-directory sizes in pwd
    du -shx * .[a-zA-Z0-9_]* 2> /dev/null | egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
    egrep '^ *[0-9.]*M' /tmp/list
    egrep '^ *[0-9.]*G' /tmp/list
    rm -rf /tmp/list
}
fared() { # Find and remove empty directories
    read -p "Delete all empty folders recursively [y/N]: " OPT
    [[ $OPT == y ]] && find . -type d -empty -exec rm -fr {} \; &> /dev/null
}
dcols() {  # print column names and example data descriptively
    tsv="$1"
    rows="${2:-3}"
    head -$rows "$tsv" | tr '\t' '\n' | sed -e 's/\n$//' | pr -ts$'\t' --columns $rows | column -s$'\t' -t
}
slog() {
    # show most recent log from lsf with a given name
    name="$1"
    log_dir="./logs"
    log_num="$(ls "$log_dir" | grep "${name}" | cut -d'-' -f2 | cut -d'.' -f1 | sort -n | tail -1)"
    log_name="${log_dir}/${name}-${log_num}"
    cat ${log_name}.out ${log_name}.err | less
}

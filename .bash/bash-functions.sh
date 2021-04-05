#!/bin/bash

# Functions
ff() { # Find a file with a pattern in name
    find . -type f -iname '*'$*'*' -ls
}
fe() { # Find a file with pattern $1 in name and execute $2 on it
    find . -type f -iname '*'$1'*' -exec "${2:-file}" {} \;
}
fl() {
    # echo line $1 from file $2
    head -$1 $2 | tail -1;
}
jless() {
    jq . -C $1 | less -R;
}
prog() { # progress bar, print at a given percent
    local w=60 p=$1;  shift
    # create a string of spaces, then change them to dots
    printf -v dots "%*s" "$(( $p*$w/100 ))" ""; dots=${dots// /#};
    # print those dots on a fixed-width space plus the percentage etc.
    printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*";
}
mvpr() {
    #move with a progress bar
    dest="${@: -1}"
    counter=0
    total="$(echo $# -1 | bc -l)"
    echo 'Moving files...'
    for file in "${@: 1:$#-1}"; do
        mv "$file" "$dest"
        let counter++
        prc="$(echo "100*$counter/$total" | bc -l)"
        percent="$(printf "%.*f" 0 $prc )"
        prog "$percent"
    done
    echo ''
}
notes() { # pandoc compiles md notes and open in firefox
    pattern="$1"
    ext="$2"

    name="$pattern-Notes.$ext"
    css="$HOME/dotfiles/.css/pandoc-notes.css"
    pandoc -s --toc -c "$css" ./Notes/* -o "$name"
    window_id="$(xwininfo -tree -root | grep "$pattern" | head -1 | grep -o '0x[0-9a-Z]*' | head -1)"
    if [ -n "$window_id" ]; then # is notes tab already open
        # refresh open tab
        xdotool key --window "$window_id" --clearmodifiers "ctrl+r" # refresh already open tab
    else
        firefox --new-tab "file://$(readlink -e $name)" # open pandoc output in tab
    fi
}

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
extract() { # Archive Extractor {{{
      clrstart="\033[1;34m"  # color codes
      clrend="\033[0m"

      if [[ "$#" -lt 1 ]]; then
        echo -e "${clrstart}Pass a filename. Optionally a destination folder. You can also append a v for verbose output.${clrend}"
        exit 1 # not enough args
      fi

      if [[ ! -e "$1" ]]; then
        echo -e "${clrstart}File does not exist!${clrend}"
        exit 2 # file not found
      fi

      if [[ -z "$2" ]]; then
        DESTDIR="." # set destdir to current dir
      elif [[ ! -d "$2" ]]; then
        echo -e -n "${clrstart}Destination folder doesn't exist or isnt a directory. Create? (y/n): ${clrend}"
        read response
        #echo -e "\n"
        if [[ $response == y || $response == Y ]]; then
          mkdir -p "$2"
          if [ $? -eq 0 ]; then
            DESTDIR="$2"
          else
            exit 6 # Write perms error
          fi
        else
          echo -e "${clrstart}Closing.${clrend}"; exit 3 # n/wrong response
        fi
      else
        DESTDIR="$2"
      fi

      if [[ ! -z "$3" ]]; then
        if [[ "$3" != "v" ]]; then
          echo -e "${clrstart}Wrong argument $3 !${clrend}"
          exit 4 # wrong arg 3
        fi
      fi

      filename=`basename "$1"`
      case "${filename#*.}" in
        tar)
          echo -e "${clrstart}Extracting $1 to $DESTDIR: (uncompressed tar)${clrend}"
          tar x${3}f "$1" -C "$DESTDIR"
          ;;
        gz)
          echo -e "${clrstart}Extracting $1 to $DESTDIR: (gip compressed tar)${clrend}"
          tar x${3}fz "$1" -C "$DESTDIR"
          ;;
        tgz)
          echo -e "${clrstart}Extracting $1 to $DESTDIR: (gip compressed tar)${clrend}"
          tar x${3}fz "$1" -C "$DESTDIR"
          ;;
        xz)
          echo -e "${clrstart}Extracting  $1 to $DESTDIR: (gip compressed tar)${clrend}"
          tar x${3}f -J "$1" -C "$DESTDIR"
          ;;
        bz2)
          echo -e "${clrstart}Extracting $1 to $DESTDIR: (bzip compressed tar)${clrend}"
          tar x${3}fj "$1" -C "$DESTDIR"
          ;;
        zip)
          echo -e "${clrstart}Extracting $1 to $DESTDIR: (zipp compressed file)${clrend}"
          unzip "$1" -d "$DESTDIR"
          ;;
        rar)
          echo -e "${clrstart}Extracting $1 to $DESTDIR: (rar compressed file)${clrend}"
          unrar x "$1" "$DESTDIR"
          ;;
        7z)
          echo -e  "${clrstart}Extracting $1 to $DESTDIR: (7zip compressed file)${clrend}"
          7za e "$1" -o"$DESTDIR"
          ;;
        *)
          echo -e "${clrstart}Unknown archieve format!"
          exit 5
          ;;
      esac
    }
compress() {
# Archive Compress {{{
      if [[ -n "$1" ]]; then
        FILE=$1
        case $FILE in
        *.tar ) shift && tar cf $FILE $* ;;
    *.tar.bz2 ) shift && tar cjf $FILE $* ;;
     *.tar.gz ) shift && tar czf $FILE $* ;;
        *.tgz ) shift && tar czf $FILE $* ;;
        *.zip ) shift && zip $FILE $* ;;
        *.rar ) shift && rar $FILE $* ;;
        esac
      else
        echo "usage: compress <foo.tar.gz> ./foo ./bar"
      fi
    }
remindme() { sleep $1 && notify-send "$2" & }
# usage: remindme <time> <text>
# e.g.: remind 10m "omg, the pizza"

# Simple Calculator {{{
calc() {
  if which bc &>/dev/null; then
      echo "scale=3; $*" | bc -l
  else
      awk "BEGIN { print $* }"
  fi
}
compress() { # Archive Compress
      if [[ -n "$1" ]]; then
        FILE=$1
        case $FILE in
        *.tar ) shift && tar cf $FILE $* ;;
    *.tar.bz2 ) shift && tar cjf $FILE $* ;;
     *.tar.gz ) shift && tar czf $FILE $* ;;
        *.tgz ) shift && tar czf $FILE $* ;;
        *.zip ) shift && zip $FILE $* ;;
        *.rar ) shift && rar $FILE $* ;;
        esac
      else
        echo "usage: compress <foo.tar.gz> ./foo ./bar"
      fi
}
lowercase() { # move filenames to lowercase
    for file ; do
      filename=${file#*/}
      case "$filename" in
      */* ) dirname==${file%/*} ;;
        * ) dirname=.;;
      esac
      nf=$(echo $filename | tr A-Z a-z)
      newname="${dirname}/${nf}"
      if [[ "$nf" != "$filename" ]]; then
        mv "$file" "$newname"
        echo "lowercase: $file --> $newname"
      else
        echo "lowercase: $file not changed."
      fi
    done
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
remindme() { # usage: remindme <time> <text>
    # e.g.: remind 10m "omg, the pizza"
    sleep $1 && notify-send "$2" &
}

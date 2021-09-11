#!/bin/bash
css="$HOME/dotfiles/.css/pandoc-notes.css"
filter="$HOME/dotfiles/.scripts/notes-pandoc-filter.py" # makes all headings collapsible

help() {
    echo "Usage: $(basename $0) \$name \$type
                 $(basename $0) \$notes_file
                 $(basename $0)
         "
}
notes() { # pandoc compiles md notes and open in firefox
    # parse args
    pattern="$1"
    if [[ -z "$pattern" ]]; then
        name="$(find . -name '*-Notes.html')"
        name="$(basename $name)"
        pattern="${name%%-Notes.html}"
        if [[ -z "$name" ]]; then
            echo 'No notes file, must create'
            help && exit 1
        fi
    elif [[ $pattern =~ ^.*-Notes\.[^\.]*$ ]]; then
        name="$pattern"
        pattern="${name%%-Notes.*}"
    else
        ext="$2"
        name="$pattern-Notes.$ext"
    fi
    #pandoc --mathjax --standalone --toc --toc-depth 2 -c "$css" -f markdown+pipe_tables ./Notes/*.md -o "$name"
    pandoc -s ./Notes/*.md -f markdown+pipe_tables --filter "$filter" --mathjax --toc --toc-depth 2 -c "$css" -o "$name"
    # open notes page in browser
    window_id="$(xwininfo -tree -root | grep -i "$(echo $pattern | tr '_' ' ')" | grep -o '0x[0-9a-zA-Z]*' | head -1)"
    if [ -n "$window_id" ]; then # is notes tab already open
        # refresh open tab
        xdotool key --window "$window_id" --clearmodifiers "ctrl+r" # refresh already open tab
    else
        firefox --new-tab "file://$(readlink -e $name)" # open pandoc output in tab
    fi
}

notes "$@"

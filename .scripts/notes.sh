#!/bin/bash
CSS="$HOME/dotfiles/.css/pandoc-notes.css"
FILTER="$HOME/dotfiles/.scripts/notes-pandoc-filter.py" # makes all headings collapsible

help() {
    echo "Usage: $(basename $0) \$name \$type
                 $(basename $0) \$notes_file
                 $(basename $0)
         "
}
notes() { 
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
    # pandoc compiles md notes to html/pdf
    pandoc -s ./Notes/*.md -f markdown+pipe_tables --filter "$FILTER" --mathjax --toc --toc-depth 2 -c "$CSS" -o "$name"
    # open notes page in browser
    window_id="$(xwininfo -tree -root | grep "$(echo $pattern | grep -o '[0-9]*')" | grep -o '0x[0-9a-zA-Z]*' | head -1)"
    if [ -n "$window_id" ]; then # is notes tab already open
        # refresh open tab
        xdotool key --window "$window_id" --clearmodifiers "ctrl+r" # refresh already open tab
    else
        firefox --new-tab "file://$(readlink -e $name)" # open pandoc output in tab
    fi
}

if [[ $# = 0 ]]; then
    notes "$(basename "$(pwd)")" html
else
    notes "$@"
fi

#!/bin/bash
if [ $# -eq 0 ]; then
    echo "usage: bash wordcount.sh yourfile.tex"
else
    #words="$(detex $1 | grep -v "block" | grep -v "blank" | grep -v "draw" | grep -v "node" | grep -v "d[SIRW]" | wc -w)"
    #echo "Document has $words words"
    #words="$(sed -n '/begin{cvletter/,/end{cvletter/p' "$1" | grep -v '%' | wc -cw)"
    words="$(sed -n '/begin{document/,/end{document/p' "$1" | \
             #grep -ov '\\[a-zA-Z0-9]*' | \
             grep -v '%' | \
             wc -cw)"
    echo "$words"
fi

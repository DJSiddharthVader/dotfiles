#!/bin/bash

#check valid file provided
if [ $# -eq 0 ]; then
    base="main"
    echo "no file specificed, using $base.Rnw by default"
    echo "usage: ./knitpdf.sh yourfile.Rnw"
else
    file="$1"
    #check file exists
    if [ ! -f "$file " ]; then
        echo "file $1 not found"
    fi
    #check extension is .Rnw
    extension="$(basename $file | cut -f2 -d'.')"
    if [ "$extension" = "Rnw" ]; then
        base="$(basename $file | cut -f1 -d'.')"
    else
        echo "invalid file extension ($extension), file must be .Rnw file"
    fi
fi
#Compiling file
if [[ $(which latexmk) ]]; then
    latexmk -c
    R -q -e "library('knitr'); knitr::knit('$1')"
    latexmk -pdf "$base"
    latexmk -pdf  "$base"
else
    R -q -e "library('knitr'); knitr::knit('$1')"
    pdflatex "$base".tex
    biber "$base"
    pdflatex "$base".tex
    pdflatex "$base".tex
fi

#!/bin/bash

config="$HOME/.config/i3/config"
outfile="$HOME/Documents/cheatsheets/i3.???"

bindings() { grep '^bindsym \$mod\+' $config | sed -e 's/^bindsym \$m/M/' | sed -e 's/\s\{2,\}/\t/g' ; }

main() {
    echo none
}

main

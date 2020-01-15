#! /bin/bash

dotdir="$HOME/dotfiles"

cd $dotdir
git add .vim/view/* .vim/.netrwhist .vim/spell/*
git commit -m "update vim folds, spellfiles"
git add .varfiles/*
git commit -m "update background tracking files"
git commit .config/qt5ct/colors/pywal.conf -m "update QT5 colors as set by pywal"
cd -

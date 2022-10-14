#!/bin/zsh

if (( $# < 1)) { echo $#; return 1;}
fname=${1:e}; echo $1 $fname
pandoc -f html -t org -o $fname.org $1
[[ $fname == 'pali' ]] && sed -i "/word版/d" pali.org
sed -i 's/^\\\\ *$//' $fname.org



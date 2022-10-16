#!/bin/zsh

if (( $# < 1)) { echo $#; return 1;}
fname=${1:e}; echo $1 $fname
pandoc -f html -t markdown -o $fname.md $1
# change sutra name.
if [[ $fname == 'pali' ]] {
       sed -i "/word版/d" pali.md
   } elif [[ $fname == 'agama' ]] {
       sed -i -f sutra_name.sed $fname.md
   }
   # nikaya's name will be changed in mksep.js
sed -i 's/^\\ *$//' $fname.md



#!/bin/zsh

. /fbook/format.sh
concatLines main.org
pandoc -f org -t markdown -o main.md main.org
sed -i -f br.sed main.md

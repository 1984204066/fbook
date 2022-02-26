#!/bin/zsh

for i ({$1..$2}) { echo $i; cat ./org-files/ZhongAHan$i.org >>./1.org};

sed -i '1i#+OPTIONS: toc:1' 1.org

emacs 1.org --batch --eval "(require 'ox-md)" --eval "(org-md-export-to-markdown)"

mv 1.org $3.org
mv 1.md src/$3.md


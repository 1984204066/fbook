#!/bin/zsh
[[ -f ./1.org ]] && rm 1.org

for i ({$1..$2}) { echo $i; cat ./org-files/$i.org >>./1.org};

sed -i '1i'"* $3" 1.org

# emacs 1.org --batch --eval "(require 'ox-md)" --eval "(org-md-export-to-markdown)"
file=${3// /-}
mv 1.org $file.org
# mv 1.md src/$file.md


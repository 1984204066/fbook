sed -i '/^$/N;/^\n$/D'  *.md
sed -i 's/^Image$//' *.md
fd -e .org -x  sed -i 's/\([^-][^-]*\)---*/\1-<feff>-/g'


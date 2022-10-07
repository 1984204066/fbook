for i ({1..44}) { no=$(printf "%02d" $i); echo $no; wget -O $i.html http://www.quanxue.cn/CT_FoJia/ChangAHan/ChangAHan$no.html}
for i (*) {f="../org-files/${$(basename $i .html)}.org"; echo "$i -> $f"; pandoc -f html -t org -o $f $i;}
for i (./org-files/*) { head -n -2 $i | sed '1,8d' > 0.org; cat 0.org >$i;}
for i (./org-files/*) {sed -i '/^\* .*/,+3d' $i}
for i (./org-files/*) {sed -i 's/^\*\* /* /;T;{n;N;N;d}' $i}
for i (./org-files/*) {title=$(sed -n '/^\* .*[经品]/p' $i);f=$title[3,-1];echo $f; echo "- [$f]($(basename $i .org).md)">>src/SUMMARY.md;}
for i (./org-files/*.org) {echo $i; emacs $i --batch --eval "(require 'ox-md)" --eval "(org-md-export-to-markdown)";}; mv org-files/*.md src/
# 圣弟子

for i ({1..8}) { echo $i; wget http://www.quanxue.cn/CT_FoJia/ShengDiZi/ShengDiZi0$i.html}
for i ({11..86}) { echo $i; wget http://www.quanxue.cn/CT_FoJia/ShengDiZi/ShengDiZi$i.html}

while read -r from to title; do echo "$from,$to, $title";

while {read -r from to title } { echo "$from,$to, $title" } < disciples.txt

for i (*) {f="../org-files/${$(basename $i .html)[10,-1]}.org"; echo "$i -> $f"; pandoc -f html -t org -o $f $i;}

for i (./org-files/*) { head -n -2 $i | sed '1,8d' > 1.org; cat 1.org >$i;}

    for i (./org-files/*) {sed -i 's/^\* /** /' $i}

	while {read -r from to title } { echo "$from,$to, $title"; script/mkorg.sh $from $to "$title" } < script/disciples.txt
 
	while {read -r from to title } { file=${title// /-}.md; echo "- [$title]($file)" >>src/SUMMARY.md;} < script/disciples.txt

for i (./*.org) {sed -i '/^\*.*《佛陀的圣弟子传》.*/,+3d' $i; emacs $i --batch --eval "(require 'ox-md)" --eval "(org-md-export-to-markdown)"; f=$(basename $i .org).md; mv $f src/$f;}

sed 's/.*(\(.*\))/\1/' src/SUMMARY.md | sed '1,2d' | while {read line} { f="src-org/$(basename $line .md).org"; echo $f; cat $f >> 0.org}

sed -i 's/\([^-][^-]*\)---*/\1-<feff>-/g' *.org


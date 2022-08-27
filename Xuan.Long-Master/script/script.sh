for i ({1..41}) {echo $i; node long.js ../html/$i.html $i>$i.x;}
for i ({1..41}) { node long.js ../html/$i.html $i>$i.x;} 2>title

while {IFS=' % ' read fname url} { if [[ "$fname" == '' ]] {continue;};echo $fname;wget -O ../src/img/$fname $url;} <img-urls
while {IFS=' % ' read fname url} { if [[ "$fname" == '' || "$fname" != *'-0.'* ]] {continue;};echo $fname;wget -O ../src/img/$fname $url;} <img-urls

for i ({1..41}) {pandoc -f html -t org -o ../org/$i.org $i.x }

for i ({1..41} ) {sed -i -e '1,7d' -e "8s/.*/<embed src=.\/mp3\/$i-0.mp3 width='530px' height='80px'\/>/" -e '/^--.*连载.* --*/,$d' $i.org}
for i ({1..41} ) {sd '^\\\\$' '' $i.org}
sed -i '/^$/N;/^\n$/D' *.org

sd '^\s*$' '' title

i=1;while {read  title} { if [[ "$title" == '' ]] {continue;};t=`echo $title | sd '^.*[：:] *(.*)' '$1'`;echo "* [$t]($i.md)";i=$((i+1));} <title

for i (*.org) {emacs $i --batch --eval "(require 'ox-md)" --eval "(setq org-export-with-toc nil)" --eval "(org-md-export-to-markdown)";}

s=1;i=1;while {IFS=' % ' read -r title line} {if ((s > i)) {i=$((i+1)); continue;}; echo $i; wget -O ../html/$i.html $line; i=$((i+1));} < out.urls

for i ({1..47}) {j=$((48-i)); if ((i!=j)) {cmd="mv $i.html tmp; mv $j.html $i.html; mv tmp $j.html";echo $cmd;eval $cmd} else {break;}}

for i ({47..10}) {echo $i; j=$((i+1)); mv $i.html $j.html;}

1. i=1; while [[ -f ../html/$i.html ]] {html="../html/$i.html";if [[ -f $html ]] {node heart.js $html $i >X/$i.x;}; i=$((i+1));} 2>title
for i ({1..48}) {html="../html/$i.html";if [[ -f $html ]] {node heart.js $html $i >X/$i.x;};} 2>title

while {IFS=' % ' read fname url} { if [[ "$fname" == '' ]] {continue;};echo $fname;wget -O ../src/img/$fname $url;} <img-urls
i=1;while {IFS=' % ' read fname url} { if [[ "$fname" == '' ]] {continue;};echo $fname;fnames[i]=$fname;i=$((i+1))} <img-urls
for i (*) {if  (( $fnames[(I)$i] )){} else {echo $i, bad; rm $i;};}

while {IFS=' % ' read fname url} {echo $fname, $url; wget -O ../src/mp3/$fname.mp3 "$url";}  < voice-urls
for i ({1..48}) {pandoc -f html -t org -o ../org/$i.org X/$i.x }

sd '\\\\$' '' *.org
sed -i 'y/ ：　/ : /' *.org
sed -i '/^  *$/d' *.org
sd '^\*[ \*]*$' '' *.org;
sed -i '/^ *\-\-*.*连载.*\-\-* *$/,$d'  *.org
sed -i '/[^-][^-]*---*\|---*[^-][^-]*/s/---*/-﻿-﻿-/g' *.org
#sd '^ *[【*注]*释.*' '-----\n注释:' *.org
sed -i 's/^ *[【*注]*释.*/-----\n*注释*:/' *.org
sed -i '/.png/{s/36-2.*/36-2.png]]/;t;d}' *.org
sed -i '/:PROPERTIES:.*/{:again N;s/.*:END:$//;T again;}' *.org

#sed -i '/^\*\**  *[^*]*$/s/\** *//' *.org
sed -i '/^$/N;/^\n$/D' *.org
#黑体变成h2
sed -i '/:$/{n;n;n}; /智慧是一种生活与存在的方式/n;/^\*\**[^ :「]\+\*.*/s/\*\([^ :「*]\+\)\*.*/** \1/' *.org
sed -i '/:$/{n;n;n}; /智慧是一种生活与存在的方式/n;/^\*\**[^ ]\+[^:「]\+\*.*/s/\*\([^*]\+\)\*.*/** \1/' *.org
for i ({1..48} ) {sed -i -e "2s/.*/\n<embed src=.\/mp3\/$i-0.mp3 width='530px' height='80px'\/>\n/" $i.org}


for i ({1..48}) {[[ -f $i.org ]] && emacs $i.org --batch --eval "(require 'ox-md)" --eval "(setq org-export-with-toc nil)" --eval "(org-md-export-to-markdown)";}

i=1;while {read  title} { if [[ "$title" == '' ]] {continue;};t=`echo $title | sd '^.*[：:|] *(.*)' '$1'`;while [[ ! -f $i.md ]] {i=$((i+1));}; echo "* [$t]($i.md)";i=$((i+1));} <../script/title >summary.s
# 生成二级目录。
sed -n '/【.*/s/.*】\(.*\)/\1/p;t;/^[^】]\+$/s/.*[：|]\(.*\)/\1/p' title |sd '：' '.' | for i ({1..48}) { [[ -f ../src/$i.md ]] && {read title; echo "  * [$title]($i.md)";};} >summary.s2
#改变org文件标题
for i ({1..48}) {f=../org/$i.org;[[ -f $f ]] && sed -i '1{s/-<feff>-<feff>-《关于这颗心》//;s/[【[［]//;s/[］】]/./;s/:/./;s/ //g;s/^\*/* /}' $f;}
#改变md文件标题
for i ({1..48}) {f=$i.md;[[ -f $f ]] && sed -i '2{s/-<feff>-<feff>-《关于这颗心》//;s/[【[［]//;s/[］】]/./;s/:/./;s/ //g;s/^#/# /}' $f;}

for i ({47..10}) {echo $i; j=$((i+1)); mv $i.md $j.md;}

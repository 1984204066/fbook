i=1;while {read -r line} {echo $i; wget -O ../html/$i.html $line; i=$((i+1));} < urls
for i ({1..31}) { node letters.js ../html/$i.html $i>$i.x;} 2>title

while {IFS=' % ' read fname url} { if [[ "$fname" == '' ]] {continue;};echo $fname;wget -O ../src/img/$fname $url;} <img-urls
while {IFS=' % ' read fname url} {echo $fname, $url; wget -O ../src/mp3/$fname.mp3 "$url";}  < voice-urls

for i ({1..31}) {pandoc -f html -t org -o ../org/$i.org $i.x }

for i ({1..31} ) {sed -i -e '1,7d' -e '/-.-.*连载.*-.-*/,$d' -e '/-.-.*进行中.*-.-*/,$d' -e '/^\*附\*/,$d' -e '/^\*\\\\/,+1d' -e '/[^-][^-]*---*\|---*[^-][^-]*/s/---*/-<feff>-/g' -e '/^\\\\$\|^\*\*$/d' $i.org}

sed -i 's/\([^-][^-]*\)---*/\1-<feff>-/g' *.org
sed -i '/[^-][^-]*---*\|---*[^-][^-]*/s/---*/-<feff>-/g' *.org
sd '^\\\\$' '' *.org
sd '^\*\*$' '' *.org
sed -i '/^$/N;/^\n$/D' *.org

for i ({2..31} ) {sed -i -e "3s/.*/<embed src=.\/mp3\/$i-0.mp3 width='530px' height='80px'\/>/" $i.org}
sed -i "1i \<embed src=.\/mp3\/1-0.mp3 width='530px' height='80px'\/>\n" 1.org
sed -i "1i \\\n\n" 1.org

i=1;while {read  title} { if [[ "$title" == '' ]] {continue;};t=`echo $title | sd '^.*[|] *(.*)' '$1'`;echo $t|sed -e 's/信./信./' -e 's/ *//g'|IFS='.' read envelope title; [[ "$title" == "" ]] && title=$envelope; sed -i "1s/.*/* $title/" $i.org;cat $i.org >>$envelope.org; echo >>$envelope.org; t=${title%\(*};[[ $t != "$tt" ]] && {tt=$t;echo "* [$t]($envelope.md)">>summary.s;}; i=$((i+1));} <../script/title

sd ' ' '' 第* 缘*
sed -i '1i#+include: forget.org' 第* 缘*
for i (第*.org 缘*.org) { echo $i; emacs $i --batch --eval "(require 'ox-md)" --eval "(org-md-export-to-markdown)";}


for i ({1..26}) { node achaan.js ../html/$i.html $i>$i.x;} 2>title
for i ({1..26}) {pandoc -f html -t org -o ../org/$i.org $i.x }

for f (*-*.jpeg) {i=${f%-*};j=${f#*-};k=`basename $j .jpeg`;k=$((k-2)); newf=$i-$k.jpeg ; echo $newf; mv $f $newf;}
sd '^\\\\$' '' *.org
sed -i '/^$/N;/^\n$/D' *.org

for i ({1..26} ) {sed -i -e "1i \<embed src=.\/mp3\/$i-0.mp3 width='530px' height='80px'\/>" -e '/^--.*连载.* --*/,$d' $i.org}

sd '^\s*$' '' title
i=1;while {read  title} { if [[ "$title" == '' ]] {continue;};t=`echo $title | sd '^.*[|] *(.*)' '$1'`;echo "* [$t]($i.md)";i=$((i+1));} <title
i=1;while {read  title} { if [[ "$title" == '' ]] {continue;};t=`echo $title | sd '^.*[|] *(.*)' '$1'`;sed -i "1i \* $t\n" ../org/$i.org;i=$((i+1));} <title

i=1;while {read  title} { if [[ "$title" == '' ]] {continue;};t=`echo $title | sd '^.*[|] *(.*)' '$1'`;echo $t|IFS=' ' read chapter subject;title=${chapter%[1-9]};cat $i.org >>$title.org;echo >>$title.org;i=$((i+1));} <../script/title

{{i=1;while {read  title} { if [[ "$title" == '' ]] {continue;};t=`echo $title | sd '^.*[|] *(.*)' '$1'`;echo $t|IFS=' ' read x subject;[[ "$subject" == '' ]]&& subject=$x; echo $subject;i=$((i+1));} <title } |uniq} >subject
for i (译 一 二 三 四 五 六 七) {echo *$i*.org} >chapter

for i (译 一 二 三 四 五 六 七) {f=`/bin/ls *$i*.org`;echo $f;emacs $f --batch --eval "(require 'ox-md)" --eval "(org-md-export-to-markdown)";}
for i (译 一 二 三 四 五 六 七) {echo *$i*.md} >chapter
emacs --batch --eval '(princ (reverse "七六五四三二一译"))'

sub=$(<subject);echo $sub
subject=(${(s:\n:)sub});echo $subject
sub=`echo $sub | sd '\n' ' '`; echo $sub
subject=(${=sub});echo $subject

cha=$(<chapter); echo $cha
chapter=(${(s:\n:)cha});echo $chapter
cha=`echo $cha | sd '\n' ' ' `;echo $cha
chapter=(${=cha});echo $chapter
print -l $chapter[2,3]

for i ({1..8}) {echo $subject[$i], $chapter[$i]}
for i ({1..8}) {echo "* [$subject[$i]]($chapter[$i])"}


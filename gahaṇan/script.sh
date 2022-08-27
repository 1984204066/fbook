fd -x echo {}| sed 'h;s/ /_/g;G;s/\n/ /;' > ../fl
while read a b ;do echo $a, $b; mv "$b" "$a"; done < ../fl

j=1;for i (`/bin/ls |sort -n`) {
echo $i; pandoc -f docx -t org -o ../org/$j.org $i --extract-media=.
mv media ../media/$j
j=$(($j+1))
}

for i (*) { j=`basename $i .org`;echo $j;sed -i "s,media/,media/$j/," $i}
	    
for i (*.org) {sed -i '1s/^\*《清净道论·广说学取业处》\(.*\)\*/# \1/' $i}

sed -i '2,6d;7s/.*/#+DATE: &\n#+macro: caudio \n#+macro: DOCX \n#+include: "preamble-macro.org"\n{{{audio-docx({{{caudio}}},{{{docx}}},{{{date}}})}}}/' 2.org

for i ({3..11}.org) {k=`basename $i .org`.docx;echo $k;sed -i "2,6d;7s/.*/#+DATE: &\n#+macro: caudio \n#+macro: DOCX $k\n#+include: preamble-macro.org\n{{{audio-docx({{{caudio}}},{{{docx}}},{{{date}}})}}}/" $i;}

#mp3 rename
fd -x echo {} | (while read f; do k=`echo $f|sed 's/ //'`; mv $f $k;done)

sd '\(Visuddhimagga·Kammaṭṭhānaggahaṇanidessa\)' '' [1-9]*.org
sed -i '/^诵古德所写如下偈诵一遍.$/,/.*仅以心清除净化 *。$/d' [1-9]*.org
sed -i '10i \#+include: chant.org\n' [1-9]*.org

for i ({1..14}.org) {emacs $i --batch --eval "(require 'ox-md)" --eval "(setq org-export-with-toc nil)" --eval "(org-md-export-to-markdown)";}

/bin/ls [1-3]*.mp3 | {f=`sd '([1-3]).*.mp3' 'mv $0 广说地遍$1.mp3'`; eval $f}

#廣說地遍

j=3;for i ({3..13}*廣說地遍*.docx) {
	echo $i; org="../org/廣說地遍$j.org"
	pandoc -f docx -t org -o $org $i --extract-media=.
mv media ../media/廣說地遍$j
sed -i "1s/^\*《清净道论·广说地遍》\(.*\)\*/* 清净道论·广说地遍 \1/;2,6d;7s/.*/#+DATE: &\n#+macro: caudio 廣說地遍$j.mp3\n#+macro: DOCX $i\n#+include: preamble-macro.org\n{{{audio-docx({{{caudio}}},{{{docx}}},{{{date}}})}}}\n\n诵古德所写如下偈诵一遍\n\n#+include: chant.org\n/;8,/.*仅以心清除净化 *。$/d;s,media/,media/廣說地遍$j/," ../org/廣說地遍$j.org
emacs $org --batch --eval "(require 'ox-md)" --eval "(setq org-export-with-toc nil)" --eval "(org-md-export-to-markdown)";
j=$(($j+1))
}
for f (廣說地遍*.md) {k=`basename $f .md`; echo "[$k]($f)" } >>SUMMARY.md
/bin/ls 广说地遍* |{cmd=`sd '广说地遍(.*)' 'mv $0 廣說地遍$1'`; eval $cmd;}


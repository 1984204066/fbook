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

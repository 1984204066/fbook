sed -i -e 1,8d -e '/分类:.*$/,$'d *
sed -i '1i#+OPTIONS: toc:1' 1.org

for i (*.org) { echo $i[10,-1];grep 《中阿含经》 $i;}
for i ({11..20}) { echo $i; cat ZhongAHan$i.org >>../1.org}

1. cat ../src/SUMMARY.md | sed -n '/^-/s/.*](\(.*\).md)/\1/p' >files
1. while {IFS='-' read a b c} { echo $a $b $c} < files

sed -n '/^\*/s/.*\(第.*卷\).*$/\1/p' *.org
for i (*) {echo -n "$i "; sed -n '/^\*/s/.*\(第.*卷\).*$/\1/p' $i;}
for i (*) {echo -n "$i "; sed -n '/^\*/s/.*第\(.*\)卷.*$/\1/p' $i;} | while {IFS=' ' read f n } { if ((n != chapter)) {echo $n;chapter=$n;};}

for i (*) {echo -n "$i "; sed -n '/^\*/s/.*第\(.*\)卷.*$/\1/p' $i;} | while {IFS=' ' read f n } { if ((n != chapter)) {echo $n;chapter=$n;};}

for i (*) {echo -n "$i "; sed -n '/^\*/s/.*第\(.*\)卷.*$/\1/p' $i;} | while {IFS=' ' read f n } { if ((n != chapter)) {echo $f,$n;chapter=$n;};cat $f >> $n.org;}

# modify .org manually.
sd '《中阿含经》' '' *.org
1. for i (*.org) {sd '《中阿含经》' '' *.org }
# 删除多了： 第11卷 王相应品 七宝经第一, 第22卷 秽品 秽经第一, 第24卷 因品 大因经第一, 第27卷 林品 林经上第一
# 第29卷 大品 柔软经第一, 第03卷 业相应品 盐喻经第一, 第35卷 梵志品 , 第42卷 根本分别品,  第45卷 心品
# 第48卷 双品 , 第49卷, 第50卷 大品, 第55卷 晡利多品, 第59卷 例品, 第08卷 未曾有法品
1. for i (*.org) {sed -i '/PROPERTIES/,+4d' $i }
1. sd 'toc:1' 'toc:nil' *.org
1. sd '\*\*' '#+TOC: headlines 1\n\n**' *.org
1. sed -i '1i#+OPTIONS: toc:nil num:nil' *.org

emacs 1.org --eval "(use-package org  :demand   :load-path \"./lisp/org-mode/lisp\" :init (require 'org-loaddefs) :config (require 'ox-md nil t))" --eval "(org-md-export-to-markdown)" --eval "(save-buffers-kill-terminal)"

1. for i (*.org) {emacs $i --batch --eval "(require 'ox-md)" --eval "(setq org-export-with-toc nil)" --eval "(org-md-export-to-markdown)";}
# mdbook 处理toc不正确。
1. for i ([1-9]*.md) {sed -n 's/^- *\[\(.*\)\](\(.*\))/\1\2/p' $i | while {IFS='#' read t id} {echo $t, "#$id"; sed -i "s/^[# ]*$t$/<span id=\"$id\"><\/span>\n\n&/" $i;} }

1. for i (*.org) {echo $i; ../script/newtitle.sh $i;}
1. sd '^\* ' '** ' *.org
1. sd '^# ' '* ' *.org
1. sd 'headlines 1' 'headlines 2' *.org

sed -n '/.*\\\\$/{:start N;s/.*[^\\]$/&/;T start;s/^/<div class="poem">\n/;s/$/\n<\/div>/;p}' 3-4-业相应品.org
sed '/.*\\\\$/{:start N;s/.*[^\\]$/&/;T start;s/[\"\“\”]//g;s/^/<div class="poem">\n/;s/$/\n<\/div>/;}' 3-4-业相应品.org
1. for i (*.org) {sed -i '/.*\\\\$/{:start N;s/.*[^\\]$/&/;T start;s/$/\n\n<\/div>/;s/["“” 　]//g;s/^/<div class="poem">\n\n/;}' $i}
1.  sd "'" "" *.org

1. sd 'Table of Contents' '本品内容' *.md

sed -i 's/^[ \t]\+//g;s/\(.*[^ \t]\)[ \t]*$/\1/g' format.sh

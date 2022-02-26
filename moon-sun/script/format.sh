find . -type f -name "*.org" | xargs -i'{}' sed -i '/\*专题导航/,$d' "{}"
find . -type f -name "*.org" | xargs -i'{}' sed -i '$!N; 1,/\n发布于/D' "{}"

for i (1775 1858 1951 1967 1988) { org=$(ls $i/*/*.org); echo $org ;cat $org >>/home/admin/fbook/moon-sun/org-files/内观身上好风光.org}

sed -i '/^发布于/{s/[^0-9]*201\([0-9]\)年\([0-9][0-9]*\)月\([0-9][0-9]*\)日[]]*/--[201\1-\2-\3]/g;h;d;t}; /^\* .*/{G;s/\n--/    /}' 内观身上好风光.org

sed -i '/由.*日月明行.*/d'  内观身上好风光.org
###########
for i (1243  1253  1316  1399  1404  1458  1504  1517  1568) { org=$(ls $i/*/index.html.org); echo $org ;cat "$org" >>/home/admin/fbook/moon-sun/org-files/四念住禅修心得.org}

###########
for i (656 645 635 447 102 250 2089 2085 2074 95) { org=$(ls $i/*/index.html); echo $org ;pandoc -f html -t org -o "$org".org "$org"}

for i (656 645 635 447 102 250 2089 2085 2074 95) { mv $i 葛印卡内观; }

find . -type f -name "*.org" | xargs -i'{}' cat '{}' >>/home/admin/fbook/moon-sun/org-files/葛印卡内观.org

sed  -i '/^<<toc_container>>/, /^- .*$/{:again; s/^- .*//;T a;n; b again; :a;d}' 葛印卡内观.org
####################
for i (2704 2706 2708) { org=$(ls $i/*/index.html); echo $org ;pandoc -f html -t org -o "$org".org "$org"}
find . -type f -name "*.org" | xargs -i'{}' cat '{}' >>/home/admin/fbook/moon-sun/org-files/心的无限可能.org

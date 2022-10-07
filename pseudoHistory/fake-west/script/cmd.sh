while {IFS=' % ' read fname url} { if [[ "$fname" == '' ]] {continue;};echo $fname;wget -O ../src/img/$fname $url;} <img-urls
      
. script.sh
wget_url_to -h
wget_url_to ../html urls 2 2
genXfile -h
genXfile fake.js 2 2>title

fakeWest

a="$(seq 9 | sed 'y/123456789/①②③④⑤⑥⑦⑧⑨/' |sed -e 's/^/-e "s,\\[/' -e 's/$/\\],[/' |gawk '{print $0 NR "],\""} END {print "-e "}'|sed '10s/$/"s,\\[⑩\\],[10],"/')"
echo $a | sd '\n' ' '

for i (*.org) {for str (${(f)"$(sed -n '/^(S)>[^><]*<(S)$/p' $i)"}) {echo "$#str : $str";};} | sort -n |bat
    
for i ({1..26}) {read url;sd '###' "$url" ../org/$i.org;} <urls
    for i ({1..26}) {read url;sed -i '5s/.*/[[转载请 注明出处]['"$url"']]\n\n&/' ../org/$i.org;} <urls

for i ({1..26}) {read url;echo $url;sed -i "3i$url\n\n" out/$i.org } <urls	

i=0;for f (${(f)"$(sed -n "s,.*img src='file://\([^']\+\)'.*,\1,p" 0.org)"}){i=$((i+1)); f0=$f:t; e=$f:e; f1="0-$i.$e"; mv $f0 $f1; sed -i "s,file://\([^']\+\)'.*,./img/$f1," 0.org;}

for f (img/0-*) {sed -i "1,\:./img/0-1.webp:s?./img/0-1.webp?/$f?" ../org/tmp.org }

i=0;for f (${(f)"$(sed -n "s,.*img src='file://\([^']\+\)\('.*\),\2,p" 0.html)"}){i=$((i+1)); sd "'./img/0-$i.*$" "$0$f" 0.org;}

sed -i 'y/《》/「」/' *.org

# 黑体-> h2  跳过发言：之后3段。  
sed -i '/:$/{n;n;n}; /^\*\**[^ :「]\+\*.*/s/\*\([^*]\+\)\*.*/** \1/' *.org
for i ({1..26}) {echo -n "$i: "; sed -i -f ../modTitle.sed $i.org}
sed -i '/西史辨按/s/^\*\* //' *.org

emacs 1.org --batch --eval "(require 'ox-md)" --eval "(setq org-export-with-toc nil)" --eval "(org-md-export-to-markdown)";

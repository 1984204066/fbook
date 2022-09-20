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
	
    sed -i 'y/《》/「」/' *.org
# 黑体-> h2  跳过发言：之后3段。  
sed -i '/:$/{n;n;n}; /^\*\**[^ :「]\+\*.*/s/\*\([^*]\+\)\*.*/** \1/' *.org
for i ({1..26}) {echo -n "$i: "; sed -i -f ../modTitle.sed $i.org}
sed -i '/西史辨按/s/^\*\* //' *.org

emacs 1.org --batch --eval "(require 'ox-md)" --eval "(setq org-export-with-toc nil)" --eval "(org-md-export-to-markdown)";

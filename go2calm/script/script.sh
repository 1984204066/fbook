for i (../../typedscript/*) {echo $i; ln -sf $i;}

i=1;while {read -r line} {echo $i; wget -O ../html/$i.html $line; i=$((i+1));} < urls
4. for i ({1..10}) {echo $i; node go2calm.js ../html/$i.html $i;}
1. for i ({1..10}) {echo $i; node go2calm.js ../html/$i.html $i >$i.x;}
for i ({1..10}) {echo $i; node go2calm.js ../html/$i.html $i > X/$i.x;}

while {IFS=' % ' read fname url} {echo $fname, $url; wget -O ../src/mp3/$fname.mp3 "$url";}  < voice-urls

while {IFS=' % ' read fname url} { if [[ $fname != *png ]] { echo $fname;wget -O ../src/img/$fname $url;}; }  < img-urls.bak	     

for i ({1..10}) {pandoc -f html -t org -o ../org/$i.org X/$i.x }

1. sed -i '/^--.*连载.*--*/,$d' 1.org
for i ({1..10} ) {sed -i -e '1,2d;3s/^/* /' -e "9s/.*/<embed src=.\/mp3\/$i-0.mp3 width='530px' height='80px'\/>/" -e '/^--.*连载.*--*/,$d' $i.org}
for i ({11..19} ) {sed -i -e '1,2d;3s/^/* /' -e "5s/.*/<embed src=.\/mp3\/$i-0.mp3 width='530px' height='80px'\/>/" -e '/^--.*连载.*--*/,$d' $i.org}

1. for i ({1..10}) {read line <$i.org; echo -n $line|sed 's/^\* //'|sd '.*' '* [$0]('"$i.md)\n" >>summary.s }
sd '\\\\$' '' *.org
sd '^\*\*$' '' *.org
sed -i '/^$/N;/^\n$/D' *.org

for i ({11..19}) {emacs $i.org --batch --eval "(require 'ox-md)" --eval "(setq org-export-with-toc nil)" --eval "(org-md-export-to-markdown)";}

i=1;while {read -r line} {echo $i; wget -O ../html/$i.html $line; i=$((i+1));} < urls
for i ({1..31}) { node letters.js ../html/$i.html $i>$i.x;} 2>title

while {IFS=' % ' read fname url} { if [[ "$fname" == '' ]] {continue;};echo $fname;wget -O ../src/img/$fname $url;} <img-urls
while {IFS=' % ' read fname url} {echo $fname, $url; wget -O ../src/mp3/$fname.mp3 "$url";}  < voice-urls

for i ({1..31}) {pandoc -f html -t org -o ../org/$i.org $i.x }

for i ({1..31} ) {sed -i -e '1,7d' -e '/^--.*连载.* --*/,$d' $i.org}
sd '^\\\\$' '' *.org
sed -i '/^$/N;/^\n$/D' *.org

for i ({2..31} ) {sed -i -e "3s/.*/<embed src=.\/mp3\/$i-0.mp3 width='530px' height='80px'\/>/" $i.org}
sed -i "1i \<embed src=.\/mp3\/1-0.mp3 width='530px' height='80px'\/>\n" 1.org

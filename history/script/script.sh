s=2;i=1;while {IFS=' % ' read -r title line} {if ((s > i)) {i=$((i+1)); continue;}; echo $i; wget -O ../html/$i.html $line; i=$((i+1));} < urls

while {IFS=' % ' read fname url} { if [[ "$fname" == '' ]] {continue;};echo $fname;wget -O ../src/img/$fname $url;} <img-urls

i=2; while [[ -f ../html/$i.html ]] {node history.js ../html/$i.html $i >X/$i.x;i=$((i+1));} 2>title

sd '\\\\$' '' *.org                            
sd '^\*\**$' '' *.org;
sed -i '/^$/N;/^\n$/D' *.org
sed -i '/^\*\**关注我.*\*$/,$d'  *.org

# 奇怪，执行失败。
for f (*-*.jpeg) {i=${f%-*};j=${f#*-};k=`basename $j .jpeg`;k=$((k+1)); newf=$i-$k.jpeg ; echo $newf; mv $f $newf;}

sed -i '/^\*\**关注我.*\*$/,$d' 

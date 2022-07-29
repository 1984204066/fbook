wget -e robots=off -t 1 -r -np -nH -pk -L -P html  http://www.putixin.com/continue/fjj061004/fjj-01.htm

for i (../html/continue/fjj061004/fjj-{01..104}.htm) {f=`basename $i .htm`; node fjj.js $i |pandoc -f html -t org -o ../org/$f.org;}

for i (../html/continue/fjj061004/fjj-{01..104}.htm) {f=`basename $i .htm`; node fjj.js $i >../src/$f.md 2>tmp; echo $i;}

for i (*.md) {sed -n '/<img/{p;q}' $i|sed "s/^.*alt=\"\(.*\)\"../- [\1]($i)/" } > SUMMARY.md

sed 's/\(^.* .*品\) \(.*\)/\1\n\2/' fjj*.md > 0.md

while {read line} {echo $line} < 0.md
while {read line} { [[ "$line" == 第?*品 ]] && echo $line} < 0.md

while read line ;do [[ "$line" == 第?*品 ]] &&echo $line; done < 0.md

while {read line} { [[ "$line" == 第?*品 ]] && if [[ $line != $pin ]] {echo $line};} < 0.md
while {read line} { [[ "$line" == 第?*品 ]] && if [[ $line != $pin ]] {echo $line;pin=$line;};} < 0.md |sed 's/ /./' >files

while {read line} { [[ "$line" == 第?*品 ]] && if [[ $line != $pin ]] {pin=$line;} else {echo $line > "$pin".md};} < 0.md

while {read line} { [[ "$line" == 第?*品 ]] && if [[ $line != $pin ]] {pin=$line;echo $line;} else {echo $line >> "$pin".org};} < 0.md

while {read line} {if [[ "$line" == 第?*品 ]] { if [[ $line != $pin ]] {pin=$line;echo $line;}; continue};  {echo $line >> "$pin".org};} < 0.md
for i (*.org) {j=`basename $i .org`; k=`echo $j|sed 's/ /./'`; echo $k; mv $i $k;}

sed -n "s/^.*alt=\"\(.*\)\"../\1/p" 第五品.愚品
for i (*品) {sed -n "s/^.*alt=\"\(.*\)\"../\1/p" $i |uniq >$i.key}
for i (*品) {while {read key} { echo $key} <$i.key}
for i (*品) {while {read key} {sed -i "s/^[^<]*$key$/# &/g" $i;} <$i.key}
for i (`cat files`) { echo " - [$i]($i)" } >SUMMARY.md

sed -i 's/^[ \t]\+//g' ../script/script.sh

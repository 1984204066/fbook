#summary
while IFS="%" read -r t url ; do title=`echo $t | sed 's/.*：\(.*\)/\1/'|sed 's/（音频+文字）//'|sed 's/\..*//'`; echo $title; done <urls | uniq | gawk 'BEGIN {a = 0}; {printf "- [%s](%d.md)\n", $0, a; a++}' | sed '1s/- //;$s/- //' >>SUMMARY.md

while IFS="%" read -r t x url ; do title=`echo $t | sed 's/.*：\(.*\)/\1/'|sed 's/（音频+文字）//'|sed 's/\..*//'`; echo "$title % $url"; done <urls  | gawk 'BEGIN {FS="%"; a = -1;b=1; pre=""}; { if (pre == $1) {if (b==1) {cmd = "[ -f "fname" ] && mv "fname" "a"-1.mp3"; system(cmd);}b++;fname=a"-"b".mp3";} else {b=1;pre=$1; a++;fname = a".mp3"} ; print fname, "%", $2;}' >tmp

while IFS="%" read -r fname url ; do echo $fname; sh -c "wget -c $url -O $fname" ; done <tmp

ls *-2*| while read -r f ; do fname=${f%-2*}.mp3;[ -f $fname ] && mv  $fname ${f%-2*}-1.mp3; done

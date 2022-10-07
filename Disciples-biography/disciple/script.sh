i=1; while {IFS='~' read chapter no} {while ((i<=no)) {f=../disciple/html/ShengDiZi`printf "%02d" "$i"`.html; t=../disciple/src/$no.htm;node disciple.js $f >>$t;i=$((i+1));}; echo $t;sd '向智长老' '' $t;} < ../disciple/SUMMARY

for t (*.htm) {pandoc -f html -t markdown -o `basename $t .htm`.md $t};

cat ../SUMMARY | sed '1s/\(.*\) ~\(.*\)/[\1](\2.md)/;t;s/....\(.*\)~\(.*\)/- [\1](\2.md)/'

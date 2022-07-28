wget -e robots=off -t 1 -r -np -nH -pk -L -P html  http://www.putixin.com/continue/fjj061004/fjj-01.htm

for i (../html/continue/fjj061004/fjj-{01..104}.htm) {f=`basename $i .htm`; node fjj.js $i |pandoc -f html -t org -o ../org/$f.org;}

for i (../html/continue/fjj061004/fjj-{01..104}.htm) {f=`basename $i .htm`; node fjj.js $i >../src/$f.md 2>tmp; echo $i;}

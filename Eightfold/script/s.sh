
while IFS="%" read -r title url ; do ./Eightfold "$title" | read num subject; fname=${num%% }.md; echo "$fname $subject"; done < urls | sed  '/-2/d' | sed 's/-1//' >tmp
# 1.md 灭苦之道
# 2.md 正见
# 3.md 正思维
# 4.md 正语、正业、正命
# 5.md 正精进
# 6.md 正念
# 7.md 正定
# 8.md 智慧的修炼

while read f title; do fname="../src/$f"; test -f $fname || echo "# $title" > $fname ; done < tmp

#summary
while read f title; do echo "- [$title]($f)" >>../src/SUMMARY.md ; done < tmp
#get mp3.
while IFS="%" read -r title u url ; do ./Eightfold "$title" | read num subject; fname="../src/mp3/${num%% }.mp3"; echo $fname; sh -c "wget -c $url -O $fname" ; done < urls

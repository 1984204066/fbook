while {IFS=' % ' read fname url} { if [[ "$fname" == '' ]] {continue;};echo $fname;wget -O ../src/img/$fname $url;} <img-urls
      
. /fbook/format.sh
wget_url_to -h
wget_url_to ../html urls 2 2
getXfile -h
getXfile fake.js 2 2>title

for i ({2..26}) {pandoc -f html -t org -o ../org/$i.org X/$i.x }
format_once org
concatLines 3.org
format_file org

# 黑体-> h2  跳过发言：之后3段。  
sed -i '/:$/{n;n;n}; /^\*\**[^ :「]\+\*.*/s/\*\([^*]\+\)\*.*/** \1/' *.org
sed -i 'y/《》/「」/' *.org
sed -i '/^$/N;/^\n$/D' *.org
# 去掉/ [[./img/xxx]]/
sed -n '/img/s,^/\(.*\)/$,\1,p'  tmp
sed -i '/img/s,^/\(.*\)/ *$,\1,' *.org
# 加上\n
sed -i 's,]]/,]]\n\n/,' *.org
sed -i 's,/ *\[\[,/\n\n[[,g' *.org
# 去掉黑体
sed -n '/img/s,\*\([^*]\+\)\*,\1,p'  tmp
# 去掉 ^{img}
sed -n '/img/s,\^{\([^}]\+\)},\1,p'  *.org
sed -i '/img/s,\^{\([^}]\+\)},\1,g'  *.org

# /图解.*/ 放在一行。
sed -i '\,^/[^/]\+ *$,{:a N;s,[^/] *$,&,;t a;s/\n/ /g;}' 1.org
# <div>图解</div>
sed -i -f ../script/caption.sed 1.org

# 右面加空格
sd '\*[^ *]+\*' '$0 ' 1.org
# 左面
sd '(.[^* ])(\*[^*]+\*)' '$1 $2' 1.org #当一行有两对 黑体 时有问题。
sd '(.[^ ])(\*[^ *]+\*)' '$1 $2' 1.org
sed -i 's/\([^ ]\)\(\*[^ *]\+\*\)/\1 \2/' 1.org
# 处理11.org. footnote
sed -i '/注释/,$s/\[fn:[0-9]\+\]/\n\n&/g' 11.org

for i ({1..26}) {sed -i -e '5s/.*/[[转载请注明出处][###]]\n\n&/' ../org/$i.org;}
for i ({1..26}) {read url;sd '###' "$url" ../org/$i.org;} <urls

emacs 1.org --batch --eval "(require 'ox-md)" --eval "(setq org-export-with-toc nil)" --eval "(org-md-export-to-markdown)";

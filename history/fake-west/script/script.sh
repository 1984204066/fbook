while {IFS=' % ' read fname url} { if [[ "$fname" == '' ]] {continue;};echo $fname;wget -O ../src/img/$fname $url;} <img-urls
      
. /fbook/format.sh
wget_url_to -h
wget_url_to ../html urls 2 2
getXfile -h
getXfile fake.js 2 2>title

for i ({2..26}) {pandoc -f html -t org -o ../org/$i.org X/$i.x }
    
sed -i '/:$/{n;n;n}; /^\*\**[^ ]\+[^:「]\+\*.*/s/\*\([^*]\+\)\*.*/** \1/' *.org
sed -i 'y/《》/「」/' *.org
sed -i '/^$/N;/^\n$/D' *.org
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

emacs 1.org --batch --eval "(require 'ox-md)" --eval "(setq org-export-with-toc nil)" --eval "(org-md-export-to-markdown)";

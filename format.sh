format_once() {
    local suffix=$1
    sed -i 'y/ ：　１２３４５６７８９０《》/ : 1234567890「」/' *.$suffix
    sed -i '/[^-][^-]*---*\|---*[^-][^-]*/s/---*/-﻿-﻿-/g' *.$suffix
    sed -i '/:PROPERTIES:.*/{:again N;s/.*:END:$//;T again;}' *.$suffix
}

format_file() {
    local suffix=$1
    # \\ 即是换行的意思，所以替换成\n
    sd '\\\\ *$' '\n' *.$suffix
    # 结尾的空格要去掉。
    sd '  *$' '' *.$suffix
    sd '^\*[ \*]*$' '' *.$suffix
    sed -i '/^$/N;/^\n$/D'  *.$suffix
}

concatSlash() {
    local f=(*.org)
    (($+1)) && f=$1
    # /xxx有时<slash>分成了2行.*/ 把它们放在一行。 /&开头的当成quote,不合并。
    # 如果/在最后一行 没有问题。t a;不跳转，正好最后一个s合并起来。与concatLines不同。
    sed -i '\,^/[^/]\+ *$,{:a N;s,^/[^/&]\+ *$,&,;t a;s/\n/ /g;}' $f
}

concatLines() {
    local f=(*.org)
    (($+1)) && f=$1
    sed -i '/^$/!{:a N;s/\n\([^\n]\+\)$/\1/;t a}' $f
}

footnote() {
    local f=(*.org)
    (($+1)) && f=$1
    # concat footnote to one line
    sed -i '/^\[\+[0-9]\+\]\+/{:a N;s/\n\([^\n]\+\)$/\1/;t a;}' $f
    # change footnote to [fn:xx] defination.
    sed -i 's/^\[\+\([0-9]\+\)\]\+\(.*\)/[fn:\1] \2/' $f
    # change footnote ref from ^{[xxx]} ^{xxx} [xx] or [[xxx]] to [fn:xxx]
    sed -i 's/\^*[{[]\+\([0-9]\+\)[]}]\+/[fn:\1]/g' $f
    # some fn ref is like 
    # sed -i 's/\[\+\([0-9]\+\)\]\+/[fn:\1]/g' $f
    # sed -i 's/\^*[{[]\+fn:\([0-9]\+\)[]}]\+/[fn:\1]/g' $f
}

foot2md() {
    footnote $1
    org2md $1
}

title2summary() {
    local usage="title2summary -c <check md file existance> -h"
    local check=0
    while {getopts ch arg} {
	      case $arg {
		      (h)
		      echo $usage
		      return;
		      ;;
		      (c)
			  check=1
			  ;;
		  }
	  }

	  i=1;
	  while {read  title} {
		    if [[ "$title" == '' ]] {continue;}
		       t=`echo $title | sd '^.*[：:|] *(.*)' '$1'`;
		       # t=$title
		       if ((check == 1)) {
			      while [[ ! -f $i.md ]] {i=$((i+1));}
			  }
			  echo "* [$t]($i.md)";
			  i=$((i+1))
		}
}

# wget_url_to out_dir url url_start fname_start
wget_url_to() {
    local force=0
    # i: 代表可以接受一个带参数的 -i 选项
    # c 代表可以接受一个不带参数的 -c 选项
    while {getopts hf arg} {
	      case $arg {
		      (h)
		      echo "IFS=' % ' wget_url_to -f out_dir url url_start fname_start"
		      return;
		      ;;
		      (f)
			  echo "set force"
			  force=1
			  ;;
		  }
	  }
	  # echo $0,$1,$2,$3;return;
	  shift $((OPTIND-1))
	  echo $OPTIND, $*
	  local out=$1
	  local urls=$2
	  local ustart=1
	  local fstart=1
	  (($+2)) && ustart=$3
	  (($+3)) && fstart=$4
	  # [[ $IFS == "\n" ]] && IFS=' % '
	  local suffix=
	  [[ $out =~ "html" ]] && suffix=".html"
	  while {read -r f url} {
		    # echo $f '--' $url;return;
		    if (( --ustart > 0)) {continue};
		       local fname=$out/$fstart$suffix
		       [[ -n "$f" ]] && fname=$out/$f
		       if [[ "$url" == '' ]] || [[ -f $fname && $force == 0 ]] {
			      echo $force ",Ignore" $fname
			      continue;
			  } else {
			      echo $fname;
			      wget -O $fname $url;
			      fstart=$((fstart+1));
			  }
		} < $urls
}

genXfile() {
    while {getopts h arg} {
	      case $arg {
		      (h)
		      echo "genXfile js-script start_x_no <default=1>"
		      return;
		      ;;
		  }
	  }
	  local ts=$1
	  local start=1
	  (($+2)) && start=$2
	  for html (../html/*.html) {
	      if (( --start > 0 )) {continue;};
		 i=`basename $html .html`
		 # echo $i
		 node $ts $html $i >X/$i.x;
	  }
}

org2md() {
    local f=$1
    if (($+1)) {
	   emacs $f --batch --eval "(require 'ox-md)" --eval "(setq org-export-with-toc nil)" --eval "(org-md-export-to-markdown)";	   
       } else {
	   for f (*.org) {
	       emacs $f --batch --eval "(require 'ox-md)" --eval "(setq org-export-with-toc nil)" --eval "(org-md-export-to-markdown)";
	   }
       }
}

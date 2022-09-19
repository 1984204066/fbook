firstCanon() {
    for f ($*) {
    [[ -d $f ]] && { echo "$f is directory"; continue;}
    #echo $f
    sed -i 'y/ ：　１２３４５６７８９０《》/ : 1234567890「」/' $f
    sed -i '/[^-][^-]*---*\|---*[^-][^-]*/s/---*/-﻿-﻿-/g' $f
    sed -i '/:PROPERTIES:.*/{:again N;s/.*:END:$//;T again;}' $f
    trimDoubleEsc $f
    trimAsterisk $f
    trimSpace $f #已经 合并空白行
    emptyBrackets $f #已经调用 合并空白行，所以不用下面再执行。
    # sed -i '/^$/N;/^\n$/D'  $f
    }
}

trimAsterisk() {
    local f=$1
    sed -i '/^[*]\+$/d' $f
}

trimDoubleEsc() {
    local f=$1
    # \\ 即是换行的意思，所以替换成\n
    sd '\\\\ *$' '\n' $f
    # 其他地方的\\直接取缔。
    sd '\\\\' '' $f    
}

trimSpace() {
    local f=$1
    # 不破坏行结构。去掉空格
    sd '^  *$' '\n' $f
    zipEmptyLine $f
    # 结尾的空格要去掉。此时开头处肯定有字符， 所以不破坏行结构。
    sd '  *$' '' $f
    # 开头的空格要去掉。
    sd '^  *' '' $f
}

#压缩空白行为一个。
zipEmptyLine() { 
    local f=$1
    sed -i '/^ *$/N;s/^ *\n\+ *$/\n/'  $f #这只是把2行合并，3行以上就不行了。
    #开头及空行删除。
    sed -i -e '1{/^$/{:a $bX;$!N;/^\n\+$/!{:X s/^\n\+//;b};ba}}' -e '/^$/N;/^\n$/D' $f 
}

emptyBrackets() {
    # sd '\(.\)>[ \*]*<\(.\)' '' $f
    local f=$1
    sed -i -e 's:(.)>[ *]*<(.)::g;' -e 's:(..)>[ *]*<(..)::g;' $f
    # sed -i '/^$/N;/^\n$/D'  $f
    trimSpace $f
    #sed -i 's%(.)>[ *]*<(.)%%g; /^$/N;s%(.)>[ *]*<(.)%%g;/^\n$/D'  $f
}

concatLines() {
    for f ($*) {
    [[ -d $f ]] && { echo "$f is directory"; continue;}
    trimSpace $f
    # 不在空白行,图片或#+功能行上 开始。但是有可能结合带空格的空白行。
    sed -i -f concatLines.sed $f
    }
}

concatSlash() {
    local f=(*.org)
    (($+1)) && f=$1
    # /xxx有时<slash>分成了2行.*/ 把它们放在一行。 /&开头的当成quote,不合并。
    # 如果/在最后一行 没有问题。t a;不跳转，正好最后一个s合并起来。与concatLines不同。
    sed -i '\,^/[^/]\+ *$,{:a N;s,^/[^/&]\+ *$,&,;t a;s/\n/ /g;}' $f
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
    local usage="IFS=' % ' wget_url_to -f <force> out_dir url url_start fname_start"
    # i: 代表可以接受一个带参数的 -i 选项
    # c 代表可以接受一个不带参数的 -c 选项
    while {getopts hf arg} {
	      case $arg {
		      (h)
		      echo $usage
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
	  (($+3)) && ustart=$3
	  (($+4)) && fstart=$4
	  # [[ $IFS == "\n" ]] && IFS=' % '
	  local suffix=
	  [[ $out =~ "html" ]] && suffix=".html"
	  while {read -r f url} {
		    # echo $f '--' $url;return;
		    if (( --ustart > 0)) {continue};
		       local fname=$out/$fstart$suffix  #只用于html
		       [[ -n "$f" ]] && fname=$out/$f
		       if [[ "$url" == '' ]] || [[ -f $fname && $force == 0 ]] {
			      echo "force="$force ",Ignore" $fname
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
		      echo "genXfile js-script start_html_no <default=1>"
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
		 echo $i
		 node $ts $html $i >X/$i.x;
	  }
}

x2org() {
   local usage="x2org inx org -h <help>
		     inx: input dir or file <default=X/>
		     org: output dir or file <default=../org/>\n"
   local dx='X/'
   local dorg='../org'
   while {getopts h arg} {
	      case $arg {
		      (h)
		      echo $usage
		      return;
		      ;;
		  }
	  }
   (($+1)) && dx=$1
   (($+2)) && dorg=$2
	 if [[ -d "$dx" && ! -d "$dorg" ]] {
	 echo "$usage in/out should be dir";return;
	 }
	    if [[ -f "$dx" ]] {
		   echo $dorg
	pandoc -f html -t org -o $dorg $dx
	return;
	}
	  for i ($dx/*.x) {
		f=$dorg/`basename $i .x`.org
	    echo $f
		pandoc -f html -t org -o $f $i
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

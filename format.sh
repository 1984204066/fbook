format_once() {
    local suffix=$1
    sed -i 'y/ ：　１２３４５６７８９０《》/ : 1234567890「」/' *.$suffix
    sed -i '/[^-][^-]*---*\|---*[^-][^-]*/s/---*/-﻿-﻿-/g' *.$suffix
    sed -i '/:PROPERTIES:.*/{:again N;s/.*:END:$//;T again;}' *.$suffix
}

format_file() {
    local suffix=$1
    sd '\\\\ *$' '' *.$suffix
    sd '^  *$' '' *.$suffix
    sd '^\*[ \*]*$' '' *.$suffix
    sed -i '/^$/N;/^\n$/D'  *.$suffix
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

getXfile() {
    while {getopts h arg} {
	      case $arg {
		      (h)
		      echo "getXfile js-script"
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
    for i (*.org) {
	emacs $i.org --batch --eval "(require 'ox-md)" --eval "(setq org-export-with-toc nil)" --eval "(org-md-export-to-markdown)";
    }
}

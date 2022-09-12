format_file() {
    local suffix=$1
    sd '\\\\$' '' *.$suffix
    sed -i 'y/ ：　１２３４５６７８９０《》/ : 1234567890「」/' *.$suffix
    sed -i '/^  *$/d' *.$suffix
    sd '^  *' ''  *.$suffix
    sed -i '/:PROPERTIES:.*/{:again N;s/.*:END:$//;T again;}' *.$suffix
    sd '^\*[ \*]*$' '' *.$suffix
    sed -i '/^$/N;/^\n$/D'  *.$suffix
    # sed -i 's/^Image$//' *.$suffix
    # fd -e .org -x  sed -i 's/\([^-][^-]*\)---*/\1-<feff>-/g'    
}

# wget_url_to out_dir url url_start fname_start
wget_url_to() {    
    # i: 代表可以接受一个带参数的 -i 选项
    # c 代表可以接受一个不带参数的 -c 选项
    while {getopts h arg} {
	      case $arg {
		      (h)
		      echo "IFS=' % ' wget_url_to out_dir url url_start fname_start"
		      return;
		      ;;
		  }
	  }
	  
	  local out=$1
	  local urls=$2
	  local ustart=1
	  local fstart=1
	  (($+2)) && ustart=$3
	  (($+3)) && fstart=$4
	  # [[ $IFS == "\n" ]] && IFS=' % '
	  local suffix=
	  [[ $out =~ "html" ]] && suffix=".html"
	  while {read -r url f} {
		    if (( --ustart > 0)) {continue};
		       local fname=$out/$fstart$suffix
		       [[ $f != "" ]] && fname=$out/$f
		       echo $fname;
		       if [[ "$url" == '' ]] {continue;} else {
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

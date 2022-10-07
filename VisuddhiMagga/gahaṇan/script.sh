talkDetail() {
    local usage="talkDetail -p prefix -s start-no file-exp
    	  	 for example: talkDetail -p 廣說地遍 -s 3 '{3..13}*廣說地遍*.docx'"
    local prefix=""
    local sno=""
    while {getopts p:s:h arg} {
	      case $arg {
		      (h)
		      echo $usage; return; ;;
		      (p)
			  prefix=$OPTARG ;;
		      (s)
			  sno=$OPTARG ;;
		  }
	  }
	  shift $((OPTIND-1))
	  local files=""
	  if (($+1)) {eval "files=($1)";} else {echo $usage; return;}

	     for i ($files) {
		 org="../org/$prefix$sno.org"
		 echo "$i -> $org";
		 # continue;

		 if [[ -d ../media/$prefix$sno ]] {
			pandoc -f docx -t org -o $org $i
		    } else {
			pandoc -f docx -t org -o $org $i --extract-media=.
			mv media ../media/$prefix$sno
		    }
		    sed -i -e '1{s/《\|》/ /g;s/\*//g;s/^/*/;}; 2,6d' -e "7s/.*/#+DATE: &\n#+macro: caudio $prefix$sno.mp3\n#+macro: DOCX $i\n#+include: preamble-macro.org\n{{{audio-docx({{{caudio}}},{{{docx}}},{{{date}}})}}}\n\n/" -e "s,media/,media/$prefix$sno/," $org
		    sno=$(($sno+1))
		    useChant $org
		    sed -i '/不净..mp3/s/廣說/广说/' $org
		    sed -i '/余遍..mp3/s/廣說/广说/' $org
	     }		  
}

useChant() {
    local files=(*.org)
    (($+1)) && eval "files=($1)"
    for org ($files) {
	if {rg -q "仅以心清除净化 *。" $org} {
	       sed -i '8s/.*/诵古德所写如下偈诵一遍\n\n#+include: chant.org\n/;9,/仅以心清除净化 *。$/d' $org
	   } elif {rg -q "犹如强风无法吹倒岩山 *。" $org} {
	       sed -i '8s/.*/诵如下偈诵一遍\n\n#+include: chant2.org\n/;9,/犹如强风无法吹倒岩山 *。$/d' $org			 
	   } elif {rg -q "心意将圆满。" $org} {
	       sed -i '/合十诵.*偈诵一遍/{s/合十诵.*偈诵一遍.*/\n\n合十诵《须菩提经》中偈诵一遍：\n\n#+include: chant3.org\n/;n; :a N;/心意将圆满。$/d; ba;}' $org			 
	   }
	   
	   if {rg -q "接下来.*定经.*" $org} {
		  sed -i '/接下来.*定经/{:a ${s/接下来.*定经.*/\n\n#+include: Sati.org\n/}; N;ba;}' $org
	      }
    }
}

changeH1() {
    local usage="changeH1 《清净道论·广说地遍》 清净道论·广说地遍 file"
    echo "changeH1 $1 $2 $3"
    sed -i "1s/^\* $1\(.*\)\*/* $2 \1/;" $3
}

renameF() {
    local usage="renamef key 1|2
    	  for example renamef 廣說地遍 1 , n廣說地遍mm.xx -> 廣說地遍n.xx
    	  for example renamef 廣說地遍 2 , n廣說地遍mm.xx -> 廣說地遍mm.xx
"
    local key=$1
    local remain=$2
    for i (*$key*) {
	local suffix=${i:e}
	if ((remain == 1)) {
	       f=`echo $i|sd '(.*)'$key'.*' "$key"'$1'".$suffix"`;
	   } else {	       
	       f=`echo $i|sd '.*('$key'.*)' '$1'`;
	   }
	   echo "$i -> $f"
	   mv $i $f
    }
}

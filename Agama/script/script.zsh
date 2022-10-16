#!/bin/zsh

Sutra() {
    local name=${"$(<&0)"}
    # echo $name
    echo $name | sed -n -f sutra_name.sed 
}

multiAgama() {
    local fname=$1
    echo "change empty line to ???"
    local text=$(sed 's/^\\$/???/' $fname)
    echo $text
    local agama=(${(s:???:)text})
    echo "has $#agama agama"
    # print -l $agama
    local ret=""
    for i ($agama) {
	local r=$(echo $i | sed -f sutra_name.sed)
	ret=$(printf '%s\n\n%s' $ret $r)
    }
    echo $ret > $fname
}

transite3Sutra() {
    if (( $# < 1)) { echo $#; return 1;}
       fname=${1:e}; echo "$1 -> $fname.md"
       pandoc -f html -t markdown -o $fname.md $1
       # change sutra name.
       if [[ $fname == 'pali' ]] {
	      sed -i "/word版/d" pali.md
	  } elif [[ $fname == 'agama' ]] {
	      multiAgama $fname.md
	  }
	  # nikaya's will be changed in mksep.js
	  sed -i 's/^\\ *$//' $fname.md
}

combineF() {
    local pre=1;
    local volume=1;
    for i ($(sed -n 's/[^0-9]*\([0-9]\+\)[^0-9]*/\1/p' miscAHan.md |sed '1,2d')) {
	for j ({$pre..$i}) {
	    f="/fbook/Agama/script/X/src/"$(printf "%04d" $j).md;
	    [[ -f $f ]] && cat $f >> "/fbook/Agama/src/"$volume.md
	}
	    pre=$((i+1))
	    volume=$((volume+1))
    }
}

modSummary() {
for i ({1..50}) {sed -i "$i"'s/(.*.md)/('"$i.md)/" tmp.md}
}

#Sutra

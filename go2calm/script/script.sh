#!/usr/bin/zsh

. /fbook/format.sh

go2calm() {
    local usage="go2calm n1..n2 <specify range, like 1..10 etc.>"
    echo "$PWD, $#"
    # :t 是取文件名，即最后一个 / 之后的部分，如果没有 / 则为字符串本身
    [[ ${PWD:t} != "script" ]] && return 1;
    (($# < 1)) && {echo "$usage"; return;}
    local range=$1
    for i ({$range}) {
	echo $i;
	x2org X/$i.x out/$i.org
	firstCanon out/$i.org
	concatLines out/$i.org
    }
}

titleFromOrg() {
    local usage="titleFromOrg n1..n2 <specify range, like 1..10 etc.>"
    (($# < 1)) && {echo "$usage"; return;}

    local range=$1
    for i ({$range}) {
	#echo $i;
	read line <out/$i.org;
	#echo $line
	echo -n $line|sd '.*' '* [$0]('"$i.md)\n"
    }    
}


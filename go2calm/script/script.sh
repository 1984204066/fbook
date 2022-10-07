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

chopTail() {
    local usage="chopTail n1..n2 <specify range, like 1..10 etc.>"
    (($# < 1)) && {echo "$usage"; return;}

    local range=$1
    for i ({$range}) {
	echo $i;
	sed -i '/连载进行中/,$d' out/$i.org;
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

modTitle() {
    local usage="modTitle n1..n2 <specify range, like 1..10 etc.>"
    (($# < 1)) && {echo "$usage"; return;}

    local range=$1
    for i ({$range}) {
	local f=out/$i.org
	sed -i -f modTitle.sed $f
    }    
}

insertMp3() {
    local usage="insertMp3 n1..n2 <specify range, like 1..10 etc.>"
    (($# < 1)) && {echo "$usage"; return;}

    local range=$1
    for i ({$range}) {
	local f=out/$i.org
	sed -i "3i<iframe frameborder='0' marginwidth='0' marginheight='0' width=500 height=86 src='./mp3/$i-0.mp3'></iframe>\n" $f;
    }    
}

historyAdd() {
    local orgs=()
    if (($+1)) {
	orgs=({$1})
	orgs=(${orgs/%/.org})
       } else {
	   orgs=(*.org)
       }
       
       local values=(${(f)"$(<&0)"})
       values=(${values/#* \% })
       #print -l $values
       local ov=(${orgs:^values})
       #print -l $ov
       for ((i=1;i<$#ov;i+=2)) {
	   local f=$ov[$i]
	   local value=$ov[$((i+1))]
	   #echo "file:$f, value:$value"
	   sed -i '1i'"$value\n\n" $f		 
       }
}

testFd() {
    urls=$(<&0)
    echo $urls
}

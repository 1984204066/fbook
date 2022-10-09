. /fbook/format.sh

footnote() {
    # local f=(*.org)
    # (($+1)) && f=$1
    for f ($*) {
	[[ -d $f ]] && { echo "$f is directory"; continue;}
	# concat footnote to one line, 但不结合下一个note.
	#sed -i '/^\[\+[0-9]\+\]\+/{:a N;s/\n\[\+[0-9]\+\]\+/&/;b;s/\n\([^\n]\+\)$/\1/;t a;}' $f
	sed -i '/注释/,$s/^[{ []*\([0-9]\+\)[] }]*/\n\n&/g' $f
	# change footnote to [fn:xx] defination.
	sed -i 's/^[{ []*\([0-9]\+\)[] }]*\(.*\)/[fn:\1] \2/' $f
	# change footnote ref from ^{[xxx]} ^{xxx} [xx] or [[xxx]] to [fn:xxx]
	sed -i 's/\^*[{ []\+\([0-9]\+\)[] }]\+/[fn:\1]/g' $f
	# some fn ref is like 
	# sed -i 's/\[\+\([0-9]\+\)\]\+/[fn:\1]/g' $f
	# sed -i 's/\^*[{[]\+fn:\([0-9]\+\)[]}]\+/[fn:\1]/g' $f
    }
}

footnoteEncoded() {
    for f ($*) {
	[[ -d $f ]] && { echo "$f is directory"; continue;}
	sed -i -f encodedFoot.sed $f
    }
}

foot2md() {
    footnote $1
    org2md $1
}

fakeWest() {
    echo $PWD
    # :t 是取文件名，即最后一个 / 之后的部分，如果没有 / 则为字符串本身
    [[ ${PWD:t} != "script" ]] && return 1;
    # set -x
    x2org X out
    firstCanon out/*.org
    footnoteEncoded out/*.org
    concatLines out/*.org
    #footnote out/*.org
    pickOrphanMarks out/*.org
    removeImg out/*.org
    outstandImg out/*.org
    concatLines out/*.org
    bold2H2 out/*.org
    decodeMarks out/*.org
    modTitle out/*.org
    # set +x
    return 0;
}

removeImg() {
    for f ($*) {
	[[ -d $f ]] && { echo "$f is directory"; continue;}
	sed -n '1br; /^-注释-$/,${:r \:./img/:{p;}}' $f >>img.del
	sed -i '1br; /^-注释-$/,${:r \:./img/:s:\[\[./img/[^]]\+\]\]::g}' $f
	#cat img.del.tmp >>img.del
    }    
}

outstandImg() {
    for file ($*) {
	[[ -d $file ]] && { echo "$file is directory"; continue;}
	#concatImgLines $file
	sed -i -f outstandImg.sed $file
	trimSpace $file
	sed -i -n -f ../script/caption.sed $file
	zipEmptyLine $file
    }
}

pickOrphanMarks() {
    for f ($*) {
	[[ -d $f ]] && { echo "$f is directory"; continue;}
	trimSpace $f
	trimDoubleEsc $f
	trimAsterisk $f
	# 在sd里*是特殊字符，故此，只删除^*****$
	# sd '^\*[ \*]*$' '' $f
	# [ \*] 含义在sd , sed中含义不一样。
	# 把左开孤立的marks聚集起来。
	sed -i -n -f orphan.sed $f
	emptyBrackets $f
	# sed -i -n -f rightBracket.sed $f
	reduceBrackets $f
	#sed -i 's,^\*[{} \*^/]*$,,' $f #会删除 *\\* 应该在concatLines后。去掉bold, italic之后
	sed -i '/^$/N;/^\n$/D'  $f
    }
}

reduceBrackets() {
    local f=$1
    # (B)意义不大。在[fn:xx]里，(E)意义不大。
    sed -i -f reduceBrackets.sed $f
}

bold2H2() {
    for f ($*) {
	sed -i -f bold2H2.sed $f
    }
}

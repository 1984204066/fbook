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

foot2md() {
    footnote $1
    org2md $1
}

fakeWest() {
    echo $PWD
    # :t 是取文件名，即最后一个 / 之后的部分，如果没有 / 则为字符串本身
    [[ ${PWD:t} != "script" ]] && return 1;
    #set -x
    x2org X out
    firstCanon out/*.org
    footnote out/*.org
    concatLines out/*.org
    #footnote out/*.org
    pickOrphanMarks out/*.org
    outstandImgFn out/*.org
    # concatLines out/*.org
       #set +x
    return 0;
}

outstandImgFn() {
    for file ($*) {
    [[ -d $file ]] && { echo "$file is directory"; continue;}
    #concatImgLines $file
    #去掉 ^/{*[[img]]*}/
    #sd '[/\{\*^]+[\[]+./img/([^]]+)[]]+[/\}\*]+' '[[./img/$1]]' $file
    #去掉 *[img][img]*
    #sd '[/\*]([\[]+./img/[^]]+\]\])+[/*]' '$1'
    sed -i -f outstandImgFn.sed $file
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
    sed -i -f orphan.sed $f
    emptyBrackets $f
    sed -i -n -f rightBracket.sed $f
    #sed -i 's,^\*[{} \*^/]*$,,' $f #会删除 *\\* 应该在concatLines后。去掉bold, italic之后
    sed -i '/^$/N;/^\n$/D'  $f
    }
}

modBold() {
    for file ($*) {
    [[ -d $file ]] && { echo "$file is directory"; continue;}
    # 结尾是*的是黑体，那么开头的** 可以去掉。
    sed -i '/.*\*$/{:a s,^\*\*,,;t a;}; s/\*\([^*]\+\)\*/<<\1>>/g' $file
    }
}

modItalic() {
    
}

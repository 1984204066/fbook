# 不在空白行,图片或#+功能行上 开始。但是有可能结合带空格的空白行。
# \,^ *$\|^#+\|/img/,!{
\,^ *$\|^#+,!{ # 允许在img上开始。
:a $!N;
# s,\n.*/img/.*,&,; t;
/\n#+.*/b; #不结合#+
/\n- .*/b; #不结合表示列表枚举的- ,
/\\\\\n[^\n]\+$/ba; #以\\结尾的不结合。

s/\([a-zA-Z]\)\n\([^\n]\+\)$/\1 \2/;t a #上一行字母结尾，加一个空格
s/\n\([a-zA-Z][^\n]\+\)$/ \1/;t a #下一行字母开头，加一个空格
s/\n\([^\n]\+\)$/\1/;t a #\n 文本行，去掉\n与上一行合并。
}

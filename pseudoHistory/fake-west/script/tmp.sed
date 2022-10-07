# footnote 定义区，第一个以1开头，或者[1],{1}等等。
/^[{ []*1[^0-9][] }]*\|^[{ []*[1①][] }]*$/,$ {
#/^[{ []*[1①][] }]*$/,$ {
#/^\[fn:1\]/, $ {

#s/\[\([0-9]\+\)\]/[fn:\1] /;

# outstanding fn:xx
# change footnote to [fn:xx] defination.
#定义不应有(P)><(P), 但是就是有，所以把它局限在第一个[1]定义之后。
s/^(P)>^*[{ []*\([0-9]\+\)[] }]*<(P)/\n\n[fn:\1] /;t; #有(P)包裹内也有可能出现^{xx}.
# 确定footnote defination. ^1994这样的不行。超过3位数字的都不行。
/^[{ ^[]*\([0-9]\+\)[] }]*/ {
h;
s/^[{ ^[]*\([0-9]\+\)[] }]*.*/\1/ #只保留开头数字部分，
/[0-9]\{4\}/{x;b}
x; #交换回来，可以作为footnote.
s/^[{ ^[]*\([0-9]\+\)[] }]*/\n\n[fn:\1] /
}
}
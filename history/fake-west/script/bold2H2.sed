/^(S)>[^><]*<(S)$/ { #(S)包裹的单独行，可能是h2.
h;
/^(S)>.\{,7\}$/{:C ;g; s/(S)/(h2)/g;b}; #11个字母以下的可以是h2,包含(S)>.

s/^(S)>\(.\{,5\}\).*$/\1/; T; #提取前5个，T是为了后面的tc做清理工作。
:a
/[一二三四五六七八大九十]/{s/^ *第\|、/&/;tC} #t只要有一个s命令成功就跳?
g;
}

/^(h.)>.*<(h.)$/ {
/^(h.)>.\{57,\}.*$/ { # too long.
s/(h.)/(S)/g
}
}
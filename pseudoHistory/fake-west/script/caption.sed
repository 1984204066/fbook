/^<div/ {
	:div N;
	\,</div>,! b div;
	p;b
	}
/img/!p;
/img/{
	:a H;
	${x;p;b}
	$!n;
	\:^$\|.*./img/: ba; #碰到img或空行,继续，直到读入文本。
	\:.*图\|^(E)>: {
	:r
	s/(S)>\([^<]*\)<(S)/\1/; t r;
	s/(P)>\([^<]*\)<(P)/\1/; t r;
	s/(E)>\([^<]*\)<(E)/\1/; t r;
	/([SPE])>/{N;br;}
	s/\n//g;
	x;G;
	s,\(.*\)\n\([^\n]\+\)$,<div class="img-caption">\n\1\n\n\2\n\n</div>\n,;
	p;b e;
	}
	#这一行不匹配，所以不放入div.
	x; s,.*,<div class="img-caption">\n&\n\n</div>\n,; # :only-img
	G;p;
	:e
	s/.*//;h; #清空H.
}

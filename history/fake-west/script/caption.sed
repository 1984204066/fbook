/img/{
	s,.*/\([^]]\+\).*,[[./img/\1]],;N;
	N;
	s,\([^\n]\+\).*\(图解.*\)$,<div class="img-caption">\n\n\1\n\n\2,;
	T only-img;
	s,[/}]*$,</div>\n,;
	s,\*,,;
	b;
	:only-img
	s,^[^\n]\+\n,<div class="img-caption">\n\n&\n</div>\n,;
	}
	
/^([SPE])/ {
s/^(S)>/*/;
s,^(E)>,/,;
s,^(P)>,^{,;
}
/([SPE])$/ {
s/<(S)$/*/;
s,<(E)$,/,;
s,<(P)$,},;
}
s/(S)>/ */g;
s,(E)>, /,g;
s,^(P)>, ^{,g;

s/<(S)/* /g;
s,<(E),/ ,g;
s,<(P),} ,g;

s/(h1)>/* /
s/(h2)>/** /
s/(h3)>/*** /
s/(h4)>/**** /
s/(h5)>/***** /
s/(h6)>/****** /

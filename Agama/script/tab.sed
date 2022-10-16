# :TD1
# # \:\n\\\\ *$\|^ *$:!{$! N; b TD1}
# \:\n\+ *$:!{$! N; b TD1}
# s:.*:<tr><td>&</td>:
# p
# s/.*//

:TD2
R 3.org
\:\n\+ *$:! b TD2
s:.*:<td>&</td></tr>\n:
p
s/.*//

# :TD2
# R 3.org;
# \:\n\+ *$: {s:.*:<td>&</td></tr>\n:; p;s/.*//;b TD2}
# b TD2 
 
 
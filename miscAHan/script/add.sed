/偈[^\n]*：$\|语母言：.*$\|^[^偈]*言：$\|告[^偈差]*：$/ {N;N}
#s/^ *["]/"\n&/
s/^ *["]\|^[ 尔]*时\|^ *佛变现\|^王已建八万/"\n&/

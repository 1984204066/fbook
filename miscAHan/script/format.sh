sed ':begin s/\[\(.*\n*\)\]$/\1/g; t; /\[[^]]*$/{:here /.*\]$/!{N; b here}; b begin}' 1.markdown

sed 's|\[\*\*\(杂阿含经[^*]*\)\*\*\]{[^}]*}$|<p style="text-align: center;"><span style="color: rgb(123, 12, 0);">\1</span></p>|' 1.md

sed 's|\[\*\*\([^*]*\)\*\*\]{[^}]*}$|<p style="text-align: center;"><span style="color: rgb(2, 30, 170);">\1</span></p>|' 1.md

sed -i 's|^\*\*.\([^][}*]\).[^}]*\**$|<p style="text-align: center;"><span style="color: rgb(2, 30, 170);">\1</span></p>|' *

sed -i 's/　/ /g' *

sed ':begin s/\[\(.*\n*\)\]$/\1/g; t; /\[[^]]*$/{:here /.*\]$/!{N; b here}; b begin}' 1.markdown

sed 's|\[\*\*\(杂阿含经[^*]*\)\*\*\]{[^}]*}$|<p style="text-align: center;"><span style="color: rgb(123, 12, 0);">\1</span></p>|' 1.md

sed 's|\[\*\*\([^*]*\)\*\*\]{[^}]*}$|<p style="text-align: center;"><span style="color: rgb(2, 30, 170);">\1</span></p>|' 1.md

sed -i 's|^\*\*.\([^][}*]\).[^}]*\**$|<p style="text-align: center;"><span style="color: rgb(2, 30, 170);">\1</span></p>|' *

sed -i 's/　/ /g' *

1. sd '.*> *[(（](.*)[)）] *<.*' '## ($1)' 卷*.md
1. sed -i 's/^  *"/"\n&/' tmp
sed -i '/偈[白佛答言：]*$/{:start N;s/\([.\n]*\)\n\n$/\1<br>\n/g;s/"$/"\n\n<\/div>\n\n/;T start;s/["“” 　]//g;s/^.*偈[白佛答言：]*\n/&\n\n<div class="poem">\n\n/}' tmp
1. sed -i '/偈[白佛答言：]*$/{N;:start N;:again s/\([.\n]*\)\n$/\1<br>/;t again;s/"$/"<\/div>/;T start;s/["“” 　]//g;s/^.*偈[白佛答言：]*\n/&<div class="poem">/}' 卷*.md

1. sed -i -f ../script/s.sed  卷*
1. sed -i 's/<div class/\n&/'  卷*.md
1. sed -i 's/^<\/div>$/&\n/' 卷*

# 去掉"
1. sed -i '/^"$/N;/^"\n  *".*"$/s/^"\n  *"/"/;/^"\n  *".*[^"]$/s/^"\n  *"//' 卷*.md

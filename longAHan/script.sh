sed -i '1i#+OPTIONS: toc:nil'
1. sed -i '1i#+OPTIONS: toc:nil num:nil' *.org
1. for i (*.org) {emacs $i --batch --eval "(require 'ox-md)" --eval "(setq org-export-with-toc nil)" --eval "(org-md-export-to-markdown)";}
1. for i (*.org) {sed -i '/.*\\\\$/{:start N;s/.*[^\\]$/&/;T start;s/$/\n\n<\/div>/;s/["“” 　]//g;s/^/<div class="poem">\n\n/;}' $i}
1.  sd "'" "" *.org


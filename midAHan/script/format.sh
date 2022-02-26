sed -i -e 1,8d -e '/分类:.*$/,$'d *
sed -i '1i#+OPTIONS: toc:1' 1.org

for i (*.org) { echo $i[10,-1];grep 《中阿含经》 $i;}
    for i ({11..20}) { echo $i; cat ZhongAHan$i.org >>../1.org}
	
emacs 1.org --eval "(use-package org  :demand   :load-path \"./lisp/org-mode/lisp\" :init (require 'org-loaddefs) :config (require 'ox-md nil t))" --eval "(org-md-export-to-markdown)" --eval "(save-buffers-kill-terminal)"

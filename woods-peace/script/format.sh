k=({'a'..'z'});j=0;for i (*) {j=$[j+1]; file=$k[$j].html;echo $file; mv $i $file}

sed -i '1,7d;9,37d;/^<<js_sponsor_ad_area>>/,$d' *.org

sed -n '/^\* /p' *.org | sed 's/^\* 尘封的足迹-*//'| gawk 'BEGIN {i=0} {i++; print "- [", $0  "](" i ".md)"}'

for i (./org-files/*.org) {emacs $i --batch --eval "(require 'ox-md)" --eval "(setq org-export-with-toc nil)" --eval "(org-md-export-to-markdown)";}

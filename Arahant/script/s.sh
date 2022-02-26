while IFS="%" read -r title url ; do num=`echo $titile | sed 's/.*连载:?\(\d\d\).*/\1/'`; echo $num; done <urls

while IFS="%" read -r title x url ; do t=`echo $title|sed 's/://g'`; num=${t#*连载}; n=$num[1,2]; ((n<=8))&&fname=1-$n; ((n==9|| n==10))&&fname=2-$n;((n>10))&&fname=$n;echo $fname; sh -c "wget -c $url -O $fname" ;done <urls

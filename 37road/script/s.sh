bash
while IFS="%" read -r x y url ; do num=`echo $x|sed 's/.*连载\([0-9][0-9]*\)：.*/\1/'`; fname=../mp3/$num.mp3; echo $fname; wget -c $url -O $fname; done < urls



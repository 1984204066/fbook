gawk '/^第/{print "- ["$2"](./"$2".md)";next} /^[0-9]/{print "  - ["$2"](./"$1$2".md)"; next;} /^$/{next} /.*/ {print "#"$0}' s.txt

gawk '/^第/{print "- ["$2"](./"$2".md)";next} /^[0-9]/{fname ="./"$1$2".md"; print "  - ["$2"]("fname")"; system ("echo "fname ">tmp"); next;} /^$/{next} /.*/ {readline fname < "tmp"; print "#"$0 | "cat >"fname;}' s.txt

sh -c 'while IFS="%" read -r x y z ; do fname=`~/hello_buddha "$x"`.mp3; wget -c $z -O $fname ; done < src/continue.md'

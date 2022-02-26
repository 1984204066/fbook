sh -c 'while IFS=" % " read -r x url ; do fname=$x.mp3; echo $fname; wget -c $url -O $fname;  done < audio-urls'

new=(`cut -d'%' -f1 audio-urls`)
old=(`cut -d'%' -f1 audio-urls.mod`)
for i ({1..$#old}) { oldf=$old[i]; newf=$new[i]; if [[ $oldf != $newf ]] { echo "$oldf"=; mv $oldf.mp3 $newf.mp3;} ;};

    for i ({7..25}) { f=$i-0.webp; if [[ -f "$f" ]] { echo $f;} }

for i ({13..25}) { f=$(($i/2))-$(($i%2)); if {test ! -f "$f"}  { mv $i-0.webp $f}; echo $f ; }

    for f (*-1) { echo $f; mv $f $f.webp}

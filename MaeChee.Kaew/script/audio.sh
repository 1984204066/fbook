sh -c 'while IFS=" % " read -r x url ; do fname=$x.mp3; echo $fname; wget -c $url -O $fname;  done < audio-urls'

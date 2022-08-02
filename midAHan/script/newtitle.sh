echo $1
gawk '
function newtitle(t, i) {
     split(t, a); for (k=1;k<=i;k++)delete a[k]; ret = ""; for( x in a) ret = ret" " a[x];
     return ret;
}
function changetitle(line, title) {
	      cmd = "sed -i \"" line "s/.*/" title "/\" " ARGV[1];
	      system(cmd);#print cmd;#
}
END {for (x in line) print line[x];}
/^\* .*/{n1=NR;volume=$2;t1=$0;}
/^\*\* .*/{if ($2 != volume) {
       	      t=newtitle($0,1); # without **
	      changetitle(NR, "** " volume t);
	      line[n1]=n1;$0 = t1; if ($3 == "") {changetitle(n1, "# " t); #t has no 第x卷
	      } else {changetitle(n1, "# " newtitle($0, 2));}	      
}}' $1

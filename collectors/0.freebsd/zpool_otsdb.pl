#!/usr/local/bin/perl -w

open FH, "zpool iostat 10|";

while (<FH>) {
    if ($_ !~ "sense" && $_ !~ "peel0") {
	next;
    } else {
	@a = split;
	foreach $i (@a) {
	    if ($i =~ /T$/) {
		chop $i;
		$i = $i * (1024**4);
	    } elsif ($i =~ /G$/) {
		chop $i;
		$i = $i * (1024**3);
	    } elsif ($i =~ /M$/) {
		chop $i;
		$i = $i * (1024**2);
	    } elsif ($i =~ /K$/) {
		chop $i;
		$i = $i * (1024*2);
	    }
	}
	
	print "zpool.free "    . time . " $a[2] zpool=$a[0]\n";
	$free = ($a[1]/$a[2])*100;
	print "zpool.pctused " . time . " $free zpool=$a[0]\n";
	print "zpool.pndgops "  . time . " $a[3] zpool=$a[0] op=read\n";
	print "zpool.pndgops "  . time . " $a[4] zpool=$a[0] op=write\n";
	print "zpool.iobw "     . time . " $a[5] zpool=$a[0] op=read\n";
	print "zpool.iobw "     . time . " $a[6] zpool=$a[0] op=write\n";
    }
}





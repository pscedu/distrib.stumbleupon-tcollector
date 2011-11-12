#!/usr/bin/perl -w

#open FH, "watch -n 5 tmstat -pl|";
#open FH, "tmstat -pl|";

while (1) {
#    open FH, "tmstat -pl|";
#    while (<FH
    $out = `tmstat -pl`;
    @lines = split('\n', $out);

    foreach $line (@lines) {
	my @a = split(':', $line);
    
	$lib = $a[2];
	$assn = $a[4];
	$drive = $a[6];
	$ivsn = $a[11];
	$blocks = $a[14];
	$info = $a[15];

	($op, $slib, ) = split(' ',$info);
	
	if ($assn =~ "assn") {
	    print "tape.iobw "    . time . " $blocks lib=$lib sublib=$slib drive=$drive ivsn=$ivsn op=$op\n";
	}
    }
    sleep 5
}

#while (<FH>) {
 
#	print "zpool.free "    . time . " $a[2] zpool=$a[0]\n";
#	$free = ($a[1]/$a[2])*100;
#	print "zpool.pctused " . time . " $free zpool=$a[0]\n";
#	print "zpool.pndgops "  . time . " $a[3] zpool=$a[0] op=read\n";
#	print "zpool.pndgops "  . time . " $a[4] zpool=$a[0] op=write\n";
#	print "zpool.iobw "     . time . " $a[5] zpool=$a[0] op=read\n";
#	print "zpool.iobw "     . time . " $a[6] zpool=$a[0] op=write\n";
 
#}





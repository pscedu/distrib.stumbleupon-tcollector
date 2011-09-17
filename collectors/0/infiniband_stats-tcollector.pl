#!/usr/bin/perl -w

$sys = "/sys/class/infiniband/";
$sleep_secs = 10;
# the stat name and data multiplier.
%ib_stats = ("port_rcv_packets",  1,
	     "port_xmit_packets", 1,
	     "port_rcv_data",     4, 
	     "port_xmit_data",    4);

# clear stats first.
$out = `/usr/sbin/perfquery -R 2>/dev/null >/dev/null`;
$out = `/usr/sbin/perfquery -R -P 255 2>/dev/null >/dev/null`;

while (1) {
    $nifs = 0;
    $date = time;
    $path = $sys . "*";
    @files = glob($path);
    foreach $ifacepath (@files) {
	{
	    $nifs++;
	    @tmp = split("/", $ifacepath);
	    $ifacename = $tmp[-1];

	    $path = $sys . $ifacename . "/ports/*";
	    @ports = glob($path);
	    foreach $portpath (@ports) {
		@tmp = split("/", $portpath);
		$portname = $tmp[-1];
				
		foreach $key (keys %ib_stats) {
		    $dpath = $portpath . "/counters/" . $key;
		
		    open FH,"<$dpath";
		    $data = <FH>;
		    close FH;
		    chomp($data);

		    # apply the multiplier and div by the sleep time
		    $ndata = ($data * ${ib_stats}{$key}) / $sleep_secs;
		    
		    #print "$ifacename $portname $dpath $data $ndata\n";
		    print "infiniband.$key $date $ndata iface=$ifacename port=$portname\n";
		}
	    }
	}
	# reset the counters since the OFED counters are unsigned 32-bit which 
	# do not wrap.
	$out = `/usr/sbin/perfquery -R 2>/dev/null >/dev/null`;
	if ($nifs > 1) {
	    $out = `/usr/sbin/perfquery -R -P 255 2>/dev/null >/dev/null`;
	}
	sleep($sleep_secs);
    }
}
    

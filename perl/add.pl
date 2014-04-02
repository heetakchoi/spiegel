#!/usr/bin/perl

use strict;
use warnings;
use lib "lib";

use Eoh::Math;
use Eoh::Net;
use Eoh::Str;

sub t_Math;
sub t_Net;
sub t_Str;

t_Math;
# t_Net;
t_Str;

sub t_Math{
    print add(1, 2), "\n";
    foreach (2..10){
	print $_ . " is ";
	unless(is_prime($_)){
	    print "not ";
	}
	print "prime.\n";
    }
}

sub t_Net{
    my %header_hash = ();
    print send_get("endofhope.com", 80, "/", \%header_hash, 0);
    print send_ssl_get("play.google.com", 443, "/store/apps/details?id=com.beatpacking.beat", \%header_hash, 1);
}

sub t_Str{
    my $content = "   blk   ";
    print "from: >" . $content . "<\n";
    print "to  : >" . trim($content) . "<\n";
}

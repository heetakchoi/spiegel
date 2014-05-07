#!/usr/bin/perl

use strict;
use warnings;
use lib "lib";

use Eoh::Math;
use Eoh::Net;
use Eoh::Stat;
use Eoh::Str("trim");
use Eoh::Prime;

sub t_Math;
sub t_Net;
sub t_Str;
sub t_Stat;

# t_Net;
# t_Str;
# t_Math;
# t_Stat;
# t_Prime;

t_Prime(shift);

sub t_Prime{

    my $prime = Eoh::Prime->new("../data/primes.txt");
    # $prime->construct_primes(123456);

    my $candidate = shift;
    $candidate = 7 unless(defined($candidate));
	print $candidate." is ";
    if($prime->is_prime($candidate)){
		print "PRIME.\n";
    }else{
		print "NOT PRIME.\n";
    }
}

sub t_Stat{
    my $stat = Eoh::Stat->new((1..10));
    print "mean: ", $stat->get_mean(), "\n";
    print "variance: ", $stat->get_variance(), "\n";
    print "standard deviation: ", $stat->get_standard_deviation(), "\n";
}
sub t_Math{
    print Eoh::Math->add(1, 2), "\n";
    my $math = Eoh::Math->new();
    foreach (2..10){
    	print $_ . " is ";
    	unless($math->is_prime($_)){
    	    print "not ";
    	}
    	print "prime.\n";
    }
}
sub t_Net{
    my $net = Eoh::Net->new();
    my %header_hash = ();
    print $net->send_get("www.naver.com", 80, "/", \%header_hash, 1);
    print $net->send_ssl_get("play.google.com", 443, "/store/apps/collection/topselling_free", \%header_hash, 0);
}
sub t_Str{
    my $content = "   blk   ";
    print "from: >" . $content . "<\n";
    print "to  : >" . trim($content) . "<\n";
}

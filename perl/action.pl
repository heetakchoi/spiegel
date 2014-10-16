#!/usr/bin/perl

use strict;
use warnings;
use lib "lib";

use Eoh::Math;
use Eoh::Net;
use Eoh::Stat;
use Eoh::Str("trim");
use Eoh::Prime;
use Eoh::Time("get_ymd");
use Decision::Monte("select");

sub t_Math;
sub t_Net;
sub t_Str;
sub t_Stat;
sub t_Time;
sub t_Download;
sub t_Select;

# t_Net;
# t_Str;
# t_Math;
# t_Stat;
# t_Prime(shift);
# t_factorization;

# foreach ( (-3..-1) ){
# 	print get_ymd($_), "\n";
# }

    t_Select;

sub t_factorization{
	my $prime = Eoh::Prime->new("../data/primes.txt");
	my $candidate = shift;
	$candidate = 360 unless(defined($candidate));
	my %bphash = ();
	$prime->factorization($candidate, \%bphash);
	print "$candidate is composed by\n";
	foreach my $key ( keys %bphash ){
		print "  $key ^ $bphash{$key}\n";
	}
}

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
# my $number = 3;
# print $number. ": ". $prime->get_least_prime($number) ."\n";
    foreach my $number ( (2..22) ){
		print $number. ": ". $prime->get_least_prime($number) ."\n";
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
    # print $net->send_get("www.naver.com", 80, "/", \%header_hash, 1);
    # print $net->send_ssl_get("play.google.com", 443, "/store/apps/collection/topselling_free", \%header_hash, 0);
	my %param_hash = (
		"한글"=>"한국",
		"우리"=>"나라",
		);
	print $net->send_post("endofhope.com", 80, "/info.cgi", \%param_hash, \%header_hash, 1);
}
sub t_Str{
    my $content = "   blk   ";
    print "from: >" . $content . "<\n";
    print "to  : >" . trim($content) . "<\n";
}
sub t_Select{
    my @base_array = (1..45);
    my %win_hash = ();
    foreach ( (1..6) ){
	my $part = select(\@base_array, 1);
	$win_hash{$part} = 1;
    }
    print "Current win numbers is ";
    foreach (sort {$a<=>$b} keys %win_hash){
	print $_, " ";
    }
    print "\n";
    foreach my $try_number ( 1..10000000) {
	print "[", $try_number, "]";
	@base_array = (1..45);
	my $fail_flag = 0;
	foreach ( (1..6) ){
	    my $current = select(\@base_array, 1);
	    if($win_hash{$current}){

	    }else{
		print "[F][", $_, "]\n";
		$fail_flag = 1;
		last;
	    }
	}
	unless($fail_flag){
	    print "Congraturation!\n";
	    print "You win at ", $try_number, "th.\n";
	    last;
	}
    }
}

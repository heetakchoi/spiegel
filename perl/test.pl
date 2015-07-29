#!/usr/bin/perl

use strict;
use warnings;

use lib "lib";
use Spiegel::Util("trim", "get_ymd");
use Spiegel::Net("send_get", "send_post", "send_ssl_get");
use Spiegel::Prime;
use Spiegel::TPC;

sub test_util_trim;
sub test_util_get_ymd;

sub test_net_send_get;
sub test_net_send_post;
sub test_net_send_ssl_get;

sub test_prime;

sub test_tpc;

# test_util_trim(" 안녕하세요 세계 ");
# test_util_get_ymd(-1);

# test_net_send_get("endofhope.com", 80, 
# 		  "/info.cgi?A=a&B=b", {}, 
#     1, 0);

# my %parammap = ( "A"=>"a", "B"=>"b" );
# test_net_send_post("endofhope.com", 80, 
#     "/info.cgi", \%parammap, undef, {}, 
#     1, 0);

# test_net_send_ssl_get("play.google.com", 443, 
#     "/store/apps", {}, 
#     1, 1);

# test_prime;

test_tpc;

sub test_tpc{
    my $tpc = Spiegel::TPC->new();
    foreach my $one ( (2..9) ){
	$tpc->set( $one, $one*2 );
    }
    print "Key (2..9) and Value key*2\n";
    foreach my $key ( sort {$a<=>$b} $tpc->set_keys ){
	printf "key : %s, val : %s\n", $key, $tpc->get($key);
    }
    foreach my $one ( (2..9) ){
	foreach my $two( (1..9) ){
	    $tpc->list_add($one, $one*$two);
	}
    }
    print "Key (2..9) and list ( key* (1..9) )\n";
    foreach my $key ( sort {$a<=>$b} $tpc->list_keys ){
	printf "key : %s\n", $key;
	foreach my $val ($tpc->list_get($key)){
	    print "  $val";
	}
	print "\n";
    }
}

sub test_util_trim{
    my ($arg) = @_;
    printf "test_trim(->%s<-)= ->%s<-\n", $arg, trim($arg);
}
sub test_util_get_ymd{
    my ($arg) = @_;
    printf "today after %d day is %s\n", $arg, get_ymd($arg);
}
sub test_net_send_get{
    my ($host, $port, 
	$req_uri, $ref_headermap, 
	$brief_flag, $debug_flag) = @_;
    print send_get($host, $port, 
		   $req_uri, $ref_headermap, 
		   $brief_flag, $debug_flag);
}
sub test_net_send_post{
    my ($host, $port, 
	$req_uri, $ref_parammap, $payload, $ref_headermap, 
	$brief_flag, $debug_flag) = @_;
    print send_post($host, $port, 
		    $req_uri, $ref_headermap, $payload, $ref_headermap, 
		    $brief_flag, $debug_flag);
}
sub test_net_send_ssl_get{
    my ($host, $port, 
	$req_uri, $ref_headermap, 
	$brief_flag, $debug_flag) = @_;
    print send_ssl_get($host, $port, 
		       $req_uri, $ref_headermap, 
		       $brief_flag, $debug_flag);
}
sub test_prime{
    my $prime = Spiegel::Prime->new("../data/primes.txt");
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

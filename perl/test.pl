#!/usr/bin/perl

use strict;
use warnings;

use lib "lib";
use Spiegel::Util("trim", "get_ymd");
use Spiegel::Net("send_get", "send_post", "send_ssl_get", "send_ssl_post");
use Spiegel::Prime;

sub test_util_trim;
sub test_util_get_ymd;

sub test_net_send_get;
sub test_net_send_post;
sub test_net_send_ssl_get;

sub test_prime;

my %one_parammap = (
    "q"=>"launcher",
    "c"=>"apps",
    );
my $payload = undef;
my %one_headermap = ();
print send_ssl_post("play.google.com", 443,
		    "/store/search", \%one_parammap, $payload, \%one_headermap,
		    1, 1);

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

sub test_util_trim{
    my ($arg) = @_;
    printf "test_trim(->%s<-)= ->%s<-\n", $arg, trim($arg);
}
sub test_util_get_ymd{
    my ($arg) = @_;
    printf "today after %d day is %s\n", $arg, get_ymd($arg);
}
sub test_net_send_get{
    my ($host, $port, $req_uri, $ref_headermap,	$brief_flag, $debug_flag) = @_;
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
sub test_net_send_ssl_post{
    my ($host, $port, 
	$req_uri, $ref_parammap, $payload, $ref_headermap, 
	$brief_flag, $debug_flag) = @_;
    print send_ssl_post($host, $port, 
			$req_uri, $ref_parammap, $payload, $ref_headermap, 
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

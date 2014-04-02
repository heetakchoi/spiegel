#!/usr/bin/perl

use strict;
use warnings;

use Exporter ("import");
our @EXPORT_OK = qw(send_get send_ssl_get);

use IO::Socket::INET;
use IO::Socket::SSL;
use Mozilla::CA;

$| = 1;
################################################################################
sub send_ssl_get{
    my ($host, $port, $req_uri, $ref_headermap, $brief_flag) = @_;
    my $response = "";
    my $socket = IO::Socket::SSL->new(
	PeerHost => "$host:$port",
	SSL_verify_mode => 0x02,
	SSL_ca_file => Mozilla::CA::SSL_ca_file(),
	)
	|| die "Can't connect: $@";

    $socket->verify_hostname($host, "http")
	|| die "hostname verification failure";

    my %headermap = %{$ref_headermap};
    unless(defined($headermap{"Host"})){
	$headermap{"Host"} = $host;
    }
    unless(defined($headermap{"Connection"})){
	$headermap{"Connection"} = "close";
    }

    print $socket "GET $req_uri HTTP/1.1\r\n";

    foreach my $headerkey (keys %headermap){
	print $socket "$headerkey: $headermap{$headerkey}\r\n";
    }
    print $socket "\r\n";

    while(my $line=<$socket>){
	$response = $response . $line;
    }

    shutdown($socket, 2);

    my $chunked_flag = 0;
    my $index_of_crlfcrlf = index($response, "\r\n\r\n");
    my $response_header_part = substr($response, 0, $index_of_crlfcrlf);
    my $response_body_part = substr($response, $index_of_crlfcrlf+4);

    my @response_headers = split(/\r\n/, $response_header_part);
    foreach my $response_header (@response_headers){
	if($response_header =~ m/Transfer-Encoding/
	   && $response_header =~ m/chunked/){
	    $chunked_flag = 1;
	    last;
	}
    }

    if($chunked_flag){
	$response_body_part = unchunk($response_body_part);
    }

    if($brief_flag){
	return $response_body_part;
    }else{
	return $response;
    }
}
################################################################################
sub send_get{
    my ($host, $port, $req_uri, $ref_headermap, $brief_flag) = @_;
    my $response = "";

    my $socket = new IO::Socket::INET(
	PeerHost=>$host,
	PeerPort=>$port,
	Proto=>"tcp"
	) or die "Error in socket creation: $!\n";

    my %headermap = %{$ref_headermap};
    unless(defined($headermap{"Host"})){
	$headermap{"Host"} = $host;
    }
    unless(defined($headermap{"Connection"})){
	$headermap{"Connection"} = "close";
    }

    print $socket "GET $req_uri HTTP/1.1\r\n";

    foreach my $headerkey (keys %headermap){
	print $socket "$headerkey: $headermap{$headerkey}\r\n";
    }
    print $socket "\r\n";

    while(my $line=<$socket>){
	$response = $response . $line;
    }

    shutdown($socket, 2);

    my $chunked_flag = 0;
    my $index_of_crlfcrlf = index($response, "\r\n\r\n");
    my $response_header_part = substr($response, 0, $index_of_crlfcrlf);
    my $response_body_part = substr($response, $index_of_crlfcrlf+4);

    my @response_headers = split(/\r\n/, $response_header_part);
    foreach my $response_header (@response_headers){
	if($response_header =~ m/Transfer-Encoding/
	   && $response_header =~ m/chunked/){
	    $chunked_flag = 1;
	    last;
	}
    }

    if($chunked_flag){
	$response_body_part = unchunk($response_body_part);
    }

    if($brief_flag){
	return $response_body_part;
    }else{
	return $response;
    }
}
################################################################################
sub unchunk{
    my ($chunked) = @_;
    my @lines = split(/\r\n/, $chunked);

    my $unchunked = "";

    my $chunk_size_expected = hex(shift(@lines));
    my $processed_chunk_size = 0;
    while(1){
	my $current_line = shift(@lines);
	unless(defined($current_line)){
	    last;
	}
	$unchunked = $unchunked . $current_line . "\n";
	$processed_chunk_size += length($current_line);

	if($processed_chunk_size >= $chunk_size_expected){
	    $chunk_size_expected = hex(shift(@lines));
	    $processed_chunk_size = 0;
	}
	if($chunk_size_expected == 0){
	    last;
	}
    }
    return $unchunked;
}
################################################################################
sub trim {
  my @result = @_;

  foreach (@result) {
    s/^\s+//;
    s/\s+$//;
  }

  return wantarray ? @result : $result[0];
}
################################################################################

return "Eoh::Net";

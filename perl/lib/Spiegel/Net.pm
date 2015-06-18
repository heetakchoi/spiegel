package Spiegel::Net;

use strict;
use warnings;

use IO::Socket::INET;
use IO::Socket::SSL;
use Mozilla::CA;
use URI::Escape;

use Exporter ("import");
our @EXPORT_OK = ("send_get", "send_post", "send_ssl_get");

$| = 1;

sub send_get{
    my ($host, $port, 
	$req_uri, $ref_headermap, 
	$brief_flag, $debug_flag) = @_;

    my $response = "";
    my $socket = new IO::Socket::INET(
	PeerHost=>$host,
	PeerPort=>$port,
	Proto=>"tcp"
	) or die "Error in socket creation: $!\n";

    my %headermap = %{$ref_headermap};
    unless(defined($headermap{"Host"})){
	if($port eq "80"){
	    $headermap{"Host"} = sprintf("%s", $host);
	}else{
	    $headermap{"Host"} = sprintf("%s:%d", $host, $port);
	}
    }
    unless(defined($headermap{"Connection"})){
	$headermap{"Connection"} = "close";
    }

    print $socket "GET $req_uri HTTP/1.1\r\n";
    print "== DEBUG INFO ==\n" if($debug_flag);
    print "GET $req_uri HTTP/1.1\r\n" if($debug_flag);

    foreach my $headerkey (keys %headermap){
	print $socket "$headerkey: $headermap{$headerkey}\r\n";
	print "$headerkey: $headermap{$headerkey}\r\n" if($debug_flag);
    }
    print $socket "\r\n";
    print "\r\n" if($debug_flag);
    print "== DEBUG INFO ==\n" if($debug_flag);

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

sub send_post{
    my ($host, $port, 
	$req_uri, $ref_parammap, $payload, $ref_headermap, 
	$brief_flag, $debug_flag) = @_;
    my $response = "";

    my $request_line = "POST $req_uri HTTP/1.1\r\n";
    my %headermap = %{$ref_headermap};
    unless(defined($headermap{"Host"})){
	if($port eq "80"){
	    $headermap{"Host"} = sprintf("%s", $host);
	}else{
	    $headermap{"Host"} = sprintf("%s:%d", $host, $port);
	}
    }
    unless(defined($headermap{"Connection"})){
	$headermap{"Connection"} = "close";
    }
    unless(defined($headermap{"Content-Type"})){
	$headermap{"Content-Type"} = "application/x-www-form-urlencoded";
    }

    my $body_str = "";
    my %parammap = %{$ref_parammap};
    my $first_flag = 1;
    foreach my $paramkey (keys %parammap){
	my $paramvalue = $parammap{$paramkey};
	if($first_flag){
	    $first_flag = 0;
	}else{
	    $body_str .= "&";
	}
	my $param_pair = uri_escape($paramkey) . "=" . uri_escape($paramvalue);
	$body_str .= $param_pair;
    }
    if(defined($payload)){
	$body_str = $payload;
    }
    my $body_size = length($body_str);
    $headermap{"Content-Length"} = $body_size;

    my $header_str = "";
    foreach my $headerkey (keys %headermap){
	$header_str .= "$headerkey: $headermap{$headerkey}\r\n";
    }

    my $socket = new IO::Socket::INET(
	PeerHost=>$host,
	PeerPort=>$port,
	Proto=>"tcp"
	) or die "Error in socket creation: $!\n";
    print $socket $request_line;
    print $socket $header_str;
    print $socket "\r\n";
    print $socket $body_str;

    if($debug_flag){
	print "== DEBUG INFO ==\n" if($debug_flag);
	print $request_line;
	print $header_str;
	print "\r\n";
	print $body_str;
	print "\n== DEBUG INFO ==\n" if($debug_flag);
    }

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

sub send_ssl_get{
    my ($host, $port, 
	$req_uri, $ref_headermap, 
	$brief_flag, $debug_flag) = @_;

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
	if($port eq "80"){
	    $headermap{"Host"} = sprintf("%s", $host);
	}else{
	    $headermap{"Host"} = sprintf("%s:%d", $host, $port);
	}
    }
    unless(defined($headermap{"Connection"})){
	$headermap{"Connection"} = "close";
    }

    print $socket "GET $req_uri HTTP/1.1\r\n";
    print "== DEBUG INFO ==\n" if($debug_flag);
    print "GET $req_uri HTTP/1.1\r\n" if($debug_flag);

    foreach my $headerkey (keys %headermap){
	print $socket "$headerkey: $headermap{$headerkey}\r\n";
	print "$headerkey: $headermap{$headerkey}\r\n" if($debug_flag);
    }
    print $socket "\r\n";
    print "\r\n" if($debug_flag);
    print "== DEBUG INFO ==\n" if($debug_flag);

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

return "Spiegel::Net";

#!/usr/bin/perl

use strict;
use warnings;

use lib "lib";
use Spiegel::PNet;
use Spiegel::Json;

my $pnet = Spiegel::PNet->new;
my $json = Spiegel::Json->new;

my %headermap = ();
my $rawdata = $pnet->send_get("endofhope.com", 80, "/php/instagram10.php", \%headermap, 1);
my @lines = split( /\n/, $rawdata);

my $data = "";
my $flag = 0;
foreach (@lines){
    if(length($_)>0){
	if($flag){
	    if(length($_)<6){
		next;
	    }
	    $data .= $_;
	}
    }else{
	unless($flag){
	    $flag = 1;
	}
    }
}
# print $data;

my $json_txt = $data;
my @pictures = ();
my @captions = ();
my @ymds = ();

$json->load_text($json_txt);
my $init_node = $json->parse;
my $next_url = $init_node->get("pagination")->get("next_url");
my @data = $init_node->get("data")->array_gets();
foreach (@data){
    printf "%s\n", $_->get("images")->get("standard_resolution")->get("url")->get;
}

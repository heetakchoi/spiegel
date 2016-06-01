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

foreach (@lines){
    print "@@@@@@@@@@@@@@\n";
    printf "\n%s\n", $_;
}

my $json_txt = join("", @lines);

my @pictures = ();
my @captions = ();
my @ymds = ();

print $json_txt;

$json->load_text($json_txt);
my $init_node = $json->parse;
my $next_url = $init_node->get("pagination")->get("next_url");
my @data = $init_node->get("data")->array_gets();

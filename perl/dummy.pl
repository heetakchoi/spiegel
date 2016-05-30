#!/usr/bin/perl

use strict;
use warnings;

use lib "lib";
use Spiegel::Json;

sub test_json;

test_json;

sub test_json{
    my $json = Spiegel::Json->new;
    $json->load_file("/cygdrive/c/home/repos/spiegel/perl/data.txt");
    my $init_node = $json->parse;
    my @data = $init_node->get("data")->array_gets();
    foreach (@data){
	printf "%s\n", $_->get("images")->get("standard_resolution")->get("url")->get;
    }
}

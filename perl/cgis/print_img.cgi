#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $q = CGI->new;

my $buffer_size = 4096;
my $filepath = $q->param("filepath");
my( $type ) = $filepath =~ /\.(\w+)$/;
$type eq "jpg" and $type = "jpeg";

print $q->header( -type => "image/$type", -expires => "-1d" );
binmode STDOUT;

local *IMAGE;
my $buffer = "";
open IMAGE, "$filepath" or die "Cannot open file $filepath: $!";
while ( read( IMAGE, $buffer, $buffer_size ) ) {
    print $buffer;
}
close IMAGE;

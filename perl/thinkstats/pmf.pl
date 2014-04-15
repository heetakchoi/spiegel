#!/usr/bin/perl

use strict;
use warnings;

use lib "../lib";
use Eoh::Pmf;
use Chart::Clicker;
use Chart::Clicker::Context;
use Chart::Clicker::Renderer::Bar;

my %data_hash = (
    7=>8,   12=>8, 17=>14, 22=>4, 27=>6, 
    32=>12, 37=>8, 42=>3,  47=>2
    );

my $pmf = Eoh::Pmf->new();
$pmf->set_from_hash(\%data_hash);
print "mean: ", $pmf->get_mean(), "\n";

# my $pmf = Eoh::Pmf->new( (1, 2, 2, 3, 4, 5, 5, 5) );
# foreach ( (1,2,3,4,5, 6) ){
#     print $_, " : " , $pmf->get_freq($_) , "\n";
# }
# $pmf->reset_data( (1,2,2,3,3,3,4,4,4,4,5,5,5,5,5) );
# foreach ( (1,2,3,4,5, 6) ){
#     print $_, " : " , $pmf->get_freq($_) , "\n";
# }

# print $pmf->get_values(), "\n";
# print $pmf->get_hist(), "\n";
# print $pmf->get_mode(), "\n";
# foreach ( (1,2,3,4,5, 6) ){
#     print $_, " : " , $pmf->get_prob($_) , "\n";
# }

my $cc = Chart::Clicker->new();
my %hist_hash = $pmf->get_hist();
$cc->add_data("pmf", \%hist_hash);

my $def = $cc->get_context('default');
my $area = Chart::Clicker::Renderer::Bar->new();
# $def->range_axis->format('%d');
$def->domain_axis->format('%d');
$def->renderer($area);

$cc->write_output('bar.png');

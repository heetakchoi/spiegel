package Eoh::Pmf;

use strict;
use warnings;

sub new{
    my ($class) = shift;
    my $self = {};
    ${$self}{"data"} = \@_;

    my %hist_hash = ();
    

    bless($self, $class);
    return $self;
}

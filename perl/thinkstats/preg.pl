#!/usr/bin/perl

use strict;
use warnings;

{
    package FemPreg;

    sub new{
	my ($class) = @_;
	my $self = {};
	my $size = 0;
	open(my $fh_r, "<", "2002FemPreg.dat");
	while(<$fh_r>){
	    $size ++;
	}
	close($fh_r);	
	${$self}{"size"} = $size;
	bless($self, $class);
	return $self;
    }

    sub get_size{
	my $self = shift;
	return ${$self}{"size"};
    }
}

my $femPreg = FemPreg->new();
print "FemPreg.size: ". $femPreg->get_size() ."\n";

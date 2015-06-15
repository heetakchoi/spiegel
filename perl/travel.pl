#!/usr/bin/perl

use strict;
use warnings;

sub add_children

my ($start_value, $end_value) = (0, 5);

my $root = Node->new(undef, $start_value);


{
    package Node;
    use strict;
    use warnings;
    sub new{
	my ($class, $parent, $value) = @_;
	$my $self = {};
	$self->{"parent"} = $parent;
	$self->{"value"} = $value;
	bless($self, $class);
	return $self;
    }
    sub parnet{
	my ($self, $neo) = @_;
	$self->{"parent"} = $neo if(defined($neo));
	return $self->{"parent"};
    }
    sub value{
	my ($self, $neo) = @_;
	$self->{"value"} = $neo if(defined($neo));
	return $self->{"value"};
    }
}

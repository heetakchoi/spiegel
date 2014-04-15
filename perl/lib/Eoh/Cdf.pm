package Eoh::Cdf;

use strict;
use warnings;

sub new{
    my $class = shift;
    my $self = ();
    internal_init_from_data($self, @_);

    bless($self, $class);
    return $self;
}
sub set_from_hash{
    my $self = shift;
    my $arg = shift;
    my %hash = %{$arg};
    my @elements = ();
    foreach my $key (keys %hash){
	my $count = $hash{$key};
	foreach ( 1..$count ){
	    push(@elements, $key);
	}
    }
    internal_init_from_data($self, @elements);
    return $self;
}
sub get_cdf{
    my $self = shift;
    my $arg = shift;

}

sub internal_init_from_data{
    my $self = shift;
    my @elements = @_;
    my %hist_hash = ();
    foreach my $key ( @elements ){
	if(defined($hist_hash{$key})){
	    $hist_hash{$key} += 1;
	}else{
	    $hist_hash{$key} = 1;
	}
    }

    $self->{"data"} = \@elements;
    $self->{"hist"} = \%hist_hash;
}

package Eoh::Stat;

use strict;
use warnings;

sub new{
    my ($class) = shift;
    my $self = {};
    $self->{"data"} = \@_;
    bless($self, $class);
    return $self;
}
sub get_mean{
    my $arg = shift;
    my @elements;
    if(ref $arg){
	@elements = @{$arg->{"data"}};
    }else{
	my $class = $_;
	@elements = @_;
    }
    return internal_get_mean(@elements);
}
sub get_variance{
    my $arg = shift;
    my @elements;
    if(ref $arg){
	@elements = @{$arg->{"data"}};
    }else{
	@elements = @_;
    }
    return internal_get_variance(@elements);
}
sub get_standard_deviation{
    my $arg = shift;
    my @elements;
    if(ref $arg){
	@elements = @{$arg->{"data"}};
    }else{
	@elements = @_;
    }
    return internal_get_standard_deviation(@elements);
}

sub internal_get_mean{
    my @elements = @_;
    my $sum = 0;
    foreach (@elements){
	$sum += $_;
    }
    return ($sum/scalar(@elements));    
}
sub internal_get_variance{
    my @elements = @_;
    my $mean = internal_get_mean(@elements);
    my $sum_of_diff_square = 0;
    foreach (@elements){
	my $diff = ($_ - $mean);
	$sum_of_diff_square += $diff**2;
    }
    return ($sum_of_diff_square/scalar(@elements));
}
sub internal_get_standard_deviation{
    return sqrt(internal_get_variance(@_));
}

return "Eoh::Stat";

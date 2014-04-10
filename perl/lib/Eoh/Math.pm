package Eoh::Math;

use strict;
use warnings;

sub new{
    my ($class) = @_;
    my $self = {};
    bless($self, $class);
    return $self;
}

sub get_mean{
    my ($class_or_self, @elements) = @_;
    return internal_get_mean(@elements);
}
sub get_variance{
    my ($class_or_self, @elements) = @_;
    return internal_get_variance(@elements);
}
sub get_standard_deviation{
    my ($class_or_self, @elements) = @_;
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

sub add{
    my ($class_or_self, $left, $right) = @_;
    return ($left + $right);
}

sub is_prime{
    my ($class_or_self, $number) = @_;
    my $sqrt_number = sqrt($number);
    my $flag = 1;
    foreach (2..$sqrt_number){
	if($number % $_ == 0){
	    $flag = 0;
	    last;
	}
    }
    return $flag;
}

return "Eoh::Math";


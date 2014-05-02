package Eoh::Math;

use strict;
use warnings;

use bignum;

sub new{
    my ($class) = @_;
    my $self = {};
    bless($self, $class);
    return $self;
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
sub get_divisor_size{
    my ($class_or_self, $number) = @_;
    my $count = 0;
    my $sqrt_number = sqrt($number);
    foreach my $divisor (1..$sqrt_number){
	if($number % $divisor == 0){
	    my $quotient = $number / $divisor;
	    $count += 2;
	    if($divisor == $quotient){
		$count -= 1;
	    }
	}
    }
    return $count;
}

sub combination{
	my ($class_or_self, $left, $right) = @_;
	return internal_factorial($left) / ( internal_factorial($right) * internal_factorial($left-$right));
}

sub factorial{
	my ($class_or_self, $number) = @_;
	return internal_factorial($number);
}

sub internal_factorial{
	my $number = $_[0];
	my $result = 1;
	foreach my $idx ( (1..$number) ){
		$result *= $idx;
	}
	return $result;	
}

return "Eoh::Math";


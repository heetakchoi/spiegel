package Eoh::Math;

use strict;
use warnings;

sub new{
    my ($class) = @_;
    my $self = {};
    bless($self, $class);
    return $self;
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
sub get_divisor_size{
    my ($class_or_self, $number) = @_;
    my $count = 0;
    my $sqrt_number = sqrt($number);
    foreach (1..$sqrt_number){
	if($number % $_ == 0){
	    $count += 2;
	}
    }
    if($number % $sqrt_number == 0){
	$count = $count -1;
    }
    return $count;
}


return "Eoh::Math";


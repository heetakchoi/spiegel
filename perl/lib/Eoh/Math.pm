#!/usr/bin/perl

use strict;
use warnings;

use Exporter ("import");
our @EXPORT_OK = ("add", "is_prime");

################################################################################
sub add{
    my ($left, $right) = @_;
    return ($left + $right);
}
################################################################################
sub is_prime{
    my $number = $_[0];
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
################################################################################

return "Eoh::Math";


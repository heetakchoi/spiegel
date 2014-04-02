#!/usr/bin/perl

use strict;
use warnings;

use Exporter ("import");
our @EXPORT_OK = ("add");

sub add{
    my ($left, $right) = @_;
    return ($left + $right);
}

return "Eoh::Math";


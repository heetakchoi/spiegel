package Decision::Monte;

use strict;
use warnings;

use bignum;
use Exporter ("import");
our @EXPORT_OK = ("select");

sub select{
    my ($ref_array, $remove_flag) = @_;
    my $array_size = scalar(@{$ref_array});
    my $index = int(rand($array_size));
    my $value = ${$ref_array}[$index];
    if($remove_flag){
	splice @{$ref_array}, $index, 1;
    }
    return $value;
}

return "Decision::Monte";



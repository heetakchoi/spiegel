package Eoh::Time;

use strict;
use warnings;

use Exporter ("import");
our @EXPORT_OK = ("get_ymd");

################################################################################
sub get_ymd{
    my ($day) = @_;
    my $rightnow = time + (24*60*60)*$day;

    my $ymd = sprintf "%04d%02d%02d"
        , (localtime $rightnow) [5] + 1900
        , (localtime $rightnow) [4] + 1
        , (localtime $rightnow) [3];
    return $ymd;
}
################################################################################

return "Eoh::Time";

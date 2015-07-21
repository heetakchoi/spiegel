package Spiegel::Util;

use strict;
use warnings;

use Exporter ("import");
our @EXPORT_OK = ("trim", "get_ymd", "get_epoch");

################################################################################
sub trim {
  my @result = @_;

  foreach (@result) {
    s/^\s+//;
    s/\s+$//;
  }

  return wantarray ? @result : $result[0];
}
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
sub get_epoch{
    my ($ymd) = @_;
    my $year = substr($ymd, 0, 4);
    my $mm = substr($ymd, 4, 2);
    my $dd = substr($ymd, 6, 2);

    my $epoch_time = timelocal(0,0,0,$dd,$mm-1,$year-1900);
    $epoch_time += 32400;
    return $epoch_time;
}

return "Spiegel::Util";

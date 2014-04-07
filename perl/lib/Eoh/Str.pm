package Eoh::Str;

use strict;
use warnings;

use Exporter ("import");
our @EXPORT_OK = ("trim");

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

return "Eoh::Str";

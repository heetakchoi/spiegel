package FemPreg;

use strict;
use warnings;

use Eoh::Str ("trim");

sub new{
    my ($class, $raw_data) = @_;
    my $self = {};
    ${$self}{"raw_data"} = $raw_data;
    bless($self, $class);
    return $self;
}
# caseid
# 정수로 표현된 응답자의 ID
sub get_caseid{
    my $self = shift;
    return trim(substr(${$self}{"raw_data"}, 0, 12));
}

# outcome
# 정수로 표현된 임신 후 출산 여부
# 정상 출산인 경우 1
sub get_outcome{
    my $self = shift;
    return trim(substr(${$self}{"raw_data"}, 276, 1));
}

# birthord
# 정상출산된 아이의 순서를 정수로 표시
# 첫 아이인 경우 1, 유산된 경우 0
sub get_birthord{
    my $self = shift;
    return trim(substr(${$self}{"raw_data"}, 277, 2));
}
# prglength
# 정수로 표현된 임신 기간 (주 단위)
sub get_prglength{
    my $self = shift;
    return trim(substr(${$self}{"raw_data"}, 274, 2));
}

return "FemPreg";

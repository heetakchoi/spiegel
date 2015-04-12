package Category;

use strict;
use warnings;

sub new{
    my ($class, $srno, $category_name, $created) = @_;
    my $self = {};
    $self->{"srno"} = $srno;
    $self->{"category_name"} = $category_name;
    $self->{"created"} = $created;
    bless($self, $class);
    return $self;
}
sub srno{
    my ($self, $neo) = @_;
    $self->{"srno"} = $neo if(defined($neo));
    return $self->{"srno"};
}
sub category_name{
    my ($self, $neo) = @_;
    $self->{"category_name"} = $neo if(defined($neo));
    return $self->{"category_name"};
}
sub created{
    my ($self, $neo) = @_;
    $self->{"created"} = $neo if(defined($neo));
    return $self->{"created"};
}

"Category.pm";

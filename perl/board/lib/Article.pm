package Article;

use strict;
use warnings;

sub new {
    my ($class, $srno, $created, $ymd, $status, $title, $content, $category_srno) = @_;
    my $self = {};
    $self->{"srno"} = $srno;
    $self->{"created"} = $created;
    $self->{"ymd"} = $ymd;
    $self->{"status"} = $status;
    $self->{"title"} = $title;
    $self->{"content"} = $content;
    $self->{"category_srno"} = $category_srno;
    bless($self, $class);
    return $self;
}
sub srno{
    my ($self, $neo) = @_;
    $self->{"srno"} = $neo if(defined($neo));
    return $self->{"srno"};
}
sub created{
    my ($self, $neo) = @_;
    $self->{"created"} = $neo if(defined($neo));
    return $self->{"created"};
}
sub ymd{
    my ($self, $neo) = @_;
    $self->{"ymd"} = $neo if(defined($neo));
    return $self->{"ymd"};
}
sub status{
    my ($self, $neo) = @_;
    $self->{"status"} = $neo if(defined($neo));
    return $self->{"status"};
}
sub title{
    my ($self, $neo) = @_;
    $self->{"title"} = $neo if(defined($neo));
    return $self->{"title"};
}
sub content{
    my ($self, $neo) = @_;
    $self->{"content"} = $neo if(defined($neo));
    return $self->{"content"};
}
sub category_srno{
    my ($self, $neo) = @_;
    $self->{"category_srno"} = $neo if(defined($neo));
    return $self->{"category_srno"};
}

"Article.pm"

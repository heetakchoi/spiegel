package Spiegel::TPC;

use strict;
use warnings;
use constant SET_SEED => "__SET__";
use constant LIST_SEED => "__LIST__";

sub new{
    my ($class) = @_;
    my $self = {};
    $self->{SET_SEED} = {};
    $self->{LIST_SEED} = {};
    bless($self, $class);
    return $self;
}
sub set{
    my ($self, $alpha, $beta) = @_;
    $self->{SET_SEED}->{$alpha} = $beta;
    return $self;
}
sub get{
    my ($self, $alpha) = @_;
    return $self->{SET_SEED}->{$alpha};
}
sub set_keys{
    my ($self) = @_;
    return keys %{$self->{SET_SEED}};
}
sub list_add{
    my ($self, $alpha, $beta) = @_;
    $self->{LIST_SEED}->{$alpha} = [] unless(defined($self->{LIST_SEED}->{$alpha}));
    push( @{$self->{LIST_SEED}->{$alpha}},  $beta);
    return $self;
}
sub list_get{
    my ($self, $alpha) = @_;
    return @{$self->{LIST_SEED}->{$alpha}};
}
sub list_keys{
    my ($self) = @_;
    return keys %{$self->{LIST_SEED}};
}

return "Spiegel::TPC";
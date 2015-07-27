#!/usr/bin/perl

use strict;
use warnings;

my $tpc = TPC->new;

foreach my $one ( (2..9) ){
    $tpc->set( $one, $one*2 );
}
foreach my $key ( sort {$a<=>$b} $tpc->keys ){
    printf "key : %s, val : %s\n", $key, $tpc->get($key);
}

{
    package TPC;
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
    sub keys{
	my ($self) = @_;
	return keys %{$self->{SET_SEED}};
    }
    sub list_add{
	my ($self, $alpha, $beta) = @_;
	$self->{LIST_SEED}->$alpha = [] unless(defined($self->{LIST_SEED}->$alpha));
	$self->{LIST_SEED}->$alpha->[-1] = $beta;
	return $self;
    }
    sub list_get{
	my ($self, $alpha) = @_;
	return @{$self->{LIST_SEED}->$alpha};
    }
}

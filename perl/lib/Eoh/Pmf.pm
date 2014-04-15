package Eoh::Pmf;

use strict;
use warnings;

sub new{
    my $class = shift;
    my $self = {};
    internal_init_from_data($self, @_);

    bless($self, $class);
    return $self;
}
sub set_from_hash{
    my $self = shift;
    my $arg = shift;
    my %hash = %{$arg};
    my @elements = ();
    foreach my $key (keys %hash){
	my $count = $hash{$key};
	foreach ( 1..$count ){
	    push(@elements, $key);
	}
    }
    internal_init_from_data($self, @elements);
    return $self;
}
sub get_freq{
    my $self = shift;
    my $arg = shift;
    my $freq = ${$self->{"hist"}}{$arg};
    $freq = 0 unless($freq);
    return $freq;
}
sub get_prob{
    my $self = shift;
    my $arg = shift;
    my $freq = ${$self->{"hist"}}{$arg};
    $freq = 0 unless($freq);
    return $freq/scalar(@{$self->{"data"}});
}
sub reset_data{
    my $self = shift;
    @{$self->{"data"}} = ();
    %{$self->{"hist"}} = ();
    internal_init_from_data($self, @_);
}
sub get_values{
    my $self = shift;
    return @{$self->{"data"}};
}
sub get_hist{
    my $self = shift;
    return %{$self->{"hist"}};
}
sub get_mode{
    my $self = shift;
    my %hist_hash = %{$self->{"hist"}};
    my $max_value;
    my $key_for_max_value;
    foreach my $key ( keys %hist_hash ){
	unless(defined($max_value)){
	    $key_for_max_value = $key;
	    $max_value = $hist_hash{$key};
	}else{
	    if($hist_hash{$key} > $max_value){
		$key_for_max_value = $key;
		$max_value = $hist_hash{$key};
	    }
	}
    }
    return $key_for_max_value;
}
sub get_mean{
    my $self = shift;
    my %hist_hash = %{$self->{"hist"}};
    my $total = 0;
    foreach my $count (values %hist_hash){
	$total += $count;
    }
    my $mean = 0;
    foreach my $key (keys %hist_hash){
	$mean += (($key*$hist_hash{$key})/$total);
    }
    return $mean;
}

sub internal_init_from_data{
    my $self = shift;
    my @elements = @_;
    my %hist_hash = ();
    foreach my $key ( @elements ){
	if(defined($hist_hash{$key})){
	    $hist_hash{$key} += 1;
	}else{
	    $hist_hash{$key} = 1;
	}
    }

    $self->{"data"} = \@elements;
    $self->{"hist"} = \%hist_hash;
}

return "Eoh::Pmf";

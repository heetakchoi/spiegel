#!/usr/bin/perl

use strict;
use warnings;

my $terminal = 19;
my $penalty_distance = 20;
my $input = shift(@ARGV);
$terminal = $input if(defined($input));

my $index = 0;
my @history_list = (Step->new(-1, ""));

while(1){
	if($index >=$terminal){
		last;
	}
	$index ++;
	my @neo_history_list = ();
	while(my $one_history = shift(@history_list)){
		foreach ( (0..1) ){
			my $step = Step->new($index, $one_history->history.$_);
			push(@neo_history_list, $step);
		}
	}
	@history_list = @neo_history_list;
}

foreach my $one_step (@history_list){
	my $raw_history = $one_step->history;
	my @numbers = ();
	push(@numbers, 0);
	foreach my $char_index ( (0..(length($raw_history)-1)) ){
		if(substr($raw_history, $char_index, 1) > 0){
		    push(@numbers, $char_index+1);
		}
	}
	push(@numbers, $terminal+1);
	my @distance_list = ();
	for(my $index = 0; $index<scalar(@numbers)-1; $index ++){
	    push(@distance_list, $numbers[$index+1]-$numbers[$index]);
	}
	my $k = 0;
	my $distance_list_size = scalar(@distance_list);
	if($distance_list_size %2 == 0){
	    $k = $distance_list_size/2;
	}else{
	    $k = $distance_list_size/2 +1;
	}
	my $distance = 0;
	foreach (@distance_list){
	    $distance += $_*($_+1);
	}
	$distance += $penalty_distance*$k;
	print $distance;
	print " - ";
	print $raw_history,  " - ";
	print "@distance_list";
	print " - ";
	print "@numbers", "\n";
}
print scalar(@history_list), "\n";

{
	package Step;
	use strict;
	use warnings;
	sub new{
		my ($class, $index, $history) = @_;
		my $self = {};
		$self->{"index"} = $index;
		$self->{"history"} = $history;
		bless($self, $class);
		return $self;
	}
	sub index{
		my ($self, $neo) = @_;
		$self->{"index"} = $neo if(defined($neo));
		return $self->{"index"};
	}
	sub history{
		my ($self, $neo) = @_;
		$self->{"history"} = $neo if(defined($neo));
		return $self->{"history"};
	}
}

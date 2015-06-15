#!/usr/bin/perl

use strict;
use warnings;

my $terminal = 6;
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
	print $raw_history,  " - ";
	foreach my $char_index ( (0..(length($raw_history)-1)) ){
		if(substr($raw_history, $char_index, 1) > 0){
			print ($char_index+1);
			print " ";
		}
	}
	print "\n";
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

#!/usr/bin/perl

use strict;
use warnings;

my $json_txt = "";
open(my $fh, "<", "data.txt");
while(<$fh>){
    $json_txt .= $_;
}
close($fh);

my $total_length = length($json_txt);
my $index = 0;
while($index < $total_length){
    my $current = substr($json_txt, $index, 1);
    $index ++;
}

{
    package Node;

    sub new{
	my ($class, $name) = @_;
	my $self = {};
	$self->{"name"} = $name;
	$self->{"children"} = [];
	bless($self, $class);
	return $self;
    }
    sub adopt{
	my ($self, $child) = @_;
	add_child($self, $child);
	set_parent($child, $self);
	return;
    }
    sub info{
	my ($self, $indent) = @_;
	$indent = 0 unless(defined($indent));
	printf "%s%s\n", " "x$indent, $self->{"name"};
	$indent ++;
	foreach (get_children($self)){
	    info($_, $indent);
	}
    }
    sub get_children{
	my ($self) = @_;
	return @{$self->{"children"}};
    }
    sub set_parent{
	my ($self, $parent) = @_;
	$self->{"parent"} = $parent;
	return;
    }
    sub add_child{
	my ($self, $child) = @_;
	my @children = @{$self->{"children"}};
	push(@children, $child);
	$self->{"children"} = \@children;
	return;
    }

}

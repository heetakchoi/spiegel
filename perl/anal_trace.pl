#!/usr/bin/perl

use strict;
use warnings;

my $trace_file = shift;
unless(defined($trace_file)){
    die "Usage perl anal_trace.pl [traces.txt]\n";
}

my %threads = ();
my $tinfo;
open(my $file_r, "<", $trace_file);
my $line_number = 0;
while(my $line = <$file_r>){
    $line_number ++;
    if($line=~m/^"(\S+)" prio=\d+ tid=(\d+) (\S+)$/){
	if(defined($tinfo)){
	    $threads{$line_number} = $tinfo;
	}
	$tinfo = Eoh::Tinfo->new();
	$tinfo->set("line_number", $line_number);
	$tinfo->set("name", $1);
	$tinfo->set("tid", $2);
	$tinfo->set("type", $3);
    }elsif($line=~m/\| group="\S+" sCount=\d+ dsCount=\d+ obj=(\S+) self=(\S+)$/){
	$tinfo->set("obj", $1);
	$tinfo->set("self", $2);
    }elsif($line=~m/- waiting to lock <(\S+)> \(a (\S+)\) held by tid=(\d+) \((\S+)\)$/){
	$tinfo->set("wait_flag", 1);
	$tinfo->set("wait_lock", $1);
	$tinfo->set("wait_at", $2);
	$tinfo->set("wait_by_id", $3);
	$tinfo->set("wait_by_name", $4);
    }
}
$threads{$line_number} = $tinfo;
close($file_r);

# foreach my $key (sort {$a<=>$b} keys %threads){
#     print $threads{$key}->print("  "), "\n";
# }

my %tid_hash = ();
my %blocker_hash = ();
foreach my $key (keys %threads){
    my $tinfo = $threads{$key};
    my $tid = $tinfo->get("tid");
    $tid_hash{$tid} = $tinfo;
    my $wait_by_id = $tinfo->get("wait_by_id");
    if(defined($wait_by_id)){
	if(defined($blocker_hash{$wait_by_id})){
	    push(@{$blocker_hash{$wait_by_id}}, $tinfo);
	}else{
	    my @blocked_array = ();
	    push(@blocked_array, $tinfo);
	    $blocker_hash{$wait_by_id} = \@blocked_array;
	}
    }
}
foreach my $key (keys %blocker_hash){
    my @blocked_array = @{$blocker_hash{$key}};
    my $blocker_tinfo = $tid_hash{$key};
    printf "%s blocks %d thread.\n", $blocker_tinfo->get("name"), scalar(@blocked_array);
    my $index = 0;
    foreach my $one (@blocked_array){
	$index ++;
	printf "%4d %-30s at %s\n", $index, $one->get("name"), $one->get("wait_at");
    }
}

{
    package Eoh::Tinfo;

    use strict;
    use warnings;

    sub new{
	my $class = shift;
	my $self = {};
	bless($self, $class);
	return $self;
    }
    sub set{
	my $self = shift;
	my $name = shift;
	my $value = shift;
	$self->{$name} = $value;
    }
    sub get{
	my $self = shift;
	my $name = shift;
	return $self->{$name};
    }
    sub print{
	my $self = shift;
	my $indent = shift;
	my %hash = %{$self};
	foreach (sort keys %hash){
	    printf "%12s : %s\n", $_, $hash{$_};
	}
    }
}

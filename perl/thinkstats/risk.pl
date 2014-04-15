#!/usr/bin/perl

use strict;
use warnings;

use lib "../lib";
use ThinkStats::FemPreg;
use Eoh::Stat;
use Eoh::Pmf;

sub get_range_array;
sub get_prob_array;

my %fp_hash = ();
open(my $fh_r, "<", "2002FemPreg.dat");
my $line_number = 0;
while(my $line = <$fh_r>){
    chomp($line);
    $line_number ++;
    my $femPreg = FemPreg->new($line);
    $fp_hash{$line_number} = $femPreg;
}
close($fh_r);

my %first_hash = ();
my %other_hash = ();
foreach (keys %fp_hash){
    my $femPreg = $fp_hash{$_};
    if($femPreg->get_outcome() == 1){
	# 정상출산이고
	if($femPreg->get_birthord() == 1){
	    # 첫째인 경우
	    $first_hash{$_} = $femPreg;
	}else{
	    # 그외의 경우
	    $other_hash{$_} = $femPreg;
	}
    }
}

my @first_array = get_range_array(\%first_hash);
foreach (get_prob_array(@first_array)){
    print;
    print "\n";
}
my @other_array = get_range_array(\%other_hash);
foreach (get_prob_array(@other_array)){
    print;
    print "\n";
}

sub get_range_array{
    my %fp_hash = %{$_[0]};

    my $early_count = 0;
    my $ontime_count = 0;
    my $late_count = 0;

    foreach my $key (keys %fp_hash){
	my $femPreg = $fp_hash{$key};
	my $prglength = $femPreg->get_prglength();
	if($prglength <=38){
	    $early_count ++;
	}elsif($prglength >= 41){
	    $late_count ++;
	}else{
	    $ontime_count ++;
	}
    }
    return ($early_count, $ontime_count, $late_count);
}
sub get_prob_array{
    my $sum = 0;
    foreach (@_){
	$sum += $_;
    }
    my @results = ();
    foreach (@_){
	push(@results, $_/$sum);
    }
    return @results;
}

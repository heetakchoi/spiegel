#!/usr/bin/perl

use strict;
use warnings;

use lib "../lib";
use ThinkStats::FemPreg;
use Eoh::Stat;

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
    # 정상출산이고
    if($femPreg->get_outcome() == 1){

	if($femPreg->get_birthord() == 1){
	    # 첫째인 경우
	    $first_hash{$_} = $femPreg;
	}else{
	    # 그외의 경우
	    $other_hash{$_} = $femPreg;
	}
    }
}
my @first_prglengths = ();
foreach (keys %first_hash){
    my $prglength = $first_hash{$_}->get_prglength();
    push(@first_prglengths, $prglength);
}
my @other_prglengths = ();
foreach (keys %other_hash){
    my $prglength = $other_hash{$_}->get_prglength();
    push(@other_prglengths, $prglength);
}
my $first_stat = Eoh::Stat->new(@first_prglengths);
my $other_stat = Eoh::Stat->new(@other_prglengths);
printf "첫째 아이의 수: %d\n", scalar(keys %first_hash);
printf "그외 아이의 수: %d\n", scalar(keys %other_hash);
printf "평균 임신 주 수\n";
printf "- 첫째\n";
printf "-- 평균:   %f\n", my $one_mean = $first_stat->get_mean();
printf "-- 분산:   %f\n", my $one_v = $first_stat->get_variance();
printf "-- 표준편차 %f\n", my $one_sd = $first_stat->get_standard_deviation();
printf "- 나머지\n";
printf "- 평균:    %f\n", my $two_mean = $other_stat->get_mean();
printf "- 분산:    %f\n", my $two_v = $other_stat->get_variance();
printf "- 표준편차: %f\n", my $two_sd = $other_stat->get_standard_deviation();
printf "일자로 환산한 평균 차이: %f\n", 7*($one_mean - $two_mean);
printf "분산 차이:             %f\n", ($one_v - $two_v);
printf "표준편차 차이:         %f\n", ($one_sd - $two_sd);
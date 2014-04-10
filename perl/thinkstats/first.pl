#!/usr/bin/perl

use strict;
use warnings;

use lib "../lib";
use ThinkStats::FemPreg;
use Eoh::Math;

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
my $first_sum = 0;
foreach (keys %first_hash){
    my $prglength = $first_hash{$_}->get_prglength();
    push(@first_prglengths, $prglength);
    $first_sum += $prglength;
}
my @other_prglengths = ();
my $other_sum = 0;
foreach (keys %other_hash){
    my $prglength = $other_hash{$_}->get_prglength();
    push(@other_prglengths, $prglength);
    $other_sum += $prglength;
}
my $math = Eoh::Math->new();
print "첫째 아이의 수: ", scalar(keys %first_hash), "\n";
print "그외 아이의 수: ", scalar(keys %other_hash), "\n";
print "평균 임신 주 수\n";
print "첫째 평균 ", my $one_mean = $first_sum / scalar(@first_prglengths) , "\n";
print "첫째 분산 ", my $one_v = $math->get_variance(@first_prglengths) , "\n";
print "첫째 표준편차 ", my $one_sd = $math->get_standard_deviation(@first_prglengths) , "\n";
print "나머지 평균 ", my $two_mean = $other_sum / scalar(@other_prglengths) , "\n";
print "나머지 분산 ", my $two_v = $math->get_variance(@other_prglengths) , "\n";
print "나머지 표준편차 ", my $two_sd = $math->get_standard_deviation(@other_prglengths) , "\n";
print "일자로 환산한 평균 차이 ", 7*($one_mean - $two_mean), "\n";
print "분산 차이 ", ($one_v - $two_v), "\n";
print "표준편차 차이 ", ($one_sd - $two_sd), "\n";



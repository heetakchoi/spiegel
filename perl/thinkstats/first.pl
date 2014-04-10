#!/usr/bin/perl

use strict;
use warnings;

use lib "../lib";
use ThinkStats::FemPreg;

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
my $first_sum = 0;
foreach (keys %first_hash){
    $first_sum += $first_hash{$_}->get_prglength();
}
my $other_sum = 0;
foreach (keys %other_hash){
    $other_sum += $other_hash{$_}->get_prglength();
}

print "첫째 아이의 수: ", scalar(keys %first_hash), "\n";
print "그외 아이의 수: ", scalar(keys %other_hash), "\n";
print "평균 임신 주 수\n";
print "첫째 ", my $one = $first_sum / scalar(keys %first_hash) , "\n";
print "나머지 ", my $two = $other_sum / scalar(keys %other_hash) , "\n";
print "일자로 환산한 차이", 7*($one - $two), "\n";


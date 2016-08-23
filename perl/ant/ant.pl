#!/usr/bin/perl

use strict;
use warnings;

my %black_hash = ();

my ($x, $y, $ori_pre, $color_pre, $ori_post, $color_post) = (0, 0, "N", "W");
my $num = 0;
while($num < 100000){
    $num ++;
    if($color_pre eq "W"){
	$color_post = "B";
	if($ori_pre eq "N"){
	    $ori_post = "W";
	}elsif($ori_pre eq "E"){
	    $ori_post = "N";
	}elsif($ori_pre eq "S"){
	    $ori_post = "E";
	}elsif($ori_pre eq "W"){
	    $ori_post = "S";
	}else{
	    die "Invalid ori_pre\n";
	}
    }elsif($color_pre eq "B"){
	$color_post = "W";
	if($ori_pre eq "N"){
	    $ori_post = "E";
	}elsif($ori_pre eq "E"){
	    $ori_post = "S";
	}elsif($ori_pre eq "S"){
	    $ori_post = "W";
	}elsif($ori_pre eq "W"){
	    $ori_post = "N";
	}else{
	    die "Invalid ori_pre\n";
	}
    }else{
	die "Invalid color_pre\n";
    }
    my $position = sprintf "%d,%d", $x, $y;
    if($color_post eq "W"){
	delete $black_hash{$position};
    }elsif($color_post eq "B"){
	$black_hash{$position} = 1;
    }
    printf "num % 8d (% 4d,% 4d) Opre %s Cpre %s Opost %s Cpost %s\n", $num, $x, $y, $ori_pre, $color_pre, $ori_post, $color_post;

    if($ori_post eq "N"){
	$y += 1;
    }elsif($ori_post eq "E"){
	$x += 1;
    }elsif($ori_post eq "S"){
	$y -= 1;
    }elsif($ori_post eq "W"){
	$x -= 1;
    }else{
	die "Invalid ori_post\n";
    }
    $ori_pre = $ori_post;
    $position = sprintf "%d,%d", $x, $y;
    if(defined($black_hash{$position})){
	$color_pre = "B";
    }else{
	$color_pre = "W";
    }
}

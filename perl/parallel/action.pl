#!/usr/bin/perl

use strict;
use warnings;

sub parent;
sub worker;

$_ = 1;
my $worker_size = 3;

printf "START %s\n", $$;

foreach ( (1..$worker_size) ){
    my $pid = fork;
    unless($pid){
	worker;
	exit;
    }else{
	parent;
    }
}

foreach ( (1..$worker_size) ){
    wait;
}

printf "OK everything happy %s\n", $$;

sub parent{
    printf "parent %s\n", $$;
}
sub worker{
    printf "WORKING START %s\n", $$;
    sleep 3;
    printf "WORKING END %s end.\n", $$;
}

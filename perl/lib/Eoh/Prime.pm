package Eoh::Prime;

use strict;
use warnings;

use bignum;

sub new{
    my ($class, $location) = @_;
    my $self = {};

    $self->{"data"} = {};
    $self->{"max_value"} = -1;
    $self->{"location"} = $location;

    unless(-e $location){
		print "Error: cannot find resource.\nUsage: Eoh::Prime->new(primes.txt);\n";
		print "Do you start with simple seed file? (create primes.txt in current directory) y/n\n";
		while(1){
			my $answer = <STDIN>;
			chomp($answer);
			if($answer eq "Y" or $answer eq "y"){
				$location = "primes.txt";
				open(my $seedfile, ">", $location);
				print $seedfile "2\n3\n5\n7\n11\n";
				close($seedfile);
				last;
			}elsif($answer eq "N" or $answer eq "n"){
				return;
			}else{
				print "[". $answer ."] is unknown command. try y/n\n";
			}
		}
    }

    open(my $file, "<", $location);
    while(my $prime = <$file>){
		chomp($prime);
		${$self->{"data"}}{$prime} = 1;
		if($self->{"max_value"} < $prime){
			$self->{"max_value"} = $prime;
		}
    }
    close($file);

    bless($self, $class);
    return $self;
}

sub get_least_prime{
    my ($self, $number) = @_;
    construct_primes($self, $number);
    if($self->{"max_value"} <= $number){
		return $self->{"max_value"};
    }else{
		my @sorted = sort { $a<=>$b } keys $self->{"data"};
		my $left = 0;
		my $left_value;
		my $right = scalar(@sorted)-1;
		my $right_value;
		my $index = int(($left + $right)/2);
		my $index_value;

		while(1){
			$left_value = $sorted[$left];
			$right_value = $sorted[$right];
			$index_value = $sorted[$index];
			# printf "left[%d]:%d, right[%d]:%d, index[%d]:%d\n", $left, $left_value, $right, $right_value, $index, $index_value;
			if($index_value == $number){
				return $index_value;
			}elsif($index_value < $number){
				if($number < $sorted[$index+1]){
					return $index_value;
				}
				$left = $index;
			}else{
				if($sorted[$index-1] < $number){
					return $sorted[$index-1];
				}
				$right = $index;
			}
			$index = int(($left + $right)/2);
		}
		printf "[%d]\n", 9;
    }
}

sub factorization{
    my ($self, $number, $bphash_ref) = @_;
    if($number < 2){
		return $number;
    }
    my @sorted = sort { $a<=>$b } keys $self->{"data"};
    my $quotient = $number;

    while($quotient > 1){
		if(is_prime($self, $quotient)){
			$bphash_ref->{$quotient} = 1;
			last;
		}
		my $least_prime = get_least_prime($self, int(sqrt($quotient)));
		foreach my $prime ( @sorted ){
			if($prime > $least_prime){
				last;
			}
			while($quotient % $prime == 0){
				unless(defined($bphash_ref->{$prime})){
					$bphash_ref->{$prime} = 1;
				}else{
					$bphash_ref->{$prime} += 1;
				}
				$quotient /= $prime;
			}
			$least_prime = get_least_prime($self, int(sqrt($quotient)));
		}
    }
    return;
}

sub is_prime{
    my ($self, $number) = @_;

    if($number == 2){
		return 1;
    }
    if($number < 2 or $number % 2 == 0){
		return 0;
    }

    if(2<=$number and $number <= $self->{"max_value"}){
		my $found = ${$self->{"data"}}{$number};
		$found = 0 unless(defined($found));
		return $found;
	}else{
		my $sqrt_number = sqrt($number);
		if($sqrt_number <= $self->{"max_value"}){
			foreach my $prime ( sort {$a<=>$b} keys $self->{"data"} ){
				last if($prime > $sqrt_number);
				if($number % $prime == 0){
					return 0;
				}
			}
			return 1;
		}else{
			foreach my $prime ( keys $self->{"data"} ){
				if($number % $prime == 0){
					return 0;
				}
			}
			my $candidate = $self->{"max_value"};
			while($candidate < $sqrt_number){
				if($candidate == 2){
					$candidate += 1;
				}else{
					$candidate += 2;
				}
				if($number % $candidate == 0){
					return 0;
				}
			}
			return 1;
		}
	}
}

sub construct_primes{
    my ($self, $to_number) = @_;
    return if($self->{"max_value"} >= $to_number);
    
    my $candidate = $self->{"max_value"} + 2;
    $candidate = 3 if($self->{"max_value"} == 2);

    while($candidate <= $to_number){
		my ($flag, $msg) = is_prime($self, $candidate);
		if($flag){
			# printf "% 8d is prime. primes size is % 6d. max_value is % 8d. prime ratio: %.4f\n", $candidate, scalar(keys $self->{"data"}), $self->{"max_value"}, (scalar(keys $self->{"data"})*100/$candidate);
			${$self->{"data"}}{$candidate} = 1;
			$self->{"max_value"} = $candidate if($candidate > $self->{"max_value"});
		}
		$candidate += 2;
    }
    my $location = $self->{"location"};
    my $cmd = "mv ".$location." ".$location.".bak";
    open(my $file, ">", $location);
    my $max_value;
    foreach my $prime (sort {$a<=>$b} keys $self->{"data"}){
		print $file "$prime\n";
		$max_value = $prime;
    }
    close($file);
    $self->{"max_value"} = $max_value;

    return;
}

return "Eoh::Prime";

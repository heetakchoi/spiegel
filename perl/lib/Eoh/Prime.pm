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

    die "Error: cannot find resource.\nUsage: Eoh::Prime->new(primes.txt);\n" unless(-e $location);

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

sub get_known_max_prime{
    my $self = shift;
    return $self->{"max_value"};
}

sub factorization{
	my ($self, $number) = @_;
	my %hash = ();
	if($number < 2){
		die "$number can not be factorized.\n";
	}
	if($number == 2){
		$hash{"2"} = 1;
		return %hash;
	}
	
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
			printf "% 8d is prime. primes size is % 6d. max_value is % 8d. prime ratio: %.4f\n", $candidate, scalar(keys $self->{"data"}), $self->{"max_value"}, (scalar(keys $self->{"data"})*100/$candidate);
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

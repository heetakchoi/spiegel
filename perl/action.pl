#!/usr/bin/perl

use strict;
use warnings;

my $json_txt = "";
open(my $fh, "<", "data.txt");
while(<$fh>){
    $json_txt .= $_;
}
close($fh);

my %reserved = (
    "{"=>"Left Brace",
    "}"=>"Right Brace",
    "["=>"Left Bracket",
    "]"=>"Right Bracket",
    ":"=>"Colon",
    ","=>"Comma",
    );

my @tokens = ();
my @accumulated = ();
my $total_length = length($json_txt);
my $index = 0;

my $string_flag = 0;
my $before;
while($index < $total_length){
    my $current = substr($json_txt, $index, 1);
    # 따옴표를 만났는데
    if($current eq "\""){
	# 이미 문자열 상태였다고 하자.
	if($string_flag){
	    # 그런데 직전 문자가 역슬래시 였다면 계속 문자열 상태이다.
	    if($before eq "\\"){
		push(@accumulated, $current);
	    }else{
		# 그렇지 않다면 따옴표를 토큰으로 만들어 추가하고 누적값을 초기화한다.
		push(@accumulated, $current);
		push(@tokens, join("", @accumulated));
		@accumulated = ();
		# 문자열 상태를 해제한다.
		$string_flag = 0;
	    }
	}else{
	    # 문자열 상황이 아니었다면 문자열 상태로 전환한다.
	    push(@accumulated, $current);
	    $string_flag = 1;
	}
    }else{
	# 문자열 상태일 때 따옴표가 아닌 문자는 예약어 여부에 관계없이 문자열로 처리한다.
	if($string_flag){
	    push(@accumulated, $current);
	}else{
	    # 문자열 상태가 아닌 상황에서 예약어를 만났다.
	    if(defined($reserved{$current})){
		# 이전에 누적한 값이 있다면
		if(scalar(@accumulated)>0){
		    # 토큰 리스트에 기존에 쌓았던 값을 붙여 토큰을 만들어 추가한다.
		    push(@tokens, join ("", @accumulated));
		}
		# 예약어 자체도 토큰으로 만들어 추가하고 누적값을 초기화한다.
		push(@tokens, $current);
		@accumulated = ();
	    }else{
		# 예약어가 아니라면 누적된 값에 추가해 놓는다.
		push(@accumulated, $current);
	    }
	}
    }
    $index ++;
    $before = $current;
}

my @words = ();
foreach (@tokens){
    my $token = trim($_);
    if(length($token)>0){
	push(@words, $token);
    }
}

foreach my $word (@words){
    print $word, "\n";
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
sub trim{
    my ($data) = @_;
    $data =~ s/^\s+|\s+$//g;
    return $data;
}

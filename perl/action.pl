#!/usr/bin/perl

use strict;
use warnings;

sub trim;
sub load_text;
sub tokenizer;

sub proc;
sub proc_brace;
sub proc_bracket;
sub proc_normal;

my $txt = load_text;
my @token_list = tokenizer($txt);

my $parent_node = undef;
my $tokens_ref = \@token_list;
my $index = 0;
my $index_ref = \$index;
my $unit = ".";

my $init_node = proc($tokens_ref, $index_ref, $parent_node, 1);
print $init_node->info;

sub proc{
    my ($tokens_ref, $index_ref, $parent_node, $indent) = @_;
    my $one_token = $tokens_ref->[$$index_ref];
    my $node;
    # 더 이상 읽어들일 것이 없으면 중지한다.
    return unless(defined($one_token));

    if($one_token eq "{"){
	$node = proc_brace($tokens_ref, $index_ref, $parent_node, $indent);
    }elsif($one_token eq "["){
	$node = proc_bracket($tokens_ref, $index_ref, $parent_node, $indent);
    }else{
	$node = proc_normal($tokens_ref, $index_ref, $parent_node, $indent);
    }
    return $node;
}
sub proc_brace{
    my ($tokens_ref, $index_ref, $parent_node, $indent) = @_;
    my $start_index = $$index_ref;
    # 이미 { 를 가리키고 있다.
    # 노드를 하나 만든다.
    my $node = Node->new;
    # 이건 object 타입이다.
    $node->type("object");
    # 이제 name:value 를 쌍으로 꺼내 node 에 세팅하기 시작한다.
    # 단 이 쌍 처리가 한 번 완료하면 그 다음이 , 인지 } 인지 확인하여
    # 계속 name/value 세팅을 계속할 지 아니면 종료할지를 판단한다.
    # 더 이상 읽어들일 것이 없으면 중지한다.
    while(1){
	$$index_ref ++;
	my $candidate = $tokens_ref->[$$index_ref];
	last unless(defined($candidate));

	if($candidate eq "}"){
	    # 이러면 끝 났다.
	    # 다음을 처리할 수 있도록 인덱스를 하나 옮겨준다.
	    $$index_ref ++;
	    last;
	}elsif($candidate eq ","){
	    # 동일 레벨의 다음 쌍이 나올 것이다.
	    # 반복한다.
	}else{
	    # 예약어가 아니므로 토큰 3개를 차례로 name, :, value 로 간주하여 처리한다.
	    # 단 value 는 다시 object 나 array 가 될수 있으므로 proc 을 다시 호출하여 node 로 만든다.
	    my $name = $candidate;
	    $$index_ref ++; # 콜론 자리
	    $$index_ref ++;
	    my $value_node = proc($tokens_ref, $index_ref, $node, $indent +1);
	    # 이번에 읽어들인 name/value 쌍을 세팅한다.
	    $node->object_set($name, $value_node);
	    # 다음 토큰을 while 루프 안에서 다시 판단하기 위해 인덱스를 하나 뒤로 물린다.
	    $$index_ref --;
	}
    }
    $node->parent($parent_node) if(defined($parent_node));
    my $end_index = $$index_ref -1;
    my $content = "";
    foreach ($start_index..$end_index){
	$content .= $tokens_ref->[$_];
    }
    printf "%s %s %s\n", "#### "x$indent, "object", $content;
    return $node;
}
sub proc_bracket{
    my ($tokens_ref, $index_ref, $parent_node, $indent) = @_;
    my $start_index = $$index_ref;
    # 이미 [ 를 가리키고 있다.
    # 노드를 하나 만든다.
    my $node = Node->new;
    # 이건 array 타입이다.
    $node->type("array");
    # 이제 value 를 하나씩 꺼내 node 에 추가하기 시작한다.
    # 단 한 번 붙인 다음 그 다음이 , 인지 ] 인지 확인하여
    # 붙임을 계속할 지 아니면 종료할지를 판단한다.
    # 더 이상 읽어들일 것이 없으면 중지한다.

    while(1){
	$$index_ref ++;
	my $candidate = $tokens_ref->[$$index_ref];
	last unless(defined($candidate));

	if($candidate eq "]"){
	    # 이러면 끝 났다.
 	    # 다음을 처리할 수 있도록 인덱스를 하나 옮겨준다.
	    $$index_ref ++;
	    last;
	}elsif($candidate eq ","){
	    # 다음이 나올 것이다.
	    # 반복한다.
	}else{
	    # 예약어가 아니므로 붙인다.
	    # 단 object 나 array 가 될수 있으므로 proc 을 다시 호출하여 node 로 만든다.
	    my $value_node = proc($tokens_ref, $index_ref, $node, $indent +1);
	    # value node를 추가한다
	    $node->array_add($value_node);
	    # 다음 토큰을 while 루프 안에서 다시 판단하기 위해 인덱스를 하나 뒤로 물린다.
	    $$index_ref --;
	}
    }
    $node->parent($parent_node) if(defined($parent_node));
    my $end_index = $$index_ref-1;
    my $content = "";
    foreach ($start_index..$end_index){
	$content .= $tokens_ref->[$_];
    }
    printf "%s %s %s\n", "#### "x$indent, "array", $content;
    return $node;
}
sub proc_normal{
    my ($tokens_ref, $index_ref, $parent_node, $indent) = @_;
    my $candidate = $tokens_ref->[$$index_ref];
    # 노드를 하나 만든다.
    my $node = Node->new;
    # 이건 normal 타입이다.
    $node->type("normal");
    # 토큰을 값으로 세팅한다

    $node->normal_set($candidate);

    $node->parent($parent_node) if(defined($parent_node));
    return $node;
}
{
    package Node;
    sub new{
	my ($class) = @_;
	my $self = {};
	$self->{"type"} = undef;
	$self->{"parent"} = undef;
	$self->{"object"} = {};
	$self->{"array"} = [];
	$self->{"normal"} = undef;
	$self->{"indent"} = 0;

	bless($self, $class);
	return $self;
    }
    sub type{
	my ($self, $neo) = @_;
	$self->{"type"} = $neo if(defined($neo));
	return $self->{"type"};
    }
    sub parent{
	my ($self, $neo) = @_;
	$self->{"parent"} = $neo if(defined($neo));
	return $self->{"parent"};
    }
    sub object_get{
	my ($self, $key) = @_;
	return $self->{"object"}->{$key};
    }
    sub object_set{
	my ($self, $key, $value) = @_;
	$self->{"object"}->{$key} = $value;
	return;
    }
    sub object_keys{
	my ($self) = @_;
	return keys %{$self->{"object"}};
    }
    sub array_gets{
	my ($self) = @_;
	return @{$self->{"array"}};
    }
    sub array_add{
	my ($self, $value) = @_;
	push(@{$self->{"array"}}, $value);
	return;
    }
    sub normal_get{
	my ($self) = @_;
	return $self->{"normal"};
    }
    sub normal_set{
	my ($self, $neo) = @_;
	$self->{"normal"} = $neo;
	return;
    }
    
    sub indent{
	my ($self, $neo) = @_;
	$self->{"indent"} = $neo if(defined($neo));
	return $self->{"indent"};
    }    
    sub info{
	my ($self) = @_;
	my $detail = "";
	return sprintf "%s%s\n", " "x$self->{"indent"}, $self->{"type"};
    }
}
sub tokenizer{
    my ($json_text) = @_;
    my @reserved = ("{", "}", "[", "]", ":", ",");
    my %reserved_map = map { $_=>1 } @reserved;
    my @tokens = ();
    my @accumulated = ();
    my $total_length = length($json_text);
    my $idx = 0;
    my $string_flag = 0;
    my $before;
    while($idx < $total_length){
    	my $current = substr($json_text, $idx, 1);
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
    		if(defined($reserved_map{$current})){
    		    # 이전에 누적한 값이 있다면
    		    if(scalar(@accumulated)>0){
    			# 토큰 리스트에 기존에 쌓았던 값을 붙여 토큰을 만들어 추가한다.
    			push(@tokens, join ("", @accumulated));
    		    }
    		    # 예약어 자체도 토큰으로 만들어 추가하고 누적값을 초기화한다.
    		    push(@tokens, $current);
    		    @accumulated = ();
		}elsif($current =~ m/\s/){
		    # 문자열 상태가 아니면 공백은 무시한다.
    		}else{
    		    # 예약어가 아니라면 누적된 값에 추가해 놓는다.
    		    push(@accumulated, $current);
    		}
    	    }
    	}
    	$idx ++;
    	$before = $current;
    }
    return @tokens;
}
sub load_text{
    my $text = "";
    open(my $fh, "<", "data.txt");
    while(<$fh>){
    	$text .= $_;
    }
    close($fh);
    return $text;
}
sub trim{
    my ($data) = @_;
    $data =~ s/^\s+|\s+$//g;
    return $data;
}

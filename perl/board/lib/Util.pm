package Util;

use strict;
use warnings;

sub new{
    my ($class) = @_;
    my $self = {};
    open(my $file, "<", "Util.info");
    while(my $line=<$file>){
	if($line=~m/^(\S+)\s+(\S+)/){
	    $self->{$1} = $2;
	}
    }
    bless($self, $class);
    return $self;
}
sub get{
    my ($self, $key) = @_;
    return $self->{$key};
}
sub html_output{
    my ($class, $data) = @_;
    $data =~ s#\n#<br />#ig;
    return $data;
}
sub is_valid{
    my ($self, $cgi) = @_;
    my $auth_token = $cgi->cookie("auth_token");
    if(defined($auth_token)){
	if($auth_token eq $self->{"auth-token"}){
	    return 1;
	}else{
	    return 0;
	}
    }else{
	return 0;
    }
}
sub invalidate{
    my ($self, $cgi) = @_;
    print $cgi->header(-charset=>$self->{"charset"});
    printf "<script> alert('invalid access'); location.href = \"%s\"; </script>", $self->{"loc-home"};
    return;
}
sub connect_info{
    my ($self) = @_;
    return ($self->{"db-host"}, $self->{"db-user"}, $self->{"db-password"});
}
sub access_info{
    my ($self) = @_;
    return ($self->{"access-id"}, $self->{"access-password"}, $self->{"auth-token"});
}

return "Util.pm";

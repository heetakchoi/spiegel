package Util;

use strict;
use warnings;

sub new{
    my ($class) = @_;
    my $self = {};
    bless($self, $class);
    return $self;
}
sub html_output{
    my ($class_or_self, $data) = @_;
    $data =~ s#\n#<br />#ig;
    return $data;
}
sub is_valid{
    my ($class_or_self, $cgi) = @_;
    my %hash = ();
    open(my $file, "<", "Util.info");
    while(my $line=<$file>){
	if($line=~m/^(\S+)\s+(\S+)/){
	    $hash{$1} = $2;
	}
    }
    close($file);
    my $auth_token = $cgi->cookie("auth_token");
    if($auth_token eq $hash{"auth-token"}){
	return 1;
    }else{
	return 0;
    }
}
sub invalidate{
    my ($class_or_self, $cgi) = @_;
    print $cgi->header(-charset=>"euc-kr");
    print "<script> alert('invalid access'); location.href = '/board'; </script>";
    return;
}
sub connect_info{
    my ($class_or_self) = @_;
    my %hash = ();
    open(my $file, "<", "/home100/endofhope/info/Util.info");
    while(my $line=<$file>){
	if($line=~m/^(\S+)\s+(\S+)/){
	    $hash{$1} = $2;
	}
    }
    close($file);
    return ($hash{"db-host"}, $hash{"db-user"}, $hash{"db-password"});
}
sub access_info{
    my ($class_or_self) = @_;
    my %hash = ();
    open(my $file, "<", "Util.info");
    while(my $line=<$file>){
	if($line=~m/^(\S+)\s+(\S+)/){
	    $hash{$1} = $2;
	}
    }
    close($file);
    return ($hash{"access-id"}, $hash{"access-password"}, $hash{"auth-token"});
}

return "Util.pm";


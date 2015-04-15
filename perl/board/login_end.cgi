#!/usr/bin/perl

use strict;
use warnings;

use CGI;
use lib "lib";
use Util;

my $cgi = CGI->new;
my $util = Util->new;

my $id = $cgi->param("id");
my $pw = $cgi->param("pw");

my $success_flag = 0;
my @access_info = $util->access_info;
if($id eq $access_info[0]){
    if($pw eq $access_info[1]){
	$success_flag = 1;
    }
}
my $cookie;
if($success_flag){
    $cookie = $cgi->cookie(-name=>"auth_token",
			   -value=>$access_info[2],
			   -expires=>'+1h');
}else{
    $cookie = $cgi->cookie(-name=>"auth_token",
			   -value=>"",
			   -expires=>'-1d');
}
print $cgi->header(
    -cookie=>$cookie,
    -charset=>$util->get("charset")
    );

print $cgi->start_html(
    -title=>"Login end",
    -style=>$util->get("loc-css"),
    -script=>{type =>"text/javascript", src=>$util->get("loc-js")},
    -meta=>{"viewport"=>"width=device-width, initial-scale=1.0"},
    );
require "before.pl";
if($success_flag){
    print "<h3>Success Login</h3>\n";
}else{
    print "<h3>Logouted</h3>\n";
}
require "after.pl";
print $cgi->end_html();


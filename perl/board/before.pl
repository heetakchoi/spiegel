#!/usr/bin/perl

use strict;
use warnings;

use CGI;
use lib "lib";
use Util;

sub check;

my $cgi = CGI->new();

print  "<div class=\"wrap\">\n";
print  "  <div class=\"head\">\n";
print  "    <span style=\"font-size:2.0em;font-weight:bold;\">Life Logging</span>\n";
print  "  </div>\n"; # div.head

print  "  <div class=\"menu\">\n";
printf "    <span style=\"margin:5px;\"><a %s href=\"index.cgi\">Home</a></span>\n", check("index");
printf "    <span style=\"margin:5px;\"><a %s href=\"list_article.cgi\">Articles</a></span>\n", check("article");
printf "    <span style=\"margin:5px;\"><a %s href=\"info.cgi\">Info</a></span>\n", check("info");
if(Util->is_valid($cgi)){
    printf "    <span style=\"margin:5px;\"><a %s href=\"adm_list_category.cgi\">Category</a></span>\n", check("category");
}
printf "    <span style=\"margin:5px;\"><a %s href=\"login.cgi\">Login</a></span>\n", check("login");
print  "  </div>\n"; # div#menu

print  "  <div class=\"content\">\n";

sub check{
    my ($location) = @_;
    my $result = "";
    my $uri = $ENV{"REQUEST_URI"};
    if($uri =~ m/$location/i){
	$result = "style=\"color:black;font-weight:bold;\"";
    }
    return $result;
}

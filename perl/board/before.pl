#!/usr/bin/perl

use strict;
use warnings;

use CGI;
use lib "lib";
use Util;

sub check;

my $cgi = CGI->new();

print "<script>\n";
print "(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){\n";
print "	 (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),\n";
print "	 m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)\n";
print "	 })(window,document,'script','//www.google-analytics.com/analytics.js','ga');\n";
print "\n";
print "ga('create', 'UA-61757724-1', 'auto');\n";
print "ga('send', 'pageview');\n";
print "</script>\n";

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

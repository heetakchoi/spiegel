#!/usr/bin/perl

use strict;
use warnings;

use CGI;

use lib "lib";
use Util;

sub check;

my $cgi = CGI->new();
my $util = Util->new;

my $page_no = $cgi->param("page_no");
$page_no = 0 unless(defined($page_no));

print "<script>\n";

print "(function() {\n";
print "    function async_load(){\n";
print "        var s = document.createElement('script');\n";
print "        s.type = 'text/javascript';\n";
print "        s.async = true;\n";
print "        s.src = '", $util->get("loc-js"), "';\n";
print "        var x = document.getElementsByTagName('script')[0];\n";
print "        x.parentNode.insertBefore(s, x);\n";
print "    }\n";
print "    window.attachEvent ? window.attachEvent('onload', async_load) : window.addEventListener('load', async_load, false);\n";
print "})();\n";
print "</script>\n";









print "<script type=\"text/javascript\"\n";
print "  src=\"https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML\">\n";
print "</script>\n";

print  "<div class=\"wrap\">\n";
print  "  <div class=\"head\">\n";
print  "    <span style=\"font-size:2.0em;font-weight:bold;\">Life Logging</span>\n";
print  "  </div>\n"; # div.head

print  "  <div class=\"menu\">\n";
printf "    <span style=\"margin:5px;\"><a %s href=\"index.cgi\">Home</a></span>\n", check("index");
printf "    <span style=\"margin:5px;\"><a %s href=\"list_article.cgi?page_no=%d\">Articles</a></span>\n", check("article"), $page_no;
printf "    <span style=\"margin:5px;\"><a %s href=\"info.cgi\">Info</a></span>\n", check("info");
if($util->is_valid($cgi)){
    printf "    <span style=\"margin:5px;\"><a %s href=\"adm_list_category.cgi\">Category</a></span>\n", check("category");
}
printf "    <span style=\"margin:5px;\"><a %s href=\"login.cgi\">Login</a></span>\n", check("login");
print  "  </div>\n"; # div#menu

print  "  <div class=\"content\">\n";

sub check{
    my ($location) = @_;
    my $result = "";
    my $uri = $cgi->url;
    if($uri =~ m/$location/i){
	$result = "style=\"color:black;font-weight:bold;\"";
    }
    return $result;
}

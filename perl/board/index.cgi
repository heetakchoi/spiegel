#!/usr/bin/perl

use strict;
use warnings;

use CGI;
use lib "lib";
use Util;

my $cgi = CGI->new;
my $util = Util->new;

print $cgi->header(
    -charset=>$util->get("charset")
    );
print $cgi->start_html(
    -title=>"Old-fashioned life logging",
    -style=>$util->get("loc-css"),
    -script=>{type =>"text/javascript", src=>$util->get("loc-js")},
    -meta=>{"viewport"=>"width=device-width, initial-scale=1.0"},
    );
require "before.pl";

print  "<div class=\"main\">\n";
print  "  <div class=\"paragraph\">\n";
print  "Check your environment. and fill Util.info.<br />\n";
print  "  </div>\n"; # div.paragraph

print  "  <div class=\"paragraph\">\n";
print  "  </div>\n"; # div.paragraph

print  "</div>\n"; # div.main

require "after.pl";
print $cgi->end_html();


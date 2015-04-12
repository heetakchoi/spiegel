#!/usr/bin/perl

use strict;
use warnings;

use CGI;

my $cgi = CGI->new;

print $cgi->header(
    -charset=>"euc-kr"
    );
print $cgi->start_html(
    -title=>"Infomation",
    -style=>"style.css",
    -script=>{type =>"text/javascript", src=>"script.js"},
    -meta=>{"viewport"=>"width=device-width, initial-scale=1.0"},
    );
require "before.pl";

print  "<div class=\"main\">\n";
print  "<span style=\"font-size:1.2em;\">Went, going. But gone not yet.</span>";

print "</div>\n"; # div.main

require "after.pl";
print $cgi->end_html();


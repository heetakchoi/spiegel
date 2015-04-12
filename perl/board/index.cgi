#!/usr/bin/perl

use strict;
use warnings;

use CGI;

my $cgi = CGI->new;

print $cgi->header(
    -charset=>"euc-kr"
    );
print $cgi->start_html(
    -title=>"Old-fashioned life logging",
    -style=>"style.css",
    -script=>{type =>"text/javascript", src=>"script.js"},
    -meta=>{"viewport"=>"width=device-width, initial-scale=1.0"},
    );
require "before.pl";

print  "<div class=\"main\">\n";
print  "  <div class=\"paragraph\">\n";
print  "말해질 수 있는 것은 분명하게 말해질 수 있다;<br />\n";
print  "말할 수 없는 것에 대해서는 침묵해야 한다.<br />\n";
print  "- 논리 철학 논고, 루드비히 비트겐슈타인</a>";

print  "  </div>\n"; # div.paragraph

print  "  <div class=\"paragraph\">\n";
print  "  </div>\n"; # div.paragraph

print  "</div>\n"; # div.main

require "after.pl";
print $cgi->end_html();


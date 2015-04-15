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
    -title=>"Infomation",
    -style=>$util->get("loc-css"),
    -script=>{type =>"text/javascript", src=>$util->get("loc-js")},
    -meta=>{"viewport"=>"width=device-width, initial-scale=1.0"},
    );
require "before.pl";

print  "<div class=\"main\">\n";
print  "<span style=\"font-size:0.8em;\">\n";
print  "What can be said at all can be said clearly;<br />\n";
print  "and whereof one cannot speak thereof one must be silent.<br />\n";
print  "Tractatus Logico-Philosophicus, Ludwig Wittgenstein<br />\n";
print  "</span>";

print "</div>\n"; # div.main

require "after.pl";
print $cgi->end_html();


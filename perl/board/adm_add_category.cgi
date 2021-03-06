#!/usr/bin/perl

use strict;
use warnings;

use CGI;
use lib "lib";
use Util;

my $cgi = CGI->new;
my $util = Util->new;
unless($util->is_valid($cgi)){
    $util->invalidate($cgi);
    return;
}

print $cgi->header(
    -charset=>$util->get("charset")
    );
print $cgi->start_html(
    -title=>"add category",
    -style=>$util->get("loc-css"),
    -script=>{type =>"text/javascript", src=>$util->get("loc-js")},
    -meta=>{"viewport"=>"width=device-width, initial-scale=1.0"},
    );
require "before.pl";

print "<form name=\"formname\" method=\"get\" action=\"adm_add_category_end.cgi\" >\n";
print "category_name: <input type=\"text\" name=\"category_name\" value=\"\" />\n";
print "<input type=\"submit\" name=\"submit\" value=\"submit\" />\n";
print "</form>\n";

require "after.pl";
print $cgi->end_html();

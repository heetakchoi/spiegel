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
    -title=>"upload",
    -style=>$util->get("loc-css"),
    -script=>{type =>"text/javascript", src=>$util->get("loc-js")},
    -meta=>{"viewport"=>"width=device-width, initial-scale=1.0"},
    );
require "before.pl";

print "<div class=\"main\">\n";
print "<form name=\"formname\" enctype=\"multipart/form-data\" method=\"post\" action=\"upload_end.cgi\">\n";
print "  <input type=\"hidden\" name=\"back_url\" value=\"upload.cgi\" />\n";
print "  <input type=\"file\" name=\"upload\" />\n";
print "  <input type=\"submit\" name=\"submit\" value=\"upload\" />\n";
print "</form>\n";
print "</div>\n";

require "after.pl";
print $cgi->end_html();

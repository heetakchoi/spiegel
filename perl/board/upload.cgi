#!/usr/bin/perl

use strict;
use warnings;

use CGI;
use lib "lib";
use Util;

my $cgi = CGI->new;
unless(Util->is_valid($cgi)){
    Util->invalidate($cgi);
    return;
}

print $cgi->header(
    -charset=>"euc-kr"
    );
print $cgi->start_html(
    -title=>"tmpl",
    -style=>"style.css",
    -script=>{type =>"text/javascript", src=>"script.js"},
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

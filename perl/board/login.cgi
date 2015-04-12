#!/usr/bin/perl

use strict;
use warnings;

use CGI;
use lib "lib";

my $cgi = CGI->new;
print $cgi->header(
    -charset=>"euc-kr"
    );
print $cgi->start_html(
    -title=>"Login",
    -style=>"style.css",
    -script=>{type =>"text/javascript", src=>"script.js"},
    -meta=>{"viewport"=>"width=device-width, initial-scale=1.0"},
    );
require "before.pl";

print  "<div id=\"outer\">\n";
print  "  <div id=\"inner\">\n";

print  "<div class=\"main\">\n";
print  "  <form name=\"formname\" method=\"post\" action=\"login_end.cgi\" />\n";
print  "    <table>\n";
print  "      <tr>\n";
print  "        <td>id:</td>\n";
print  "        <td><input size=\"10\" type=\"text\" name=\"id\" value=\"\" /></td>\n";
print  "        <td rowspan=\"2\"><input type=\"submit\" style=\"height:46px;\" name=\"submit\" value=\"submit\" /></td>\n";
print  "      </tr>\n";
print  "      <tr>\n";
print  "        <td>pw:</td>\n";
print  "        <td><input size=\"10\" type=\"password\" name=\"pw\" value=\"\" /></td>\n";
print  "      </tr>\n";
print  "    </table>\n";
print  "  </form>\n";
print  "</div>\n"; # div.main

print  "  </div>\n"; # inner
print  "</div>\n"; # outer

require "after.pl";
print $cgi->end_html();


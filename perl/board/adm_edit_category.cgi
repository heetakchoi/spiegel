#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use CGI;
use lib "lib";
use Category;
use Util;

my $cgi = CGI->new;
unless(Util->is_valid($cgi)){
    Util->invalidate($cgi);
    return;
}

my $srno = $cgi->param("srno");
################################################################################
my $dbh = DBI->connect(Util->connect_info);
my $sql = "SELECT * FROM category WHERE srno = ?";
my $sth = $dbh->prepare($sql);
$sth->execute($srno);
my $one_category;
if(my @rows = $sth->fetchrow_array()){
    $one_category = Category->new(@rows);
}
$sth->finish();
$dbh->disconnect();
################################################################################

print $cgi->header(
    -charset=>"euc-kr"
    );
print $cgi->start_html(
    -title=>"edit category",
    -style=>"style.css",
    -script=>{type =>"text/javascript", src=>"script.js"},
    -meta=>{"viewport"=>"width=device-width, initial-scale=1.0"},
    );
require "before.pl";

print "<form name=\"formname\" method=\"get\" action=\"adm_edit_category_end.cgi\">\n";
printf "<input type=\"hidden\" name=\"srno\" value=\"%s\" />\n", $one_category->srno;
printf "<input type=\"text\" name=\"category_name\" value=\"%s\" />\n", $one_category->category_name;
print "<input type=\"submit\" name=\"submit\" value=\"submit\" />\n";
print "</form>\n";

print "<div id=\"doc_bottom_right\">\n";
printf "<a href=\"adm_delete_category.cgi?srno=%d\">delete</a>\n", $srno;
print "</div>\n";

print  "<div id=\"doc_bottom\">\n";
print  "  <a href=\"adm_list_category.cgi\">list category</a>\n";
print  "</div>\n";

require "after.pl";
print $cgi->end_html();

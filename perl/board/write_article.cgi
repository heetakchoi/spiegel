#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use CGI;

use lib "lib";
use Category;
use Util;

################################################################################
my @categories = ();
my $dbh = DBI->connect(Util->connect_info);
my $sql = "SELECT * FROM category ORDER BY srno DESC";
my $sth = $dbh->prepare($sql);
$sth->execute();
while(my @rows = $sth->fetchrow_array()){
    my $one_category = Category->new(@rows);
    push(@categories, $one_category);
}
$sth->finish();
$dbh->disconnect();
################################################################################
my $cgi = CGI->new;
unless(Util->is_valid($cgi)){
    Util->invalidate($cgi);
    return;
}

print $cgi->header(
    -charset=>"euc-kr"
    );
print $cgi->start_html(
    -title=>"Write Article",
    -style=>"style.css",
    -script=>{type =>"text/javascript", src=>"script.js"},
    -meta=>{"viewport"=>"width=device-width, initial-scale=1.0"},
    );
require "before.pl";

print "<form name=\"formname\" method=\"post\" action=\"write_article_end.cgi\">\n";
print "  ymd: <input size=\"8\" type=\"text\" name=\"ymd\" value=\"\" />\n";
print "  status: ";
print "  <select name=\"status\">";
print "    <option value=\"0\">0</option>";
print "    <option value=\"1\">1</option>";
print "  </select><br />\n";
print "  title: <input type=\"text\" name=\"title\" value=\"\" size=\"35\" /><br />\n";
print "  content:<br /><textarea name=\"content\" rows=\"10\" cols=\"40\"></textarea><br />\n";
print "  <select name=\"category_srno\">\n";
foreach (@categories){
    printf "    <option value=\"%d\">%s</option>\n", $_->srno, $_->category_name;
}
print "  </select>\n";
print "  <input type=\"submit\" name=\"submit\" value=\"submit\" />\n";
print "</form>\n";

require "after.pl";
print $cgi->end_html();

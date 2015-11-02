#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use CGI;

use lib "lib";
use Category;
use Util;

my $cgi = CGI->new;
my $util = Util->new;
unless($util->is_valid($cgi)){
    $util->invalidate($cgi);
    return;
}
my $today = $util->get_ymd(0);
################################################################################
my @categories = ();
my $dbh = DBI->connect($util->connect_info);
my $sql = "SELECT * FROM category ORDER BY srno ASC";
my $sth = $dbh->prepare($sql);
$sth->execute();
while(my @rows = $sth->fetchrow_array()){
    my $one_category = Category->new(@rows);
    push(@categories, $one_category);
}
$sth->finish();
$dbh->disconnect();
################################################################################

print $cgi->header(
    -charset=>$util->get("charset")
    );
print $cgi->start_html(
    -title=>"Write Article",
    -style=>$util->get("loc-css"),
	-script=>{type =>"text/javascript", src=>$util->get("loc-js")},
    -meta=>{"viewport"=>"width=device-width, initial-scale=1.0"},
    );
require "before.pl";

print "<form name=\"formname\" method=\"post\" action=\"write_article_end.cgi\">\n";
printf "  ymd: <input size=\"8\" type=\"text\" name=\"ymd\" value=\"%s\" />\n", $today;
print "  status: ";
print "  <select name=\"status\">";
print "    <option value=\"0\">0</option>";
print "    <option value=\"1\">1</option>";
print "  </select><br />\n";
print "  title: <input type=\"text\" name=\"title\" value=\"\" size=\"30\" /><br />\n";
print "  content:<br /><textarea name=\"content\" rows=\"10\" cols=\"35\"></textarea><br />\n";
print "  <select name=\"category_srno\">\n";

foreach (@categories){
    my $selected = "";
    $selected = "selected" if($_->srno == 12);
    printf "    <option %s value=\"%d\">%s</option>\n", $selected, $_->srno, $_->category_name;
}
print "  </select>\n";
print "  <input type=\"submit\" name=\"submit\" value=\"submit\" />\n";
print "</form>\n";
my $info = "<blockquote></blockquote>\n"
    . "\\( \\frac{25}{90} \\)\n"
    . "<span style=\"text-decoration:line-through;\"></span>";
printf "<textarea rows=\"4\" cols=\"35\">%s</textarea>\n", $info;
print "<p><a target=\"_blank\" href=\"upload.cgi\">upload</a></p>\n";

require "after.pl";
print $cgi->end_html();

#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use CGI;
use lib "lib";
use PNet;
use Category;
use Util;

my $cgi = CGI->new;
my $util = Util->new;
unless($util->is_valid($cgi)){
    $util->invalidate($cgi);
    return;
}
################################################################################
my @categories = ();
my $dbh = DBI->connect($util->connect_info);
my $sql = "SELECT * FROM category";
my $sth = $dbh->prepare($sql);
$sth->execute();
while(my @row = $sth->fetchrow_array()){
    my $one_category = Category->new(@row);
    push(@categories, $one_category);
}
$sth->finish();
$dbh->disconnect();
################################################################################

print $cgi->header(
    -charset=>$util->get("charset")
    );
print $cgi->start_html(
    -title=>"list category",
    -style=>$util->get("loc-css"),
    -script=>{type =>"text/javascript", src=>$util->get("loc-js")},
    -meta=>{"viewport"=>"width=device-width, initial-scale=1.0"},
    );
require "before.pl";

print "<ul style=\"list-style-type:none;\">\n";
foreach (@categories){
    print "<li>";
    printf "%s", $_->category_name;
    printf " - <a href=\"adm_edit_category.cgi?srno=%d\">edit</a>", $_->srno;
    print "</li>\n";
}
print "</ul>\n";
print "<div class=\"right\">\n";
print "  <a href=\"adm_add_category.cgi\">add category</a>\n";
print "</div>\n"; # div.right
print "<div class=\"clear\"></div>\n"; # div.clear

require "after.pl";
print $cgi->end_html();


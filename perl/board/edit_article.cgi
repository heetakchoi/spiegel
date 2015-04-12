#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use CGI;

use lib "lib";
use Article;
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

my @categories = ();
my $sql = "SELECT * FROM category";
my $sth = $dbh->prepare($sql);
$sth->execute();
while(my @rows = $sth->fetchrow_array()){
    my $one_category = Category->new(@rows);
    push(@categories, $one_category);
}
$sth->finish();

$sql = "SELECT * FROM article WHERE srno = ?";
$sth = $dbh->prepare($sql);
$sth->execute($srno);
my @row = $sth->fetchrow_array();
my $one_article = Article->new(@row);
$sth->finish();

$dbh->disconnect();
################################################################################

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

print  "<div id=\"main\">\n";
print  "  <div style=\"margin-top:10px;margin-bottom:25px;\">\n";
print  "<form name=\"formname\" method=\"post\" action=\"edit_article_end.cgi\">\n";
printf "<input type=\"hidden\" name=\"srno\" value=\"%d\" />\n", $srno;
printf "ymd: <input size=\"8\" type=\"text\" name=\"ymd\" value=\"%s\" />\n", $one_article->ymd;
print "  status: ";
print "  <select name=\"status\">";
foreach ( (0..1) ){
    my $selection = "";
    if($_ == $one_article->status){
	$selection = "selected";
    }
    printf "    <option %s value=\"%d\">%d</option>", $selection, $_, $_;
}
print "  </select><br />\n";
printf "  title: <input type=\"text\" name=\"title\" value=\"%s\" size=\"30\" /><br />\n", $one_article->title;
printf "  content: <textarea name=\"content\" rows=\"20\" cols=\"40\">%s</textarea><br />\n", $one_article->content;
print "  <select name=\"category_srno\">\n";
foreach (@categories){
    my $selection = "";
    if($_->srno == $one_article->category_srno){
	$selection = "selected";
    }
    printf "<option %s value=\"%d\">%s</option>\n", $selection, $_->srno, $_->category_name;
}
print "  </select>\n";
print "  <input type=\"submit\" name=\"submit\" value=\"submit\" />\n";
print "</form>\n";
print "  </div>\n"; # div

print  "  <div class=\"left\">\n";
printf "    <a href=\"delete_article.cgi?srno=%d\">delete article</a>\n", $srno;
print  "  </div>\n"; # div.left
print  "  <div class=\"right\">\n";
print  "  <a href=\"list_article.cgi\">list article</a>\n";
print  "  </div>\n"; # div.right
print  "  <div class=\"clear\"></div>\n"; # div.clear
print  "</div>\n"; # div.main

require "after.pl";
print $cgi->end_html();
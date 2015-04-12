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
my $valid_flag = 0;
$valid_flag = 1 if(Util->is_valid($cgi));
my $srno = $cgi->param("srno");
my $page_no = $cgi->param("page_no");
################################################################################
my $dbh = DBI->connect(Util->connect_info);

my %category_hash = ();
my $sql = "SELECT * FROM category";
my $sth = $dbh->prepare($sql);
$sth->execute();
while(my @rows = $sth->fetchrow_array()){
    my $one_category = Category->new(@rows);
    $category_hash{$one_category->srno} = $one_category;
}
$sth->finish();

$sql = "SELECT srno FROM article WHERE srno > ? ORDER BY ymd ASC LIMIT 1";
$sth = $dbh->prepare($sql);
$sth->execute($srno);
my ($upper_srno) = $sth->fetchrow_array();
$sth->finish();

$sql = "SELECT srno FROM article WHERE srno < ? ORDER BY ymd DESC LIMIT 1";
$sth = $dbh->prepare($sql);
$sth->execute($srno);
my ($lower_srno) = $sth->fetchrow_array();
$sth->finish();

$sql = "SELECT * FROM article WHERE srno = ?";
$sth = $dbh->prepare($sql);
$sth->execute($srno);
my @row = $sth->fetchrow_array();
my $article = Article->new(@row);
$sth->finish();

$dbh->disconnect();

my $category_name = $category_hash{$article->category_srno}->category_name;
################################################################################

print $cgi->header(
    -charset=>"euc-kr"
    );
print $cgi->start_html(
    -title=>"View Article",
    -style=>"style.css",
    -script=>{type =>"text/javascript", src=>"script.js"},
    -meta=>{"viewport"=>"width=device-width, initial-scale=1.0"},
    );
require "before.pl";

print  "<div class=\"main\">\n";
print  "  <div class=\"right\">\n";
printf "    <a href=\"list_article.cgi?page_no=%d\">list article</a>\n", $page_no;
print  "  </div>\n"; # div.right
print  "  <div class=\"clear\"></div>\n"; # div.clear

printf "  <div style=\"margin-top:10px;\">%s</div>\n", $article->title;
printf "  <div style=\"font-size:0.5em; vertical-align:bottom;\">(%s %s %s) - %s</div>", substr($article->ymd, 0, 4), substr($article->ymd, 4, 2), substr($article->ymd, 6, 2), $category_name;
printf "  <div style=\"margin-left: 25px;margin-top: 20px;margin-bottom: 25px;\">%s</div>\n", Util->html_output($article->content);

print  "  <div class=\"right\">\n";
if(defined($upper_srno)){
    printf "<a href=\"view_article.cgi?srno=%d&page_no=%d\">����</a>\n", $upper_srno, $page_no;
}else{
    print "�ֽű��Դϴ�.\n";
}
print " &nbsp; &nbsp; &nbsp; &nbsp; ";
if(defined($lower_srno)){
    printf "<a href=\"view_article.cgi?srno=%d&page_no=%d\">�Ʒ���</a>\n", $lower_srno, $page_no;
}else{
    print "ù���Դϴ�.\n";
}
print  "  </div>\n"; # div.right
print  "  <div class=\"left\">\n";
printf "    <a href=\"edit_article.cgi?srno=%d\">edit article</a>\n", $article->srno if($valid_flag);
print  "  </div>\n"; # div.left
print  "  <div class=\"clear\"></div>\n"; # div.clear

print  "</div>\n"; # div.main

require "after.pl";
print $cgi->end_html();

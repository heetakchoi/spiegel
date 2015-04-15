#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use CGI;
use POSIX;

use lib "lib";
use Article;
use Category;
use Util;

my $cgi = CGI->new;
my $util = Util->new;
my $valid_flag = 0;
$valid_flag = 1 if($util->is_valid($cgi));

my $page_no = $cgi->param("page_no");
$page_no = 1 unless(defined($page_no) and $page_no);
################################################################################
my %category_hash = ();
my $dbh = DBI->connect($util->connect_info);
my $sql = "SELECT * FROM category";
my $sth = $dbh->prepare($sql);
$sth->execute();
while(my @rows = $sth->fetchrow_array()){
    my $one_category = Category->new(@rows);
    $category_hash{$one_category->srno} = $one_category;
}
$sth->finish();

$sql = "SELECT count(*) FROM article";
$sth = $dbh->prepare($sql);
$sth->execute();
my ($total_count) = $sth->fetchrow_array();
$sth->finish();

my $page_unit = 5;
my $max_page_no = floor(($total_count-1) / $page_unit + 1);
my $bypass_count = $page_unit * ($page_no-1);
my $limit_count = $bypass_count + $page_unit;

my $left_no = $page_no - 4;
$left_no = 1 if($left_no < 1);
my $right_no = $page_no + 4;
my $more_right_flag = 0;
if($right_no >= $max_page_no){
    $right_no = $max_page_no ;
}else{
    $more_right_flag = 1;
}

my @articles = ();
$sql = "SELECT * FROM article ORDER BY ymd DESC, created DESC LIMIT ?";
$sth = $dbh->prepare($sql);
$sth->execute($limit_count);
my $bypass_index = 0;
while(my @rows = $sth->fetchrow_array()){
    $bypass_index ++;
    next if($bypass_index <= $bypass_count);
    
    my $one_article = Article->new(@rows);
    push(@articles, $one_article);
}
$sth->finish();
$dbh->disconnect();
################################################################################

print $cgi->header(
    -charset=>$util->get("charset")
    );
print $cgi->start_html(
    -title=>"Article List",
    -style=>$util->get("loc-css"),
    -script=>{type =>"text/javascript", src=>$util->get("loc-js")},
    -meta=>{"viewport"=>"width=device-width, initial-scale=1.0"},
    );
require "before.pl";

print "<div class=\"main\">\n";
print "  <div class=\"right\">\n";
print "    <a href=\"write_article.cgi\">write article</a>\n" if($valid_flag);
print "  </div>\n"; # div.right
print "  <div class=\"clear\"></div>\n"; # div.clear

foreach (@articles){
    my $category_name = $category_hash{$_->category_srno}->category_name;

    print  "<div style=\"margin-bottom:10px;margin-top:10px;\">\n";
    printf "  <span style=\"margin-left:5px;\"><a style=\"color:darkslategray;\" href=\"view_article.cgi?srno=%d&page_no=%d\">%s</a></span>", $_->srno, $page_no, $_->title;
    print  "  <br />\n";
    print  "  <span style=\"font-size:0.5em;color:gray;vertical-align:bottom;margin-left:15px;\">\n";
    printf "   %s.%s.%s - %s", substr($_->ymd, 0, 4), substr($_->ymd, 4, 2), substr($_->ymd, 6, 2), $category_name;
    print  "  </span>\n";
    print  "</div>\n";
}

print "<div style=\"text-align:center\">\n";
foreach ( ($left_no..$right_no) ){
    my $decoration = "";
    if($_ == $page_no){
	$decoration = "style=\"color:black;\"";
    }
    printf " &nbsp;<a %s href=\"list_article.cgi?page_no=%d\">%d</a> &nbsp;", $decoration, $_, $_;
}
if($more_right_flag){
    printf " &nbsp;<a href=\"list_article.cgi?page_no=%d\">></a> &nbsp;", $right_no+1;
}

print "</div>\n";

print "</div>\n"; # div.main

require "after.pl";
print $cgi->end_html();


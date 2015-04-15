#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use CGI;
use lib "lib";
use PNet;
use Article;
use Util;

my $util = Util->new;
# unless($util->is_valid($cgi)){
#     $util->invalidate($cgi);
#     return;
# }
################################################################################
my @articles = ();
my $dbh = DBI->connect($util->connect_info);
my $sql = "SELECT * FROM article";
my $sth = $dbh->prepare($sql);
$sth->execute();
while(my @rows = $sth->fetchrow_array()){
    my $one_article = Article->new(@rows);
    push(@articles, $one_article);
}
$sth->finish();
$dbh->disconnect();
################################################################################
my $net = PNet->new();
my %header_hash = ();
my %param_hash = ("A"=>"1", "한국"=>"사람");
my $response = $net->send_post("endofhope.com", 80, "/info.cgi", \%param_hash, \%header_hash, 1);
my $start = index($response, "<h3>From parameters</h3>");
my $end = index($response, "<hr />");
my $result = substr($response, $start + 24, ($end-$start-24));

$response = $net->send_get("endofhope.com", 80, "/info.cgi?B=2&대한=민국", \%header_hash, 1);
$start = index($response, "<h3>From parameters</h3>");
$end = index($response, "<hr />");
my $result1 = substr($response, $start + 24, ($end-$start-24));
################################################################################
my $cgi = CGI->new;

print $cgi->header(
    -charset=>$util->get("charset")
    );
print $cgi->start_html(
    -title=>"tmpl",
    -style=>$util->get("loc-css"),
    -script=>{type =>"text/javascript", src=>$util->get("loc-js")},
    -meta=>{"viewport"=>"width=device-width, initial-scale=1.0"},
    );
require "before.pl";

foreach (@articles){
    print $_->srno, " ", $_->reg_date, " ",
    $_->status, " ", $_->title, " ", $_->content, "<br />\n";
}

require "after.pl";
print $cgi->end_html();


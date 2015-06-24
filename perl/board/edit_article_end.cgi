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
my $util = Util->new;
unless($util->is_valid($cgi)){
    $util->invalidate($cgi);
    return;
}

my $srno = $cgi->param("srno");
my $ymd = $cgi->param("ymd");
my $status = $cgi->param("status");
my $title = $cgi->param("title");
my $content = $cgi->param("content");
my $category_srno = $cgi->param("category_srno");
my $page_no = $cgi->param("page_no");
################################################################################
my $dbh = DBI->connect($util->connect_info);

my $sql = "UPDATE article SET created = now(), ymd = ?, status = ?, title = ?, content = ?, category_srno = ? WHERE srno = ?";
my $sth = $dbh->prepare($sql);
$sth->execute($ymd, $status, $title, $content, $category_srno, $srno);
$sth->finish();

$dbh->disconnect();
################################################################################

print $cgi->header(
    -charset=>$util->get("charset")
    );
printf "<script> location.href = 'view_article.cgi?srno=%d&page_no=%d'; </script>\n", $srno, $page_no;

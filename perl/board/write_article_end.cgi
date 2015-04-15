#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use CGI;
use lib "lib";
use Article;
use Util;

my $cgi = CGI->new;
my $util = Util->new;
unless($util->is_valid($cgi)){
    $util->invalidate($cgi);
    return;
}

my $ymd = $cgi->param("ymd");
my $status = $cgi->param("status");
my $title = $cgi->param("title");
my $content = $cgi->param("content");
my $category_srno = $cgi->param("category_srno");
################################################################################
my $dbh = DBI->connect($util->connect_info);
my $sql = "INSERT INTO article (created, ymd, status, title, content, category_srno) VALUES (now(), ?, ?, ?, ?, ?)";
my $sth = $dbh->prepare($sql);
$sth->execute($ymd, $status, $title, $content, $category_srno);
$sth->finish();
$dbh->disconnect();
################################################################################

print $cgi->header(
    -charset=>$util->get("charset")
    );
print "<script> location.href = 'list_article.cgi'; </script>\n";



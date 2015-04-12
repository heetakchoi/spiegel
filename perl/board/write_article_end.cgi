#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use CGI;
use lib "lib";
use Article;
use Util;

my $cgi = CGI->new;
unless(Util->is_valid($cgi)){
    Util->invalidate($cgi);
    return;
}

my $ymd = $cgi->param("ymd");
my $status = $cgi->param("status");
my $title = $cgi->param("title");
my $content = $cgi->param("content");
my $category_srno = $cgi->param("category_srno");
################################################################################
my $dbh = DBI->connect(Util->connect_info);
my $sql = "INSERT INTO article (created, ymd, status, title, content, category_srno) VALUES (now(), ?, ?, ?, ?, ?)";
my $sth = $dbh->prepare($sql);
$sth->execute($ymd, $status, $title, $content, $category_srno);
$sth->finish();
$dbh->disconnect();
################################################################################

print $cgi->header(
    -charset=>"euc-kr"
    );
print "<script> location.href = 'list_article.cgi'; </script>\n";



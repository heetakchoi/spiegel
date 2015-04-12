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

my $category_name = $cgi->param("category_name");
################################################################################
my $dbh = DBI->connect(Util->connect_info);
my $sql = "INSERT INTO category (category_name, created) VALUES (?, now())";
my $sth = $dbh->prepare($sql);
$sth->execute($category_name);
$sth->finish();
$dbh->disconnect();
################################################################################
print $cgi->header(
    -charset=>"euc-kr"
    );
print "<script> location.href = 'adm_list_category.cgi'; </script>\n";


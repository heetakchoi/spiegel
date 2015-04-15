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

my $category_name = $cgi->param("category_name");
################################################################################
my $dbh = DBI->connect($util->connect_info);
my $sql = "INSERT INTO category (category_name, created) VALUES (?, now())";
my $sth = $dbh->prepare($sql);
$sth->execute($category_name);
$sth->finish();
$dbh->disconnect();
################################################################################
print $cgi->header(
    -charset=>$util->get("charset")
    );
print "<script> location.href = 'adm_list_category.cgi'; </script>\n";


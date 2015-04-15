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

my $srno = $cgi->param("srno");
################################################################################
my $dbh = DBI->connect($util->connect_info);
my $sql = "DELETE FROM category WHERE srno = ?";
my $sth = $dbh->prepare($sql);
$sth->execute($srno);
$sth->finish();
$dbh->disconnect();
################################################################################
print $cgi->header(
    -charset=>$util->get("charset")
    );
print "<script> location.href = 'adm_list_category.cgi'; </script>\n";


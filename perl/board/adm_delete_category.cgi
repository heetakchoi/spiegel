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

my $srno = $cgi->param("srno");
################################################################################
my $dbh = DBI->connect(Util->connect_info);
my $sql = "DELETE FROM category WHERE srno = ?";
my $sth = $dbh->prepare($sql);
$sth->execute($srno);
$sth->finish();
$dbh->disconnect();
################################################################################
print $cgi->header(
    -charset=>"euc-kr"
    );
print "<script> location.href = 'adm_list_category.cgi'; </script>\n";


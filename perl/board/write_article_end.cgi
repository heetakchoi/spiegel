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

my $root_dir = $util->get("loc-upload");
my $buffer;

my $filename = $cgi->param("upload");
my $upload_fh = $cgi->upload("upload");
my $file_location = $root_dir. "/" . $filename;

while(-e $file_location){
    if($filename=~m/(.+)-(\d+)$/){
	$filename = $1."-".($2+1);
    }else{
	$filename .= "-1";
    }
    $file_location = $root_dir. "/" . $filename;
}
if (defined $upload_fh) {
    my $io_handle = $upload_fh->handle;
    open (my $file, ">" , $file_location);
    while (my $bytesread = $io_handle->read($buffer,1024)) {
	print $file $buffer;
    }
    close($file);
}
my $image_content_flag = 1 unless($filename eq "-1");
my $url = "/data/".$filename;
my $image_content = sprintf "<img src=\"%s\" /><br />\n", $url;

my $ymd = $cgi->param("ymd");
my $status = $cgi->param("status");
my $title = $cgi->param("title");
my $content = $cgi->param("content");
my $category_srno = $cgi->param("category_srno");

$content = $image_content . $content if($image_content_flag);
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

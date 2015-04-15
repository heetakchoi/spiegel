#!/usr/bin/perl

use strict;
use warnings;

use CGI;
use lib "lib";
use Util;

my $cgi = CGI->new;
my $util = Util->new;
unless($util->is_valid($cgi)){
    $util->invalidate($cgi);
    return;
}

my $root_dir = $util->get("loc-upload");
my $buffer;

my $back_url = $cgi->param("back_url");
my $filename = $cgi->param("upload");
my $upload_fh = $cgi->upload("upload");
my $file_location = $root_dir. "/" . $filename;

print $cgi->header(
    -charset=>$util->get("charset")
    );
print $cgi->start_html(
    -title=>"upload_end",
    -style=>$util->get("loc-css"),
    -script=>{type =>"text/javascript", src=>$util->get("loc-js")},
    -meta=>{"viewport"=>"width=device-width, initial-scale=1.0"},
    );
require "before.pl";

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

    print "Upload success.<br />\n";
    my $url = "/data/".$filename;
    print "<script> write location.href; </script>\n";
    print "<a href=\"", $url, "\" target=\"_blank\">$url</a><br />\n";
    print "<a href=\"", $back_url, "\">back</a>";

}else{
    print "Something wrong. Try again<br />\n";
    print "<a href=\"", $back_url, "\">back</a>";

}

require "after.pl";
print $cgi->end_html();

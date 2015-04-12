#!/usr/bin/perl

use strict;
use warnings;

use CGI;
use lib "lib";
use Util;

my $cgi = CGI->new;
unless(Util->is_valid($cgi)){
    Util->invalidate($cgi);
    return;
}

my $root_dir = "/home100/endofhope/www/data";
my $buffer;

my $back_url = $cgi->param("back_url");
my $filename = $cgi->param("upload");
my $upload_fh = $cgi->upload("upload");
my $file_location = $root_dir. "/" . $filename;

print $cgi->header(
    -charset=>"euc-kr"
    );
print $cgi->start_html(
    -title=>"tmpl",
    -style=>"style.css",
    -script=>{type =>"text/javascript", src=>"script.js"},
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

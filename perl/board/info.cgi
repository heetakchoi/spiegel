#!/usr/bin/perl

use strict;
use warnings;

use CGI;

my $cgi = CGI->new;

print $cgi->header(
    -charset=>"euc-kr"
    );
print $cgi->start_html(
    -title=>"Infomation",
    -style=>"style.css",
    -script=>{type =>"text/javascript", src=>"script.js"},
    -meta=>{"viewport"=>"width=device-width, initial-scale=1.0"},
    );
require "before.pl";

print  "<div class=\"main\">\n";
print  "<span style=\"font-size:1.2em;\">Went, going. But gone not yet.</span>";
print  "<div class=\"paragraph\">\n";
print  "<span style=\"font-weight:bold;\">Neurasthenia</span><br />";
printf " - <a href=\"%s\">Servlet specification 2.5</a> 구현체<br />\n", "https://jcp.org/aboutJava/communityprocess/mrel/jsr154/";
print  " - Comet streaming implementation.<br />\n";
printf " &nbsp;&nbsp; <a href=\"%s\">What is comet?</a><br />\n", "http://en.wikipedia.org/wiki/Comet_%28programming%29";
printf " - Repository in <a href=\"%s\">github</a><br />\n",
    "https://github.com/heetakchoi/neurasthenia";
printf " - Repository in <a href=\"%s\">naver</a><br />\n",
    "http://dev.naver.com/projects/neurasthenia";
printf " - Demo <a href=\"%s\">site</a><br />\n",
    "http://endofhope.linuxstudy.pe.kr:2780/";
print  "</div>\n";

print  "<div class=\"paragraph\">\n";
print  "<span style=\"font-weight:bold;\">서블릿 컨테이너의 이해</span><br />";
printf " - at <a href=\"%s\">yes24</a><br />\n",
    "http://www.yes24.com/24/Goods/12465573?Acode=101";
printf " - at <a href=\"%s\">한빛미디어</a><br />\n",
    "http://www.hanbit.co.kr/ebook/look.html?isbn=9788979149685";
print "</div>\n";

print "</div>\n"; # div.main

require "after.pl";
print $cgi->end_html();


#!/usr/bin/perl

use strict;
use warnings;

use CGI;

my $cgi = CGI->new;

print $cgi->header(
    -charset=>"euc-kr"
    );
print $cgi->start_html(
    -title=>"Old-fashioned life logging",
    -style=>"style.css",
    -script=>{type =>"text/javascript", src=>"script.js"},
    -meta=>{"viewport"=>"width=device-width, initial-scale=1.0"},
    );
require "before.pl";

print  "<div class=\"main\">\n";
print  "  <div class=\"paragraph\">\n";
print  "������ �� �ִ� ���� �и��ϰ� ������ �� �ִ�;<br />\n";
print  "���� �� ���� �Ϳ� ���ؼ��� ħ���ؾ� �Ѵ�.<br />\n";
print  "- �� ö�� ���, ������ ��Ʈ�ս�Ÿ��</a>";

print  "  </div>\n"; # div.paragraph

print  "  <div class=\"paragraph\">\n";
print  "  </div>\n"; # div.paragraph

print  "</div>\n"; # div.main

require "after.pl";
print $cgi->end_html();


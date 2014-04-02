#!/usr/bin/perl

use strict;
use warnings;
use lib "lib";

use Eoh::Math ("add");
use Eoh::Net ("send_get", "send_ssl_get");

print add(1, 2);
my %header_hash = ();
print send_get("endofhope.com", 80, "/", \%header_hash, 0);
print send_ssl_get("play.google.com", 443, "/store/apps/details?id=com.beatpacking.beat", \%header_hash, 1);

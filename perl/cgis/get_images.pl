#!/usr/bin/perl

use strict;
use warnings;
use lib "lib";
use Eoh::Net;
use Time::HiRes qw(usleep);

sub download_images;
sub pick_image_links;
sub proc_download;

my $container_url = "http://endofhope.com/dummy/img.html";
my $target_dir = "c:/home/tmp";

proc_download($container_url, $target_dir);	

my $img_url = "http://heetakchoi.github.io/me2day/img/20130117_33/endofhope_1358352777324JixBc_PNG/endofhope_891064861669577061.png";
download_image($target_dir, $img_url, 0);

sub proc_download{
	my ($container_url, $target_dir) = @_;
	if($container_url =~ m/http:\/\//i){
		$container_url = substr($container_url, 7);
	}

	my @units = split(/\//, $target_dir);
	my $check_dir = shift(@units);
	foreach my $unit (@units){
		$check_dir .= "/";
		$check_dir .= $unit;
		unless(-e $check_dir){
			mkdir($check_dir);
		}
	}
	my @image_links = pick_image_links($container_url);
	foreach (@image_links){
		download_image($target_dir, $_, 200);
	}
}

sub download_image{
	my ($target_dir, $image_url, $delay, $name) = @_;

	my $url = substr($image_url, 7);
	my $host = substr($url, 0, index($url, "/"));
	my $request_uri = substr($url, index($url, "/"));
	my $book_no = substr($target_dir, rindex($target_dir, "/")+1);
	my $image = substr($url, rindex($url, "/")+1);
	my $image_no = substr($image, 0, index($image, "."));
	if(defined($name)){
		my $ext = substr($image, index($image, "."));
		$image = $name . $ext;
	}
	my $target = $target_dir . "/" . $image;

	if($delay){
		usleep($delay);
	}

	my $net = Eoh::Net->new();
    my %header_hash = ();
	my $response = $net->send_get($host, 80, $request_uri, \%header_hash, 1);
	open(my $fh, ">", $target);
	binmode $fh;
	print $fh $response;
	close($fh);

	print "save: ", $target, "\n";
}

sub pick_image_links{
	my ($container_url) = @_;
	my @image_links = ();

	my $net = Eoh::Net->new();
	my %header_hash = ();
	my $host = substr($container_url, 0, index($container_url, "/"));
	my $request_uri = substr($container_url, index($container_url, "/"));
	my $content = $net->send_get($host, 80, $request_uri, \%header_hash, 1);
	while($content =~ m/\ssrc="([^"]+)"/g){
		push(@image_links, $1);
	}
	return @image_links;
}


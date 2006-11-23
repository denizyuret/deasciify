#!/usr/bin/perl -w
use strict;

while(<>) {
    my ($class, $str) = /^(\d) (.+)$/;
    $str =~ s/ /_/g;
    substr($str, 10, 1, 'X');
    print $class;
    for my $l (0 .. 9) {
	for my $r (0 .. 9) {
	    next if $l == 0 and $r == 0;
	    my $val = substr($str, 10 - $l, $l + $r + 1);
	    print " $val";
	    last if substr($str, 10+$r, 1) eq '_';
	}
    }
    print "\n";
}

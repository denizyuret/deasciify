#!/usr/bin/perl -w
# Extract data from milliyet on a single ascii letter

use strict;
use locale;
use POSIX qw(locale_h);
setlocale(LC_ALL, "tr_TR.iso88599");

my $letter = shift;
my $window = 10;

# Output +-$window characters lowercased in ascii as evidence
# classify 1 if letter needs to be corrected, 0 otherwise

my $tr_buf;

while(<>) {
    if (/^<\/S>/) {
	process($tr_buf) if $tr_buf;
	undef $tr_buf;
    } elsif (/^</) {
	next;
    } else {
	s/\s+/ /g;
	$tr_buf .= lc($_);
    }
}
process($tr_buf) if $tr_buf;

sub process {
    $tr_buf =~ s/\W+/_/g;
    $tr_buf = ('_' x $window) . $tr_buf . ('_' x $window);
    my $en_buf = $tr_buf;
    $en_buf =~ tr/çðýöþü/cgiosu/;
#    print $en_buf . "\n"; return;
    my $lc_buf = $tr_buf;
    $lc_buf =~ tr/çðýöþü/CGIOSU/;
#    print "$tr_buf\n$en_buf\n";
    my $pos = -1;
    while(($pos = index($en_buf, $letter, $pos + 1)) >= 0) {
#	print "tr_buf = [".substr($tr_buf, $pos, 1)."\n";
#	print "en_buf = [".substr($en_buf, $pos, 1)."\n";
	print 0 + (substr($tr_buf, $pos, 1) ne substr($en_buf, $pos, 1)),
	' ' , substr($lc_buf, $pos - $window, 2*$window + 1), "\n";
    }
}

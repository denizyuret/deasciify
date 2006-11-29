#!/usr/bin/perl -w
# Determine ambiguous turkish words when converted to ascii
# Input assumed one word per line in Latin-5

use strict;
use locale;
use POSIX qw(locale_h);
setlocale(LC_ALL, "tr_TR.iso88599");

my %word;
while(<>) {
    chomp;
    next unless /\w/;
    my $lcword = lc();
    my $ascii = $lcword;
    $ascii =~ tr/çðýöþü/cgiosu/;
    $word{$ascii}{$lcword}++;
}

for my $w (keys %word) {
    my @a = keys %{$word{$w}};
    next if scalar(@a)==1;
    print join(' ', $w, @a, "\n");
}

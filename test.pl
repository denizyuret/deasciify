#!/usr/bin/perl -w
use strict;
my $file = shift;
$file =~ /^(\w)\.out$/ or die;
my $letter = $1;
my $cmd = qq{zcat test.100k | instances.pl $letter | features | dlist -t $file |};
warn "$cmd\n";
open(FP, $cmd) or die;
my $ans = <FP>;
close(FP);
$ans = 1/(1-$ans);
print "$file\t$ans\n";

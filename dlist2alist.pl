#!/usr/bin/perl -w
# Convert a dlist model into an alist
use strict;

my @model = <>;
$model[0] =~ s/^\S+/$& X/;

print "(";
for (my $i = $#model; $i >= 0; $i--) {
    $model[$i] =~ s/\s+\#.*//;
    my ($class, @pat) = split(' ', $model[$i]);
    die if scalar(@pat) != 1;
    my $pat = $pat[0];
    # $pat =~ s/[\W_]/ /g;
    $pat =~ s/_/ /g;
    $pat =~ s/\"/\\\"/g;
    if ($class == 0) {
	print "(\"$pat\") ";
    } else {
	print "(\"$pat\" . t) ";
    }
}
print ")\n";

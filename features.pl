#!/usr/bin/perl -w
use strict;

my $mode;
if (@ARGV and $ARGV[0] =~ /^\d+$/) {
    $mode = shift;
} else {
    $mode = 1;
}

# input comes with 21 letter windows around the target with all
# lowercase letters except for Turkish letters represented with
# uppercase.

# What we print depends on the mode:
# Bit 0: print all letters
my $PRINT_ALL = (1<<0);
# Bit 1: print replace consonants with B
my $PRINT_NO_CONSONANTS = (1<<1);
# Bit 2: print replace vowels with A
my $PRINT_NO_VOWELS = (1<<2);
# Bit 3: keep caps on the left
my $KEEP_LEFT_CAPS = (1<<3);
# Bit 4: keep caps on the right
my $KEEP_RIGHT_CAPS = (1<<4);

while(<>) {
    my ($class, $str) = /^(\d) (.+)$/;

    # Convert sequences of non-alnum characters to '_'
    my $pre = substr($str, 0, 10);
    $pre =~ s/\W+/_/g;
    my $post = substr($str, 11, 10);
    $post =~ s/\W+/_/g;
    if (($mode & $KEEP_LEFT_CAPS) == 0) { $pre = lc($pre); }
    if (($mode & $KEEP_RIGHT_CAPS) == 0) { $post = lc($post); }

    # The base pattern has $l letters on the left and $r letters on
    # the right

    print $class;

    for my $l (0 .. length($pre)) {
	my $a = substr($pre, -$l, $l);
	for my $r (0 .. length($post)) {
	    next if $l+$r == 0;	# everybody has 'X'
	    my $b = substr($post, 0, $r);
	    my $p = $a . 'X' . $b;
	    if ($mode & $PRINT_ALL) { 
		print " $p";
	    }
	    if ($mode & $PRINT_NO_CONSONANTS) {
		my $nc = $p;
		$nc =~ s/[^aeiouAEIOUX_]/B/g;		
		print " $nc";
	    }
	    if ($mode & $PRINT_NO_VOWELS) {
		my $nv = $p;
		$nv =~ s/[aeiouAEIOU]/A/g;
		print " $nv";
	    }
	}
    }
    print "\n";
}

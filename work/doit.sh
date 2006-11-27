#!/bin/sh
zcat | ./features.pl 9 | perl -pe 's/\s+/\n/g' | ./rcount

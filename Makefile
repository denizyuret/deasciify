all: c.lst g.lst i.lst o.lst s.lst u.lst

%.lst: Milliyet.clean.bz2 instances.pl features.pl dlist Makefile
	bzcat Milliyet.clean.bz2 \
	| instances.pl $* \
	| head -100000 \
	| features.pl \
	| gpa -d 1 -w 100 > $@
#	| dlist -m 500 > $@

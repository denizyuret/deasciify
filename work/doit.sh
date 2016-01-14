#!/bin/sh
zcat $1.inst.gz | head -1100000 | ./features $1.rep.gz | ./gpa -d 1 -w 1000 -v 11

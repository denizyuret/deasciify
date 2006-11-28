#!/bin/sh
zcat | head -1100000 | ./features | ./gpa -d 1 -w 1000 -v 11

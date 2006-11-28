#!/bin/sh
zcat | head -500000 | ./features | ./gpa -d 1 -w 500

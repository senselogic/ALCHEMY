#!/bin/sh
set -x
dmd -debug -g -gf -gs -m64 shift.d
rm *.o

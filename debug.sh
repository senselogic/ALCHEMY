#!/bin/sh
set -x
dmd -debug -g -gf -gs -m64 switch.d
rm *.o

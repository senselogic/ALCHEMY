#!/bin/sh
set -x
dmd -debug -g -gf -gs -m64 basalt.d
rm *.o

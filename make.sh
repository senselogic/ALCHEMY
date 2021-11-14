#!/bin/sh
set -x
dmd -m64 basalt.d
rm *.o

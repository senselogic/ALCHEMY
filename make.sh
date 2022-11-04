#!/bin/sh
set -x
dmd -m64 shift.d
rm *.o

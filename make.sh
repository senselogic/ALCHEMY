#!/bin/sh
set -x
dmd -m64 switch.d
rm *.o

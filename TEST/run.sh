#!/bin/sh
set -x
../basalt --read-sql blog.sql --write-bd blog.bd

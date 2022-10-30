#!/bin/sh
set -x
../basalt --read-csv character.csv --write-bd character.bd
../basalt --read-sql blog.sql --write-bd blog.bd

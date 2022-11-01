#!/bin/sh
set -x
../basalt --read-csv character.csv CHARACTER --write-bd character.bd --process character.bt character.txt
#../basalt --read-sql blog.sql --write-bd blog.bd

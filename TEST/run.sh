#!/bin/sh
set -x
../shift --read-sql blog.sql --write-bd blog.bd
../shift --read-sql blog.sql --write-csv blog_article.csv ARTICLE --write-csv blog_comment.csv COMMENT
../shift --read-csv character.csv CHARACTER --write-bd character.bd --write-txt character.txt character.st

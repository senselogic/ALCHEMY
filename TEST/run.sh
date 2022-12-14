#!/bin/sh
set -x
../switch --read-sql blog.sql --write-bd blog.bd
../switch --read-sql blog.sql --write-csv blog_article.csv ARTICLE --write-csv blog_comment.csv COMMENT
../switch --read-csv character.csv CHARACTER --write-bd character.bd --run-js character.js

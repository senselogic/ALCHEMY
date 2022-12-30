#!/bin/sh
set -x
../alchemy --read-sql blog.sql --write-bd blog.bd
../alchemy --read-sql blog.sql --write-csv blog_article.csv ARTICLE --write-csv blog_comment.csv COMMENT
../alchemy --read-csv character.csv CHARACTER --write-bd character.bd --run-js character.js

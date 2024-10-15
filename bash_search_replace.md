# bash_search_replace

Order directories based on size

> find . -type f  -exec du -h {} + | sort -r -h

Find files containg a token

> find -iname "*.java" | xargs grep -iR token

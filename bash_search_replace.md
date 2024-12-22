# bash_search_replace

Order directories based on size

> find . -type f  -exec du -h {} + | sort -r -h

Find files containg a token

> find -iname "*.java" | xargs grep -iR token#

> find . -not -path '*/.*' -type f | xargs grep -A 2 -B 2 --color -Hn "token"

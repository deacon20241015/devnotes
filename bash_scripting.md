# bash_scripting

## looping
Looping constructs see https://www.gnu.org/software/bash/manual/html_node/Looping-Constructs.html

```sh
#!/bin/bash

results=$(command)
for result in $results
do
# do something
done
```
or directly something like `for filename in $(find $1); do # do something`

## Params, conditions
Conditional constructs see https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html 

```sh
if [ -z "$1" ]
    then
    echo "param not set"
fi
```

```sh
if [ $durationsec -lt 60 ]; then
# do something
elif [ $durationsec -ge 60 ]; then
# do something
fi
```

```sh
case $file in
  *.mp4|*.MP4)
  # do something
  ;;
  *.avi)
  # do something
  ;;
esac
```

## rename
Parameter expansion see https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html

Rename input.JPG to input-1080p-jpg ($i param in loop):
```sh
convert $i -geometry 1920x -crop 1920x1080+0+100 -quality 100 ${i%.*}-1080p.jpg;
```
Rename all JPGs in current directory to filenames consisting of numbers:
```sh
let a=0; for i in *.JPG; do let a=a+1; mv $i $a.jpg; done
```

## colors
```sh
#!/bin/bash

BLUE="\e[34m"
RED="\e[31m"
ENDCOLOR="\e[0m"

echo -e "${BLUE}kubectl${ENDCOLOR} get cm -n $namespace $configmap -o yaml"

# $1 is a parameter to seach for which will be highlighted red
output=$(kubectl get cm -n $namespace $configmap -o yaml | grep -n $1 -A 2 -B 2)
echo -e "${output//$1/${RED}$1${ENDCOLOR}}"
```

## inline comments
Used in some of my automatically generated melt-scripts (especially for video-files)
```sh
command `# comment` \
```

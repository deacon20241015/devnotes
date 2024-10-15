# bash_scripting

### looping
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

### Params, conditions
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

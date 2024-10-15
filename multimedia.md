# multimedia

Some commands (from some local scripts). 

Maybe some are wrong, some commands not used for a very long time so i can't remember every detail...

Mostly they are related to create some videos from my holidays or just to make some experiments

## convert
https://imagemagick.org/script/convert.php

input: 5184x3888 output: 3840x2160
```sh
convert input.jpg -geometry 3840x -quality 100 output-temp.jpg
convert output-temp.jpg -geometry 3840x -crop 3840x2160+0+360 -quality 100 output.jpg
```
create thumbnails
> for i in *.[jJpPgG][pPnNiI][gGfF]; do convert "$i" -resize %10 small_"$i"; done

```sh
convert input.jpg \
       \( -clone 0 -blur 0x5 -resize 1920x1080\! -fill white -colorize 20% \) \
       \( -clone 0 -resize 1920x1080 \) \
       -delete 0 -gravity center -composite \
       output.jpg
```

## exiv2
https://exiv2.org/

```sh
exiv2 -r'%Y-%m-%d_%H-%M-%S_:basename:' rename *.JPG
```

## exif
> exif image.jpg

## exiftool
https://wiki.ubuntuusers.de/ExifTool/

> exiftool -r '-FileName<CreateDate' -d '%Y-%m-%d/%H_%M_%S%%-c.%%le' .

> exiftool -AllDates image.jpg

## ffmpeg
https://www.ffmpeg.org/

ffmpeg -i input.avi -f mp3 -ab 160000 -acodec libmp3lame output.avi
ffmpeg -ss 0s -i input.avi -t 12s -acodec copy -vcodec copy output.avi

Not happy with the following result -> buy'd a gopro
```sh
ffmpeg -y -i $1 \
      -vf vidstabdetect=stepsize=32:shakiness=10:accuracy=10:result=transforms.trf \
      -c:v libx264 -b:v 5000k -s 1920x1080 -an -pass 1 -f rawvideo /dev/null
ffmpeg -y -i $1 \
      -vf vidstabtransform=input=transforms.trf:zoom=0:smoothing=10,unsharp=5:5:0.8:3:3:0.4 \
      -vcodec libx264 -b:v 5000k -s 1920x1080 -c:a libmp3lame -b:a 192k -ac 2 -ar 44100 -pass 2 \
      ${1%.*}_twoSteps.mp4
```

## ffprobe
https://ffmpeg.org/ffprobe.html

Extract codec, bitrate, framerate and duration from a video
```sh
ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 input.avi
ffprobe -v error -select_streams v:0 -show_entries stream=bit_rate -of default=noprint_wrappers=1:nokey=1 input.avi
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 input.avi
ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 input.avi
```

## identify
https://imagemagick.org/script/identify.php 

Get width, height from an image:
```sh
identify -verbose input.jpg
identify -format "%[fx:w]" input.jpg
identify -format "%[fx:h]" input.jpg
identify -format "%[fx:w]x%[fx:h]" input.jpg
```

## darktable
https://www.darktable.org/ 

AFAIR i used this tool to convert NEF-Files from by Nikon D3300
> darktable-cli input.nef input-nef.jpg

## mencoder
https://wiki.ubuntuusers.de/MEncoder/

mencoder input.avi -ovc lavc -ffourcc DX50 -lavcopts vcodec=mpeg4:vbitrate=9000:vhq -oac mp3lame -o output.avi

## melt
https://www.mltframework.org/docs/melt/

Note: Only works with an old version of melt...

```sh
#/!/usr/bin/env bash

melt \
color:black out=1 \
-track \
   13_Trenta/05_44_00-1080p.jpg out=249 \
   13_Trenta/06_16_58_twoSteps.mp4 -mix 50 -mixer luma \
\
 \
 -transition mix:-1 always_active=1 a_track=0 b_track=1 sum=1  \
 -transition frei0r.cairoblend a_track=0 b_track=1 disable=0 \
 -profile atsc_1080p_50 \
 -consumer avformat:output.avi acodec=libmp3lame vcodec=libx264
```

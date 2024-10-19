# ffmpeg

Some notes for creating videos from my holidays on CLI (wrapped in some scripts)

## speedup video

Scale down a gopro vid to 1080p, speedup by factor 2 and use only 25fps with (default) h264 codec: 

```sh
ffmpeg -i input.mp4\
 -filter_complex "[0:v]setpts=0.5*PTS,scale=1920:1080,fps=25[v];[0:a]atempo=2.0[a]"\
 -map "[v]"\
 -map "[a]"\
 -crf 20 output.mp4
```

Change codec with something like `-c:v libx265 -b:v 45107k`

## slideshow

Make a slideshow from 2 images including a zoom effect (https://en.wikipedia.org/wiki/Ken_Burns_effect) resulting in a video of 9 second

```sh
ffmpeg\
 -loop 1 -t 5 -framerate 25 -i image1.jpg\
 -loop 1 -t 5 -framerate 25 -i image2.jpg\
 -filter_complex \
     "[0]scale=8000:-1,zoompan=z='zoom+0.001':x=iw/2-(iw/zoom/2):y=ih/2-(ih/zoom/2):d=5*25:fps=25[s0];\
      [1]scale=8000:-1,zoompan=z='zoom+0.001':x=iw/2-(iw/zoom/2):y=ih/2-(ih/zoom/2):d=5*25:fps=25[s1];\
      [s0][s1]xfade=transition=circleopen:duration=2:offset=4" \
  -t 9 -c:v libx264 -y output.mp4
```
See e.g. https://www.bannerbear.com/blog/how-to-do-a-ken-burns-style-effect-with-ffmpeg/ and https://www.bannerbear.com/blog/how-to-create-a-slideshow-from-images-with-ffmpeg/

For three videos:

```sh
ffmpeg\
 -loop 1 -t 5 -framerate 25 -i image1.jpg\
 -loop 1 -t 5 -framerate 25 -i image2.jpg\
 -loop 1 -t 5 -framerate 25 -i image3.jpg\
 -filter_complex \
     "[0]scale=8000:-1,zoompan=z='zoom+0.001':x=iw/2-(iw/zoom/2):y=ih/2-(ih/zoom/2):d=5*25:fps=25[s0];\
      [1]scale=8000:-1,zoompan=z='zoom+0.001':x=iw/2-(iw/zoom/2):y=ih/2-(ih/zoom/2):d=5*25:fps=25[s1];\
      [2]scale=8000:-1,zoompan=z='zoom+0.001':x=iw/2-(iw/zoom/2):y=ih/2-(ih/zoom/2):d=5*25:fps=25[s2];\
      [s0][s1]xfade=transition=circleopen:duration=2:offset=4[f0];\
      [f0][s2]xfade=transition=circleopen:duration=2:offset=8" \
  -t 13 -c:v libx264 -y output.mp4
```

## put text on video
Example to put text at different positions and times:

```sh
ffmpeg -i input.mp4\
 -vf "\
    drawtext=text='My text center/bottom':enable='between(t,1,3)':x=(w-text_w)/2:y=h-th:fontsize=48:fontcolor=black:box=1:boxcolor=white@0.5:boxborderw=5,\
    drawtext=text='My text center/center':enable='between(t,4,8)':x=(w-text_w)/2:y=(h-text_h)/2:fontsize=96:fontcolor=black:box=1:boxcolor=white@0.5:boxborderw=5\
 " \
 -c:v -y output.mp4
```

See e.g. https://stackoverflow.com/questions/17623676/text-on-video-ffmpeg

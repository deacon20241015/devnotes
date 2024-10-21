#!/bin/bash

# This directory contains (not pushed to github) the following video- and image-files:
#
# (1) orig1.JPG  - 5184x2920             (NIKON COOLPIX A900)
# (2) orig2.MP4  - 2704x1520 H.264 50fps (Hero GoPro 12, 2,7k Video), 13 sec
# (3) orig3.JPG  - 5184x2920             (NIKON COOLPIX A900)
# (4) orig4.MP4  - 3840x2160             (unknown), 7 sec
# (5) orig5.JPG  - 5184x3888             (NIKON COOLPIX A900)
#
# This example.sh-File will create a video with the following characteristics: 1080p (1920x1080), 25fps
# (1)    - zoompan in the first image (ibex) to center
# (1)(2) - fade to video
# (2)    - video
# (2)(3) - fade to image
# (3)    - zoompan to bottom/left (will result in Karwendel-Sign in center)
# (3)(4) - fade to video
# (4)    - video
# (4)(5) - fade to image
# (5)    - zoompan to center top (fast)

# Step 0:
# a) Convert the Images to 1920x1080. Note: Cropped 360 pixels (180 top + 180 bottom) in orig5 (since it would be 1920x1440 with aspect ratio)
convert orig1.JPG -geometry 1920x1080! -quality 100 orig1-1080p.jpg
convert orig3.JPG -geometry 1920x1080! -quality 100 orig3-1080p.jpg
convert orig5.JPG -geometry 1920x -crop 1920x1080+0+180 -quality 100 orig5-1080p.jpg
# b) Convert the Videos to 1920x1080 at 25fps (unsure about the bitrate of 8000k)
ffmpeg -i orig2.MP4 -vf scale=1920:1080 -r 25 -b:v 8000k orig2-1080p.mp4
ffmpeg -i orig4.MP4 -vf scale=1920:1080 -r 25 -b:v 8000k orig4-1080p.mp4

# Step 1:
# Each of the three images (orig1-1080p.jpg, orig3-1080p.jpg and orig5-1080p.jpg) will be converted into a single video (5 seconds) with different zoompan:
# Image1 orig1-1080p.jpg -> orig1-1080.mp4: Zoom to center
ffmpeg \
  -loop 1 -framerate 25 -t 5 -i orig1-1080p.jpg                         `# [0:v]` \
  -f lavfi -t 0.1 -i anullsrc=channel_layout=stereo:sample_rate=44100   `# [1:a]` \
  -filter_complex "\
    [0:v][1:a]concat=1:v=1:a=1[out];\
    [out]scale=8000:-1,zoompan=z='zoom+0.001':s=1920x1080:x=iw/2-(iw/zoom/2):y=ih/2-(ih/zoom/2):d=5*25[out2]\
   "\
   -vsync vfr -acodec aac -vcodec libx264 -map [out2] -map 0:a? -t 5 -y orig1-1080p.mp4;
# Image2 orig3-3080p.jpg -> orig3-1080.mp4: Zoom to bottom left
ffmpeg \
  -loop 1 -framerate 25 -t 5 -i orig3-1080p.jpg                         `# [0:v]` \
  -f lavfi -t 0.1 -i anullsrc=channel_layout=stereo:sample_rate=44100   `# [1:a]` \
  -filter_complex "\
    [0:v][1:a]concat=1:v=1:a=1[out];\
    [out]scale=8000:-1,zoompan=z='zoom+0.001':s=1920x1080:x=0:y=ih:d=5*25[out2]\
   "\
   -vsync vfr -acodec aac -vcodec libx264 -map [out2] -map 0:a? -t 5 -y orig3-1080p.mp4;
# Image3 orig5-3080p.jpg -> orig5-1080.mp4: Zoom to center top (fast since 0.010 and not like before 0.001)
ffmpeg \
  -loop 1 -framerate 25 -t 5 -i orig5-1080p.jpg                         `# [0:v]` \
  -f lavfi -t 0.1 -i anullsrc=channel_layout=stereo:sample_rate=44100   `# [1:a]` \
  -filter_complex "\
    [0:v][1:a]concat=1:v=1:a=1[out];\
    [out]scale=8000:-1,zoompan=z='zoom+0.010':s=1920x1080:x=iw/2-(iw/zoom/2):y=0:d=5*25[out2]\
   "\
   -vsync vfr -acodec aac -vcodec libx264 -map [out2] -map 0:a? -t 5 -y orig5-1080p.mp4;
   
# Video will be 31 sec (5 + 13 + 5 + 7 + 5 = 35 sec and 4x duration 1 fade -> 31 sec)
 
# about offsets: https://stackoverflow.com/questions/63553906/merging-multiple-video-files-with-ffmpeg-and-xfade-filter
  
#  0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
#  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 
#  ---------------                                 ----------------              ----------------
#  | Image 1 (5s) |                                | Image 2 (5s) |              | Image 3 (5s) |
#  ----------------------------------------------------------------------------------------------
#              | Video 1 (13s)                        |        | Video 2 (7s)       |
#              ----------------------------------------        ----------------------
ffmpeg\
  -i orig1-1080p.mp4   `# [0] 5s` \
  -i orig2-1080p.mp4   `# [1] 13s`\
  -i orig3-1080p.mp4   `# [2] 5s` \
  -i orig4-1080p.mp4   `# [3] 7s` \
  -i orig5-1080p.mp4   `# [4] 5s` \
  -f lavfi -i anullsrc `# [5] TODO prüfen ob notwendig wenn backgroundmusic aktiv ist....` \
  -i audio.mp3         `# [6] long music, will be trimmed to 31s later` \
  -filter_complex "\
     [0:v][1:v]xfade=transition=fade:duration=1:offset=4[vfade1];     `# vid: image1->video2: 5s. offset=4 since video 5s` \
     [vfade1][2:v]xfade=transition=fade:duration=1:offset=16[vfade2]; `# vid: video2->image3: 13s. offset=13 + lastfade -1 = 13+4-1 = 16` \
     [vfade2][3:v]xfade=transition=fade:duration=1:offset=20[vfade3]; `# vid: image3->video4: 5sec + lastfade -1 = 5+16-1 = 20` \
     [vfade3][4:v]xfade=transition=fade:duration=1:offset=26[v];      `# vid: video4->image5: 7sec+lastfade-1 = 7+20-1 = 26` \
     [6:a]atrim=0:31,volume=0.3[backgroundmusic];                     `# background music [mp3], trim to 31sec, will be merged at the end `\
     [5:a]atrim=0:4[silence1];                                        `# audio: 4s seconds no audio `\
     [1:a]afade=in:0:d=5,afade=out:st=8:d=5[0B];                      `# audio: 13sec from video1` \
     [5:a]atrim=0:4[silence2];\                                       `# audio: 4s seconds no audio `\
     [3:a]afade=in:0:d=1,afade=out:st=5:d=1,volume=0.2[0D];           `# audio: 7s from video2 `\
     [5:a]atrim=0:4[silence3];\                                       `# audio: 4s seconds no audio `\
     [silence1][0B][silence2][0D][silence3]concat=n=5:v=0:a=1[videomusic]; `# music from videos and silence fr videos from images`\
     [backgroundmusic][videomusic]amix=inputs=2[a]                         `# merge two audio tracks`\
  "\
  -vsync vfr -acodec aac -map "[v]" -map "[a]" -y example-result-1080p.mp4

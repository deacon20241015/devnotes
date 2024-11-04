#!/bin/bash

##############################################################################################
# function to create a video file from a still image                                         #
# + input-file will be copy'd (if not already existing) to target-directory                  #
# + a 5 sec video will be created (if not already existing)                                  #
# + filename of video will "be returned" and added to a "list".                              #
# params:                                                                                    #
# - $1 - a path witout tailing '/'    - e.g. /media/oliver/2015/05/alpe-adria/bovec          #
# - $2 - a filename available in $1   - e.g. DSC_0533.NEF-1080p.jpg                          #
# - $3 - a local output directory     - e.g. 2015.05.bovec                                   #
##############################################################################################

configThreads='-threads 2'
configQuiet='-loglevel quiet'

targetLengthOfVideo="5"
targetFramerateOfVideo="25"
targetDimensionOfVideo="1920x1080"

function to_mp4(){
  sourceDirectory=$1
  sourceFilename=$2
  targetDirectory=$3
  
  if [ ! -f $targetDirectory/$sourceFilename ]; then
    cp $sourceDirectory/$sourceFilename $targetDirectory
  else
    echo "__imgToVid.sh__ $(date) $targetDirectory/$sourceFilename already exists"
  fi

  source=$sourceDirectory/$sourceFilename
  targetFilename=$sourceFilename-1080p.mp4

  target=$targetDirectory/$targetFilename

  if [ ! -f $target ]; then
    sourceDimension=$(get_image_dimension $source)

    echo "__imgToVid.sh__ $(date) Create video: src img (${sourceDimension}) -> (${targetLengthOfVideo}s, ${targetFramerateOfVideo}fps, ${targetDimensionOfVideo}, zoom to center) from $source..."

    ffmpeg ${configQuiet} ${configThreads} \
      -loop 1 -framerate ${targetFramerateOfVideo} -t ${targetLengthOfVideo} -i ${source} `# [0:v]` \
      -i silentaudio.mp3                                                                  `# [1:a]` \
      -filter_complex "\
      	[0:v]scale=8000:-1,zoompan=z='zoom+0.001':s=${targetDimensionOfVideo}:x=iw/2-(iw/zoom/2):y=ih/2-(ih/zoom/2):d=${targetLengthOfVideo}*${targetFramerateOfVideo}[v];\
  	    [1:a]atrim=0:5[a]\
      "\
      -acodec aac -vcodec libx264 -map [v] -map [a] -t ${targetLengthOfVideo} -n ${configThreads} ${target}
  else
    echo "__imgToVid.sh__ $(date) ${target} already exists"
  fi
}

function get_image_dimension() {
  echo $(identify -format "%[fx:w]x%[fx:h]" $1)
}

to_mp4 $1 $2 $3
#to_mp4 /media/oliver/Data/multimedia_1080p/multimedia_bis_inkl_2020/2023/2023.05.27-2023.06.04-Slowenien/05_27_Sa__Drachenfels_Stuttgart DSCN9104.JPG 2023.05.slowenien

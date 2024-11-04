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
# video will be normalized alone, this allows a "similar" loudness of the merged video
filterAudio='-filter:a loudnorm'
targetFramerateOfVideo="25"
targetDimensionOfVideo="1920x1080"
#bitrate="-b:v 8000k"
bitrate=""

function to_25fps(){
  sourceDirectory=$1
  sourceFilename=$2
  targetDirectory=$3

  source=$sourceDirectory/$sourceFilename
  targetFilename=$sourceFilename-1080p.mp4
  target=$targetDirectory/$targetFilename

  if [ ! -f $targetDirectory/$sourceFilename ]; then
    cp $sourceDirectory/$sourceFilename $targetDirectory
  else
    echo "__vidToVid.sh__ $(date) $targetDirectory/$sourceFilename already exists"
  fi


  if [ ! -f $target ]; then
    #echo "target $target does not exist yet"

    sourceDimension=$(get_video_dimension $source)
    sourceExactLengtg=$(get_videolength_exact $source)
    targetLength=$(get_videolength $source)
    sourceFramerate=$(get_framerate $source)

    #echo "sourceExactLengtg=$sourceExactLengtg"
    #echo "targetLength=$targetLength"
    #echo "sourceDimension=$sourceDimension"
    #echo "sourceFramerate=$sourceFramerate"

    echo "$(date) Create video: src vid: ${sourceExactLengtg}sec, ${sourceFramerate}fps, ${sourceDimension} -> ${targetLength}sec, ${targetFramerateOfVideo}fps, 1920x1080) from ${source} "

    # extract to an *exact* number of seconds
    ffmpeg ${configQuiet} ${configThreads} -i ${source} ${filterAudio} -vf scale=${targetDimensionOfVideo} -r ${targetFramerateOfVideo} ${bitrate} -t ${targetLength} -y ${configThreads} ${target}

  else
    echo "__vidToVid.sh__ $(date) ${target} already exists"
  fi
}

function get_video_dimension() {
  echo $(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0:s=x $1)
}

function get_videolength() {
  seconds=$(ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 $1)
  echo ${seconds%%.*}
}

function get_videolength_exact() {
  echo $(ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 $1)
}

function get_framerate() {
  echo $(ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 $1)
}

to_25fps $1 $2 $3
#to_25fps /media/oliver/Data/multimedia_1080p/multimedia_bis_inkl_2020/2023/2023.05.27-2023.06.04-Slowenien/05_27_Sa__Drachenfels_Stuttgart DSCN9107.MP4 2023.05.slowenien
#to_25fps /media/oliver/Data/multimedia_1080p/multimedia_bis_inkl_2020/2015/05_Alpe_Adria_Trail/12_bovec_kobarid 00128_12.05.2015_NP_wasserfall_twoSteps.mp4 2023.05.slowenien

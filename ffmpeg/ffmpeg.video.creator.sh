#!/bin/bash

#
# chmod +x ffmpeg.video.creator.sh
# ./ffmpeg.video.creator.sh
#
# Prepares images/videos and creates a "ffmpeg.video.creator.test.sh" (which finally creates the video).

# TODO(!) feature: add audio
# TODO(!) confingurable: num threads (currently 1, very slow: 7,1 fps... without limit my cooler gets creazy...)
# TODO(!) scale images (if they are not 16:9), see 'convert' in https://github.com/oliverbauer/multimedia - unknown if to_mp4() works with its scale for 16:9-compiant images, e.g. 5184x2920. At least i have a log of non 16:9-images...
# TODO refactoring: improve naming of variables
# TODO refactoring: improve comments in generated shell-script
# TODO extend: read input file containing images/videos to use (ease script / make it more useful for other videos)
# TODO extend: add option/function for zooming to: center, top-left, top-right, bottom-right...
# TODO configurable: without intermediate copying files
# TODO configurable: cleanup after encoding
# TODO configurable: override existing files? (-y/-n)
# TODO concider: maybe python is more readable / better to understand? (it would be easier to have some maps remembering meta-data for audio)...

directory='/media/oliver/Data/multimedia_1080p/multimedia_bis_inkl_2020/2015/05_Alpe_Adria_Trail'
day1='10_kranjska_gora-trenta'
day2='11_trenta_bovec'
configThreads='-threads 2'

# $1 directory like "/media/oliver/Data/multimedia_1080p/multimedia_bis_inkl_2020/2015/05_Alpe_Adria_Trail/10_kranjska_gora-trenta"
# $2 filename like "DSC_0533.NEF-1080p.jpg"
# $3 target-directory (locally) like "2015.05.alpe.test"
#
# file will be copy'd to target-directory and a 5 sec video will be created. Filename of video will "be returned" and added to a "list".
function to_mp4(){
   cp $1$2 $3
   filename=$3/$2
   outputfilename=${2%.*}-1080p.mp4
   ffmpeg -threads 1 \
    -loop 1 -framerate 25 -t 5 -i $filename                               `# [0:v]` \
    -f lavfi -t 0.1 -i anullsrc=channel_layout=stereo:sample_rate=44100   `# [1:a]` \
    -filter_complex "\
      [0:v][1:a]concat=1:v=1:a=1[out];\
      [out]scale=8000:-1,zoompan=z='zoom+0.001':s=1920x1080:x=iw/2-(iw/zoom/2):y=ih/2-(ih/zoom/2):d=5*25[out2]\
     "\
     -vsync vfr -acodec aac -vcodec libx264 -map [out2] -map 0:a? -t 5 -n $configThreads $3/$outputfilename;
   echo $outputfilename
}

function to_25fps(){
   cp $1$2 $3
   filename=$3/$2
   outputfilename=${2%.*}-1080p.mp4
   ffmpeg -i $filename -vf scale=1920:1080 -r 25 -b:v 8000k -n $configThreads $3/$outputfilename
   echo $outputfilename
}

function get_videolength() {
  seconds=$(ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 $1)
  echo ${seconds%%.*}
}

function main() {
  mkdir $1

  # short version for testing purposes, see TODO above: move this to some external file given as input to this script
  ARRAY=()
  # DAY01
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0533.NEF-1080p.jpg $1))
  ARRAY+=($(to_25fps $directory/$day1/ 00079_10.05.2015_kranjska_gora_berge_twoSteps.mp4 $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0462.NEF-1080p.jpg $1))
  # DAY02
  ARRAY+=($(to_mp4 $directory/$day2/ DSC_0692.NEF-1080p.jpg $1))
  
  # get length of an array
  arraylength=${#ARRAY[@]}
  
  rm $1.sh
  touch $1.sh
  echo "ffmpeg $configThreads\\" >> $1.sh


  # add the inputs
  for (( i=0; i<${arraylength} - 1; i++ ));
  do 
     echo " -i "$1/${ARRAY[$i]} "\`# [$i] $(get_videolength $1/${ARRAY[$i]})s\` \\" >> $1.sh
  done
  lastindex=$((arraylength-1))
  echo " -i "$1/${ARRAY[$lastindex]} "\`# [${lastindex}] $(get_videolength $1/${ARRAY[$lastindex]})s\` \\" >> $1.sh  
  
  # filter_complex
  # video
  # 	about offsets: https://stackoverflow.com/questions/63553906/merging-multiple-video-files-with-ffmpeg-and-xfade-filter
  echo " -filter_complex \"\\" >> $1.sh
  offset=$(($(get_videolength $1/${ARRAY[0]})-1))
  echo "  [0:v][1:v]xfade=transition=fade:duration=1:offset=$offset[vfade1];" >> $1.sh  
  for (( i=1; i<${arraylength} - 2; i++ ));
  do
     offset=$(($(get_videolength $1/${ARRAY[i]}) + $offset - 1))
     echo "  [vfade$i][$((i+1)):v]xfade=transition=fade:duration=1:offset=$offset[vfade$((i+1))];" >> $1.sh
  done
  offset=$(($(get_videolength $1/${ARRAY[lastindex - 1]}) + $offset - 1))
  # 	last one goes to "v" and has no ";"-suffix (until audio supported, cf. todo above)
  echo "  [vfade$((lastindex-1))][$((lastindex)):v]xfade=transition=fade:duration=1:offset=$offset[v]" >> $1.sh  
  # TODO audio
  
  
  echo " \"\\" >> $1.sh
  echo " -vsync vfr -acodec aac -map \"[v]\" -y $configThreads $1.mp4" >> $1.sh
}

main ffmpeg.video.creator.test

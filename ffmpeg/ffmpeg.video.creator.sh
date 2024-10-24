#!/bin/bash

#
# chmod +x ffmpeg.video.creator.sh
# ./ffmpeg.video.creator.sh
#
# Prepares images/videos and creates a "ffmpeg.video.creator.test.sh" (which finally creates the video).
#
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
day3='12_bovec_kobarid'
day4='13_kobarid_tolmin'

configThreads='-threads 2'
configQuiet='-loglevel quiet'
#configQuiet=''

dim='1920x1080'
#dim='1280x720'


# $1 directory like "/media/oliver/Data/multimedia_1080p/multimedia_bis_inkl_2020/2015/05_Alpe_Adria_Trail/10_kranjska_gora-trenta"
# $2 filename like "DSC_0533.NEF-1080p.jpg"
# $3 target-directory (locally) like "2015.05.alpe.test"
#
# file will be copy'd to target-directory and a 5 sec video will be created. Filename of video will "be returned" and added to a "list".
function to_mp4(){
   cp $1$2 $3
   filename=$3/$2
   outputfilename=$2-1080p.mp4
   # stderr https://superuser.com/questions/1320691/print-echo-and-return-value-in-bash-function
   echo "$(date) Create video: src img ($(get_image_dimension $3/$2)) -> (5s, 25fps, 1920x1080, zoom to center) from $2..." >&2
   ffmpeg $configQuiet $configThreads \
    -loop 1 -framerate 25 -t 5 -i $filename   `# [0:v]` \
    -i silentaudio.mp3                        `# [1:a]` \
    -filter_complex "\
      [0:v]scale=8000:-1,zoompan=z='zoom+0.001':s=$dim:x=iw/2-(iw/zoom/2):y=ih/2-(ih/zoom/2):d=5*25[v];\
      [1:a]atrim=0:5[a]\
     "\
     -acodec aac -vcodec libx264 -map [v] -map [a] -t 5 -n $configThreads $3/$outputfilename;
   echo $outputfilename
}

function to_25fps(){
   cp $1$2 $3
   filename=$3/$2
   outputfilename=$2-1080p.mp4
   
   # stderr https://superuser.com/questions/1320691/print-echo-and-return-value-in-bash-function
   echo "$(date) Create video: src vid ($(get_videolength_exact $3/$2)sec, $(get_framerate $3/$2)fps, $(get_dimension $3/$2)) -> ($(get_videolength $3/$2)sec, 25fps, 1920x1080) from $2 " >&2   
   # extract to an *exact* number of seconds 
   ffmpeg $configQuiet -i $filename -vf scale=$dim -r 25 -b:v 8000k -t $(get_videolength $3/$2) -n $configThreads $3/$outputfilename
   echo $outputfilename
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

function get_dimension() {
  echo $(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0:s=x $1)
}

function get_image_dimension() {
  echo $(identify -format "%[fx:w]x%[fx:h]" $1)
}

function main() {
  mkdir $1

  # short version for testing purposes, see TODO above: move this to some external file given as input to this script
  # Note: those coversions have a "low" memory usage, so 1920x1080 would not freeze my pc
  # Note: the final script has a very high memory usage, on 1920x1080 and a resulting video of length 3min (maybe more) by pc *will* freeze to *full* RAM usage
  # Dauer: Ca. 22 Minuten!
  ARRAY=()
  # DAY01
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0533.NEF-1080p.jpg $1))
  ARRAY+=($(to_25fps $directory/$day1/ 00079_10.05.2015_kranjska_gora_berge_twoSteps.mp4 $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0462.NEF-1080p.jpg $1))
  # DAY02
  ARRAY+=($(to_mp4 $directory/$day2/ DSC_0692.NEF-1080p.jpg $1))

  
  # get length of an array
  arraylength=${#ARRAY[@]}
  
  rm $1-videoonly.sh
  rm $1-audioonly.sh
  touch $1-videoonly.sh
  touch $1-audioonly.sh
  echo "#!/bin/bash" >> $1-videoonly.sh
  echo "#!/bin/bash" >> $1-audioonly.sh
  echo "" >> $1-videoonly.sh
  echo "" >> $1-audioonly.sh
  echo "start=\$(date)" >> $1-videoonly.sh
  echo "start=\$(date)" >> $1-audioonly.sh
  echo "ffmpeg -loglevel quiet $configThreads\\" >> $1-videoonly.sh
  echo "ffmpeg -loglevel quiet $configThreads\\" >> $1-audioonly.sh


  # start: inputs
  for (( i=0; i<${arraylength} - 1; i++ ));
  do 
     echo " -i "$1/${ARRAY[$i]} "\`# [$i] $(get_videolength $1/${ARRAY[$i]})s\` \\" >> $1-videoonly.sh
     echo " -i "$1/${ARRAY[$i]} "\`# [$i] $(get_videolength $1/${ARRAY[$i]})s\` \\" >> $1-audioonly.sh
  done
  lastindex=$((arraylength-1))
  echo " -i "$1/${ARRAY[$lastindex]} "\`# [${lastindex}] $(get_videolength $1/${ARRAY[$lastindex]})s\` \\" >> $1-videoonly.sh
  echo " -i "$1/${ARRAY[$lastindex]} "\`# [${lastindex}] $(get_videolength $1/${ARRAY[$lastindex]})s\` \\" >> $1-audioonly.sh
  # end :inputs




  # videoonly
  # 	about offsets: https://stackoverflow.com/questions/63553906/merging-multiple-video-files-with-ffmpeg-and-xfade-filter
  echo " -filter_complex \"\\" >> $1-videoonly.sh
  offset=$(($(get_videolength $1/${ARRAY[0]})-1))
  echo "  [0:v][1:v]xfade=transition=fade:duration=1:offset=$offset[vfade1];" >> $1-videoonly.sh
  for (( i=1; i<${arraylength} - 2; i++ ));
  do
     offset=$(($(get_videolength $1/${ARRAY[i]}) + $offset - 1))
     echo "  [vfade$i][$((i+1)):v]xfade=transition=fade:duration=1:offset=$offset[vfade$((i+1))];" >> $1-videoonly.sh
  done
  offset=$(($(get_videolength $1/${ARRAY[lastindex - 1]}) + $offset - 1))
  echo "  [vfade$((lastindex-1))][$((lastindex)):v]xfade=transition=fade:duration=1:offset=$offset[v]" >> $1-videoonly.sh
  echo " \"\\" >> $1-videoonly.sh
  # end: video
  echo " -vsync vfr -acodec aac -map \"[v]\" -y $configThreads $1-videoonly.mp4" >> $1-videoonly.sh  
  echo "end=\$(date)" >> $1-videoonly.sh  
  echo "echo \"Encoding took time from \$start to \$end\"" >> $1-videoonly.sh




  # audioonly:
  echo " -filter_complex \"\\" >> $1-audioonly.sh
  echo "  [0:a][1:a]acrossfade=duration=1[afade1];" >> $1-audioonly.sh
  for (( i=1; i<${arraylength} - 2; i++ ));
  do
     echo "  [afade$i][$((i+1)):a]acrossfade=duration=1[afade$((i+1))];" >> $1-audioonly.sh
  done
  echo "  [afade$((lastindex-1))][$((lastindex)):a]acrossfade=duration=1[a]" >> $1-audioonly.sh
  echo " \"\\" >> $1-audioonly.sh  
  echo " -vsync vfr -acodec aac -map \"[a]\" -y $configThreads $1-audioonly.aac" >> $1-audioonly.sh
  echo "end=\$(date)" >> $1-audioonly.sh
  echo "echo \"Encoding took time from \$start to \$end\"" >> $1-audioonly.sh
}


folder="ffmpeg.video.creator.test"

main $folder

echo "Please use sh $folder-audioonly.sh to create $folder-audioonly.aac"
echo "Please use sh $folder-videoonly.sh to create $folder-videoonly.mp4"
echo "Finalize with: ffmpeg -i $folder-videoonly.mp4 -i $folder-audioonly.aac -c copy -map 0:v -map 1:a $folder-full.mp4"

!!! WIP !!!

Example usage with input below:
```sh
bash ffmpeg.video.creator.sh                     # approx 20min
sh ffmpeg.video.creator.test-audioonly.sh        # approx 20sec
sh ffmpeg.video.creator.test-videoonly.sh        # approx 34min (threads = 2), max Memory 8.5 / 16GiB -> ok (starts very fast up to approx 8 GB, then very very slow (99% of encoding time)
                                                 # NOTE: Without separating audio and video (and merge manually) this totaly eats up my RAM the system freeze! this is a workaround!
```
example input:
```sh
  # Note: those coversions have a "low" memory usage, so 1920x1080 would not freeze my pc
  ARRAY=()
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0533.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0431.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0435.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0437.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0453.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0459.NEF-1080p.jpg $1))
  ARRAY+=($(to_25fps $directory/$day1/ 00079_10.05.2015_kranjska_gora_berge_twoSteps.mp4 $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0462.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0478.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0484.NEF-1080p.jpg $1))
  ARRAY+=($(to_25fps $directory/$day1/ 00085_10.05.2015_kranjska_gora-trenta_harter_wanderweg_twoSteps.mp4 $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0494.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0496.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0505.NEF-1080p.jpg $1))
  ARRAY+=($(to_25fps $directory/$day1/ 00087_10.05.2015_berge_twoSteps.mp4 $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0513.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0530.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0546.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0596.NEF-1080p.jpg $1))
  ARRAY+=($(to_25fps $directory/$day1/ 00094_10.05.2015__twoSteps.mp4 $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0624.NEF-1080p.jpg $1))
  ARRAY+=($(to_25fps $directory/$day1/ 00099_10.05.2015_socabruecke_twoSteps.mp4 $1))
  ARRAY+=($(to_mp4 $directory/$day1/ DSC_0645.NEF-1080p.jpg $1))
  # DAY02
  ARRAY+=($(to_mp4 $directory/$day2/ DSC_0692.NEF-1080p.jpg $1))
  ARRAY+=($(to_25fps $directory/$day2/ 00104_11.05.2015_socaa_twoSteps.mp4 $1))
  ARRAY+=($(to_mp4 $directory/$day2/ DSC_0701.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day2/ DSC_0712.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day2/ DSC_0729.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day2/ DSC_0745.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day2/ DSC_0762.NEF-1080p.jpg $1))
  ARRAY+=($(to_25fps $directory/$day2/ 00112_11.05.2015_blumenwiese_soca_twoSteps.mp4 $1))
  ARRAY+=($(to_mp4 $directory/$day2/ DSC_0770.NEF-1080p.jpg $1))
  ARRAY+=($(to_25fps $directory/$day2/ 00115_11.05.2015_socatal_twoSteps.mp4 $1))
  ARRAY+=($(to_mp4 $directory/$day2/ DSC_0803.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day2/ DSC_0813.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day2/ DSC_0817.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day2/ DSC_0822.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day2/ DSC_0850.NEF-1080p.jpg $1))
  ARRAY+=($(to_25fps $directory/$day2/ 00118_11.05.2015_socatal_twoSteps.mp4 $1))
  ARRAY+=($(to_mp4 $directory/$day2/ DSC_0895.NEF-1080p.jpg $1))
  ARRAY+=($(to_25fps $directory/$day2/ 00123_11.05.2015_harter_wanderweg_kanufahrer_twoSteps.mp4 $1))
  ARRAY+=($(to_mp4 $directory/$day2/ DSC_0899.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day2/ DSC_0919.NEF-1080p.jpg $1))
  # DAY03
  ARRAY+=($(to_mp4 $directory/$day3/ DSC_0923.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day3/ DSC_0944.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day3/ DSC_0948.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day3/ DSC_0953.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day3/ DSC_0955.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day3/ DSC_0960.NEF-1080p.jpg $1))
  ARRAY+=($(to_25fps $directory/$day3/ 00125_12.05.2015_sloweniens_hoechster_wasserfall_twoSteps.mp4 $1))
  ARRAY+=($(to_mp4 $directory/$day3/ DSC_0972.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day3/ DSC_0980.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day3/ DSC_0016.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day3/ DSC_0028.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day3/ DSC_0032.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day3/ DSC_0048.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day3/ DSC_0050.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day3/ DSC_0053.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day3/ DSC_0060.NEF-1080p.jpg $1))
  ARRAY+=($(to_25fps $directory/$day3/ 00127_12.05.2015_NP_wasserfall_twoSteps.mp4 $1))
  ARRAY+=($(to_mp4 $directory/$day3/ DSC_0071.NEF-1080p.jpg $1))
  ARRAY+=($(to_25fps $directory/$day3/ 00129_12.05.2015_soca_bruecke_twoSteps.mp4 $1))
  ARRAY+=($(to_mp4 $directory/$day3/ DSC_0089.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day3/ DSC_0086.NEF-1080p.jpg $1))
  # DAY04
  ARRAY+=($(to_mp4 $directory/$day4/ DSC_0099.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day4/ DSC_0107.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day4/ DSC_0143.NEF-1080p.jpg $1))
  ARRAY+=($(to_25fps $directory/$day4/ 00131_13.05.2015__twoSteps.mp4 $1))
  ARRAY+=($(to_mp4 $directory/$day4/ DSC_0153.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day4/ DSC_0160.NEF-1080p.jpg $1))
  ARRAY+=($(to_mp4 $directory/$day4/ DSC_0184.NEF-1080p.jpg $1))
  ARRAY+=($(to_25fps $directory/$day4/ 00132_13.05.2015_im_nationalpark_twoSteps.mp4 $1))
```
Log:
```sh
$ bash ffmpeg.video.creator.sh 
Do 24. Okt 06:39:45 CEST 2024 Create video: src img (1920x1080) -> (5s, 25fps, 1920x1080, zoom to center) from DSC_0533.NEF-1080p.jpg...
Do 24. Okt 06:39:45 CEST 2024 Create video: src img (1920x1080) -> (5s, 25fps, 1920x1080, zoom to center) from DSC_0431.NEF-1080p.jpg...
Do 24. Okt 06:39:45 CEST 2024 Create video: src img (1920x1080) -> (5s, 25fps, 1920x1080, zoom to center) from DSC_0435.NEF-1080p.jpg...
Do 24. Okt 06:39:45 CEST 2024 Create video: src img (1920x1080) -> (5s, 25fps, 1920x1080, zoom to center) from DSC_0437.NEF-1080p.jpg...
Do 24. Okt 06:39:45 CEST 2024 Create video: src img (1920x1080) -> (5s, 25fps, 1920x1080, zoom to center) from DSC_0453.NEF-1080p.jpg...
Do 24. Okt 06:39:45 CEST 2024 Create video: src img (1920x1080) -> (5s, 25fps, 1920x1080, zoom to center) from DSC_0459.NEF-1080p.jpg...
Do 24. Okt 06:39:45 CEST 2024 Create video: src vid (20.660000sec, 50/1fps, 1920x1080) -> (20sec, 25fps, 1920x1080) from 00079_10.05.2015_kranjska_gora_berge_twoSteps.mp4 
Do 24. Okt 06:39:45 CEST 2024 Create video: src img (1920x1080) -> (5s, 25fps, 1920x1080, zoom to center) from DSC_0462.NEF-1080p.jpg...
Do 24. Okt 06:39:46 CEST 2024 Create video: src img (1920x1080) -> (5s, 25fps, 1920x1080, zoom to center) from DSC_0478.NEF-1080p.jpg...
...
Do 24. Okt 06:57:50 CEST 2024 Create video: src vid (184.820000sec, 50/1fps, 1920x1080) -> (184sec, 25fps, 1920x1080) from 00132_13.05.2015_im_nationalpark_twoSteps.mp4 
Please use sh ffmpeg.video.creator.test-audioonly.sh to create ffmpeg.video.creator.test-audioonly.aac
Please use sh ffmpeg.video.creator.test-videoonly.sh to create ffmpeg.video.creator.test-videoonly.mp4
Finalize with: ffmpeg -i ffmpeg.video.creator.test-videoonly.mp4 -i ffmpeg.video.creator.test-audioonly.aac -c copy -map 0:v -map 1:a ffmpeg.video.creator.test-full.mp4

$ sh ffmpeg.video.creator.test-audioonly.sh
Encoding took time from Do 24. Okt 07:03:39 CEST 2024 to Do 24. Okt 07:04:00 CEST 2024

$ sh ffmpeg.video.creator.test-videoonly.sh
Encoding took time from Do 24. Okt 07:04:34 CEST 2024 to Do 24. Okt 07:37:57 CEST 202
```

import groovy.util.logging.Slf4j

// groovy ffmpeg-video-gen.groovy example-input-test1
// Note: example-input-test1 has to be a groovy-file in current directory

/*
 * TODO(!) confingurable: num threads (currently 1, very slow: 7,1 fps... without limit my cooler gets creazy...)
 * TODO(!) scale images (if they are not 16:9), see 'convert' in https://github.com/oliverbauer/multimedia - unknown if to_mp4() works with its scale for 16:9-compiant images, e.g. 5184x2920. At least i have a log of non 16:9-images...
 * TODO refactoring: improve naming of variables
 * TODO refactoring: improve comments in generated shell-script
 * TODO extend: add option/function for zooming to: center, top-left, top-right, bottom-right...
 * TODO configurable: override existing files? (-y/-n)
 */

@Grapes([
        @Grab(group = 'ch.qos.logback', module = 'logback-classic', version = '1.0.13')
])

@Slf4j
class Generator {

    // related to intermediate directory/files
    def tempFolder = "UNSET"

    def FINAL_INPUTS = []
    def FINAL_VID_LENGTH = []
    def FINAL_VID_END = []
    def SUBTITLES = []
    def COMMENTS = []

    def run(def inputDefiniton) {
        // start: reading input-files and configuration from external groovy-file
        def definition = this.class.classLoader.loadClass(inputDefiniton, true, false )?.newInstance()

        tempFolder = definition.getTempFolder()

        "mkdir $tempFolder".execute()

        def mainTitle = definition.getMainTitle()
        def outputscript = definition.getTempFolder()
        definition.init()

        def PATH = definition.PATH
        def FILE = definition.FILE
        def COMMENT = definition.COMMENT
        def TITLE = definition.TITLE
        def cleanup = definition.cleanup()
        def createResult = definition.createResult()

        for (int i = 0; i <= PATH.size - 1; i++) {
            convert(PATH.get(i), FILE.get(i), COMMENT.get(i), TITLE.get(i))
        }
	// end: reading input-files and configuration from external groovy-file

        StringBuilder videoonlyStringBuilder = new StringBuilder()
        StringBuilder audioonlyStringBuilder = new StringBuilder()

        videoonlyStringBuilder.append("#!/bin/bash").append("\n").append("\n")
        videoonlyStringBuilder.append("start=\$(date)").append("\n")
        videoonlyStringBuilder.append("ffmpeg -threads 2\\").append("\n")

        audioonlyStringBuilder.append("#!/bin/bash").append("\n").append("\n")
        audioonlyStringBuilder.append("start=\$(date)").append("\n")
        audioonlyStringBuilder.append("ffmpeg -threads 2\\").append("\n")

        // ffmpeg-inputs
        int ende = 0;
        for (int i = 0; i <= FINAL_INPUTS.size - 1; i++) {
            //log.debug "i=$i: "+FINAL_INPUTS.get(i)+" - "+FINAL_VID_LENGTH.get(i)+" - "+COMMENTS.get(i)
            if (i == 0) {
                ende = (int) (Double.valueOf(FINAL_VID_LENGTH.get(i)))
            } else {
                ende = ende + ((int) (Double.valueOf(FINAL_VID_LENGTH.get(i)) - 1))
            }

            FINAL_VID_END += ("$ende")

            // length + (last position -1)
            videoonlyStringBuilder.append("  -i " + FINAL_INPUTS.get(i) + " `# [" + i + "] " + FINAL_VID_LENGTH.get(i) + "s, ende=" + ende + ", comment=" + COMMENTS.get(i) + "` \\").append("\n")
            audioonlyStringBuilder.append("  -i " + FINAL_INPUTS.get(i) + " `# [" + i + "] " + FINAL_VID_LENGTH.get(i) + "s, ende=" + ende + ", comment=" + COMMENTS.get(i) + "` \\").append("\n")
        }
        videoonlyStringBuilder.append("  -filter_complex \"\\").append("\n")
        audioonlyStringBuilder.append("  -filter_complex \"\\").append("\n")

        for (int i = 0; i <= FINAL_INPUTS.size - 2; i++) {
            int offset = ((int) (Double.valueOf(FINAL_VID_END.get(i)) - 1))
            if (i == 0) {
                videoonlyStringBuilder.append("  [0:v][1:v]xfade=transition=fade:duration=1:offset=" + offset + "[vfade1];\\").append("\n")
                audioonlyStringBuilder.append("  [0:a][1:a]acrossfade=duration=1[afade1];\\").append("\n")
            } else if (i == (FINAL_INPUTS.size - 2)) {
                videoonlyStringBuilder.append("  [vfade" + (FINAL_INPUTS.size - 2) + "][" + (FINAL_INPUTS.size - 1) + ":v]xfade=transition=fade:duration=1:offset=" + offset + "[v2];\\").append("\n")
                audioonlyStringBuilder.append("  [afade" + (FINAL_INPUTS.size - 2) + "][" + (i + 1) + ":a]acrossfade=duration=1[a]\\").append("\n")
            } else {
                videoonlyStringBuilder.append("  [vfade" + i + "][" + (i + 1) + ":v]xfade=transition=fade:duration=1:offset=" + offset + "[vfade" + (i + 1) + "];\\").append("\n")
                audioonlyStringBuilder.append("  [afade" + i + "][" + (i + 1) + ":a]acrossfade=duration=1[afade"+(i+1)+"];\\").append("\n")
            }
        }

        // prepare drawbox/drawtext
        int fulllengt = Integer.valueOf(FINAL_VID_END.get(FINAL_VID_END.size() - 1))
        videoonlyStringBuilder.append("  [v2]\\").append("\n")
        videoonlyStringBuilder.append("  drawbox=y=ih-192:color=black@0.4:width=iw:height=192:t=fill:enable='between(t,0," + fulllengt + ")',          `# full box bottom: full lengtg` \\").append("\n")
        videoonlyStringBuilder.append("  drawtext=text='"+mainTitle+"':x=20:y=900:enable='between(t,0," + fulllengt + ")':fontsize=24:fontcolor=white, `# full box bottom: titel full length` \\").append("\n")

        // Start: Subtitles
        def SUBTITLES_USED=[]
        def SUBTITLES_START=[]
        for (int i=0; i<=SUBTITLES.size()-1; i++) {
            String comment = SUBTITLES.get(i)
            if (!comment.equals("")) {
                int offset = (int) ( Double.valueOf(FINAL_VID_END.get(i)) )
                int vidlen = (int) ( Double.valueOf(FINAL_VID_LENGTH.get(i)) )
                int start = offset - vidlen
                if (i!=0) {
                    start += 1
                }
                SUBTITLES_USED+=(comment)
                SUBTITLES_START+=(start)
            }
        }
        for (int i=0; i<=SUBTITLES_USED.size()-1; i++) {
            String subtitle = SUBTITLES_USED.get(i)
            String start = SUBTITLES_START.get(i)
            if (i == (SUBTITLES_USED.size() - 1)) {
                videoonlyStringBuilder.append("  drawtext=text='"+subtitle+"':x=20:y=930:enable='between(t,"+start+"," + fulllengt + ")':fontsize=24:fontcolor=white,  `# unterschiedlich pro tag`\\").append("\n")

            } else {
                int nextstart=(int)(SUBTITLES_START.get(i+1))-1
                videoonlyStringBuilder.append("  drawtext=text='"+subtitle+"':x=20:y=930:enable='between(t,"+start+"," + nextstart + ")':fontsize=24:fontcolor=white,  `# unterschiedlich pro tag`\\").append("\n")
            }
        }
        // End: Subtitles

        // Start: Comments
        def COMMENTS_USED=[]
        def COMMENTS_START=[]
        for (int i=0; i<=COMMENTS.size()-1; i++) {
            String comment = COMMENTS.get(i)
            if (!comment.equals("")) {
                int offset = (int) ( Double.valueOf(FINAL_VID_END.get(i)) )
                int vidlen = (int) ( Double.valueOf(FINAL_VID_LENGTH.get(i)) )
                int start = offset - vidlen
                if (i!=0) {
                    start += 1
                }
                COMMENTS_USED+=(comment)
                COMMENTS_START+=(start)
            }
        }
        for (int i=0; i<=COMMENTS_USED.size()-1; i++) {
            String comment = COMMENTS_USED.get(i)
            String start = COMMENTS_START.get(i)
            if (i == (COMMENTS_USED.size() - 1)) {
                videoonlyStringBuilder.append("  drawtext=text='" + comment + "':x=20:y=975:enable='between(t," + start + ","+ fulllengt + ")':fontsize=96:fontcolor=white `# titel " + (i + 1) + "`\\").append("\n")
            } else {
                int nextstart=(int)(COMMENTS_START.get(i+1))-1
                videoonlyStringBuilder.append("  drawtext=text='" + comment + "':x=20:y=975:enable='between(t," + start + ","+ nextstart + ")':fontsize=96:fontcolor=white, `# titel " + (i + 1) + "`\\").append("\n")
            }
        }
        // End: Comments

        videoonlyStringBuilder.append("  [v]\\").append("\n")

        videoonlyStringBuilder.append("  \"\\" ).append("\n")
        videoonlyStringBuilder.append("  -vsync vfr -acodec aac -map \"[v]\" -y -threads 2 "+outputscript+"-videoonly.mp4").append("\n")
        videoonlyStringBuilder.append("end=\$(date)").append("\n")
        videoonlyStringBuilder.append("echo \"Encoding took time from \$start to \$end\"").append("\n")

        audioonlyStringBuilder.append("  \"\\" ).append("\n")
        audioonlyStringBuilder.append("  -vsync vfr -acodec aac -map \"[a]\" -y -threads 2 "+outputscript+"-audioonly.aac").append("\n")
        audioonlyStringBuilder.append("end=\$(date)").append("\n")
        audioonlyStringBuilder.append("echo \"Encoding took time from \$start to \$end\"").append("\n")

	// Write videoonly-File
        File file = new File(outputscript+"-videoonly.sh");
        BufferedWriter writer = null;
        try {
            writer = new BufferedWriter(new FileWriter(file));
            writer.append(videoonlyStringBuilder);
        } finally {
            if (writer != null) writer.close();
        }

	// Write audioonly-file
        File file2 = new File(outputscript+"-audioonly.sh");
        BufferedWriter writer2 = null;
        try {
            writer2 = new BufferedWriter(new FileWriter(file2));
            writer2.append(audioonlyStringBuilder);
        } finally {
            if (writer2 != null) writer2.close();
        }

	// Createresult and cleanup by definition
        if (createResult) {
            execAndGet("bash "+outputscript+"-videoonly.sh")
        } else {
            log.info "To create "+outputscript+"-videoonly.mp4 use:"
            log.info "   sh "+outputscript+"-videoonly.sh"
        }

        if (createResult) {
            execAndGet("bash "+outputscript+"-audioonly.sh")
        } else {
            log.info "To create "+outputscript+"-audioonly.aac use:"
            log.info "   sh "+outputscript+"-audioonly.sh"        
        }

        if (createResult) {
            execAndGet("ffmpeg -i "+outputscript+"-videoonly.mp4 -i "+outputscript+"-audioonly.aac -c copy -map 0:v -map 1:a -y "+outputscript+"-full.mp4")
        } else {
            log.info "To merge use:"
            log.info "  ffmpeg -i "+outputscript+"-videoonly.mp4 -i "+outputscript+"-audioonly.aac -c copy -map 0:v -map 1:a -y "+outputscript+"-full.mp4"        
        }

        if (!createResult) {
            log.info "All in one:"
            log.info "   sh "+outputscript+"-videoonly.sh; sh "+outputscript+"-audioonly.sh; ffmpeg -i "+outputscript+"-videoonly.mp4 -i "+outputscript+"-audioonly.aac -c copy -map 0:v -map 1:a -y "+outputscript+"-full.mp4"
        }
        
        if (createResult && cleanup) {
            execAndGet("rm "+outputscript+"-videoonly.sh")
            execAndGet("rm "+outputscript+"-videoonly.mp4")
            execAndGet("rm "+outputscript+"-audioonly.sh")
            execAndGet("rm "+outputscript+"-audioonly.aac")
            execAndGet("rm -rf "+tempFolder)
        }
    }


    static def execAndGet(cmd) {
        def outputstream = new StringBuilder()
        def error = new StringBuilder()

        def process = cmd.execute()
        process.consumeProcessOutput(outputstream, error)
        process.waitFor()

        log.info "script-output:\n"+outputstream.toString().trim()

        outputstream.toString().trim()
    }

    def convert(inPath, inFilename, comment, subtitle) {
        if ("$inFilename".endsWithAny("jpg", "JPG")) {
            img2vid(inPath, inFilename, comment, subtitle)
        } else if ("$inFilename".endsWithAny("mp4", "MP4", "avi", "AVI")) {
            vid2vid(inPath, inFilename, comment, subtitle)
        } else {
            throw new RuntimeException("Unknown suffix for Filename "+inFilename)
        }
    }

    def img2vid(inPath, inFilename, comment, subtitle) {
        def outDirectory="$tempFolder"
        log.info "to_mp4: inFilename=$inFilename\tinPath=$inPath"
        execAndGet("bash imgToVid.sh $inPath $inFilename $outDirectory")

        log.debug "Check for availability: $outDirectory/$inFilename-1080p.mp4"
        if (!new File("$outDirectory/$inFilename-1080p.mp4").exists()) {
            log.error "Please check your params and output of: bash imgToVid.sh $inPath $inFilename $outDirectory"
            throw new RuntimeException("File does not exist: $outDirectory/$inFilename-1080p.mp4")
        }

        def length=execAndGet("ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 ${outDirectory}/${inFilename}-1080p.mp4")
        FINAL_VID_LENGTH+=("$length")
        FINAL_INPUTS+=("${outDirectory}/${inFilename}-1080p.mp4")
        COMMENTS+=("${comment}")
        SUBTITLES+=("${subtitle}")
    }

    def vid2vid(inPath, inFilename, comment, subtitle) {
        def outDirectory="$tempFolder"
        log.info "to_25fps: inFilename=$inFilename\tinPath=$inPath"
        execAndGet("bash vidToVid.sh $inPath $inFilename $outDirectory")

        log.debug "Check for availability: $outDirectory/$inFilename-1080p.mp4"
        if (!new File("$outDirectory/$inFilename-1080p.mp4").exists()) {
            log.error "Please check your params and output of: bash imgToVid.sh $inPath $inFilename $outDirectory"
            throw new RuntimeException("File does not exist: $outDirectory/$inFilename-1080p.mp4")
        }

        def length=execAndGet("ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 ${outDirectory}/${inFilename}-1080p.mp4")
        FINAL_VID_LENGTH+=("$length")
        FINAL_INPUTS+=("${outDirectory}/${inFilename}-1080p.mp4")
        COMMENTS+=("${comment}")
        SUBTITLES+=("${subtitle}")
    }
}

def runner = new Generator()
runner.run(args[0])

# Global options -- fps, crop, scale
#
# FPS: X -> 24
# CROP: W:H:X:Y | W:H  ->  640:360:50:60 | 640:360 (default XY at 0:0)
# SCALE: W:H (:flags=lanczos) -> 640:480 | -1:360 (-1 to keep aspect ratio)

# FF_SS='00:04:15' && FF_T='23' && FF_I='yn-source.mkv' && FF_SCALE='scale=-1:360:flags=lanczos' && ffmpeg -ss $FF_SS -t $FF_T -i $FF_I -vf "$FF_SCALE,palettegen=stats_mode=diff" -y palette.png && ffmpeg -ss $FF_SS -t $FF_T -i $FF_I -i palette.png -filter_complex "$FF_SCALE [x]; [x][1:v] paletteuse=dither=none" -y dest.gif && gifsicle -O3 dest.gif -o dest-o.gif

GLOBAL_FILTERS='fps=15,scale=-1:360:flags=lanczos'

I_FILE=''
O_FILE=''

generate_palette () {
PALETTE_GEN="palettegen=stats_mode=${STATS_MODE}"
GEN_FILTER="fps=${FPS},crop=600:1070:660:5,${PALETTE_GEN}"
OUTPUT_PALETTE="palette__${FPS}fps.png"
STATS_MODE="full"
}

generate_file () {

	TIME="ss${1}_t${2}"
	TIME_TRIM="-ss $1 -t $2"

	FPS="$3"
	DITHER="none"
	USE_FILTER="fps=${FPS},crop=600:1070:660:5 [x]; [x][1:v] ${4}"

	INPUT_FILE="-i ${FILE_TITLE}.mp4"
	INPUT_PALETTE="-i palette_${TIME}_${FPS}fps.png"
	OUTPUT_FILE="${FILE_TITLE}_${TIME}_600x1070_${FPS}fps_0colors_${STATS_MODE}"

	ffmpeg $TIME_TRIM $INPUT_FILE $INPUT_PALETTE -filter_complex $USE_FILTER -y $OUTPUT_FILE

}

generate_file "0" "16" "24" ""



ffmpeg $TIME_TRIM $INPUT_FILE -vf "$GEN_FILTER" -y $OUTPUT_PALETTE


ffmpeg -ss 2.2 -t 1.5 -i anim.mp4 -i palette_ss2.2_t1.5_24fps.png -filter_complex "fps=15,crop=600:1070:660:5 [x]; [x][1:v] paletteuse" -y anim_ss2.2_t1.5_600x1070_15fps_0colors_full.gif

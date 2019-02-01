# ffmpeg-mkgif

This project is an attempt to automate what I learnt when making GIFs with ffmpeg. `generate.sh` should automate this process, but it's probably broken. Below is an explanation of how to do it manually and what the commands do.

1. Generate a palette: `ffmpeg -i input.webm -vf "fps=24,scale=640:-1:flags=lanczos,palettegen=stats_mode=full" -y palette.png`
2. Use the palette: `ffmpeg -i input.webm -i palette.png -filter_complex "fps=24,scale=640:-1:flags=lanczos [x]; [x][1:v] paletteuse" -y output.gif`

* `-vf` stands for "video filter" and creates a simple filtergraph. A simple filtergraph is simply one that has exactly 1 input and 1 output, both of the same type.
* `-filter_complex` creates a complex filtergraph. A complex filtergraph is one that doesn't use a linear processing chain applied to one stream. This can be the case, for example, when the graph has more than one input and/or output, or when output stream type is different from the input.

In the first step, the filtergraph (`-vf`) is divided up into 3 sections. `fps=24` will limit the framerate. `scale=640:-1:flags=lanczos` will scale to 640 width, keep the aspect ratio, and use a flag to specify which scaler to use. In this case we use either the `lanczos` or `bicubic` scaler since they are superiour to the default `bilinear` scaler. `palettegen` will take the output of all of this and create a palette for the entire video by using the `stats_mode`. This `stats_mode` can either be `full` (default), to compute full frame histograms (good when everything is moving), or `diff` to only compute histograms for the part that differs from the previous frame. `diff` will in this sense give more importance to moving parts of your input if the background is static.

In the second step, the filtergraph (`-filter_complex`) uses two input streams to create an output stream.

# VIDEO_downscaler_2x2

The block takes video axi-stream on its input applies median (2x2) filter and produces resized image in the form of AXI-stream. For example a 640x480 video frames would be resized to 320x240.
The core only works with active pixels of the image.

If the core will receive the following frame on its input:

![Axi-stream-pixels](https://github.com/etherblade-net/VIDEO_downscaler_2x2/assets/53142676/7854687e-0724-4420-94da-0ee1154e23c8)

It will produce following video frame on:

![pixel_from_fifos](https://github.com/etherblade-net/VIDEO_downscaler_2x2/assets/53142676/00112b6f-e562-4ce0-82cb-128bacc8e3c0)

This is microarchitectural diagram of the design:

![downscaler_pipeline](https://github.com/etherblade-net/VIDEO_downscaler_2x2/assets/53142676/8e5f80ca-8682-4d2f-815c-d3cb8455b7af)

“Stream lock” glue logic (GL1) contains FSM that will be waiting for arrival of a pixel marked with “Start_of_frame” (tuser) bit and lock the stream by permitting “valid” to propagate downstream. It will remain in “locked state” forever (until global reset).
   
“Stream fork” will replicate stream into four streams.

“Write to queues” contain glue logic clouds before FIFOs that selectively allow write pixels into corresponding FIFO.
Each glue logic blocks (GL3, GL4, GL5, GL6) contain two 1-bit counters: “pixel_counter” and “line_counter”. 
“pixel_counter” will toggle upon processing of every pixel in the line.
“line_counter” will be toggled by processing of every last pixel in the line (pixel marked with tlast).

This is how incoming stream of pixels will be distributed among 4 FIFOs:

![pixel_to_fifos](https://github.com/etherblade-net/VIDEO_downscaler_2x2/assets/53142676/43f737a3-8d6c-481a-90cf-caa5d3514b66)

“Pixel produce” will be producing final downscaled pixel taking 4 pixels from 4 FIFOs.

In the place of GS7 we can place any kernel matrix. For sake of simplicity we will have a median value of 4 pixels to be calculated.

Also in GS7 all (tuser) “start of the frame” wires will be ORed, and all (tlast) “end of line” wires will be ORed too.

"Skid buffer" is needed to register upstream-ready signal. See Clifford Cummings article “Coding And Scripting Techniques For FSM Designs With Synthesis-Optimized, Glitch-Free Outputs” explaining why we register all core outputs.

This is simulation timing diagram:

![waveform_diagram](https://github.com/etherblade-net/VIDEO_downscaler_2x2/assets/53142676/fd2d5c87-8b9e-497f-b1fa-47b7cba47409)

DESIGN SIMULATION / VERIFICATION
The RTL code is complemented with Transaction level model.
The testbech compares outputs from the model and RTL.






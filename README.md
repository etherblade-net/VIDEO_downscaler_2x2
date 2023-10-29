# VIDEO_downscaler_2x2

The block takes video axi-stream on its input applies median (2x2) filter and produces resized image in the form of AXI-stream. For example a 640x480 video frames would be resized to 320x240.
The core only works with active pixels of the image.

If the core will receive the following frame on its input:

![Axi-stream-pixels](https://github.com/etherblade-net/VIDEO_downscaler_2x2/assets/53142676/7854687e-0724-4420-94da-0ee1154e23c8)

It will produce following video frame on:

![pixel_from_fifos](https://github.com/etherblade-net/VIDEO_downscaler_2x2/assets/53142676/00112b6f-e562-4ce0-82cb-128bacc8e3c0)

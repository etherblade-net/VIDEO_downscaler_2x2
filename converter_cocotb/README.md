In order to run CocoTB picture converter please install: Python, Cocotb, IcarusVerilog, NumPy, Pillow.
Requirements for the source picture:
X dimention and Y dimention shall be even numbers.
X dimention shall not exceed 500 pixels. Because FIFO1 and FIFO2 are instantiated as 256 (and FIFO1 and FIFO2 can accept half of a pixel line).
Picture shall be 8bit grayscale.

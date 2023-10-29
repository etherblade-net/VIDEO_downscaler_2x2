module gl4_queue_b #(parameter D_WIDTH = 8)
(
input                   clk,
input                   rst,
input  [(D_WIDTH-1):0]  up_data,
input                   up_valid,
input                   up_tlast,
input                   up_tuser,
output                  up_ready,
output [(D_WIDTH-1):0]  down_data,
output                  down_valid,
output                  down_tlast,
output                  down_tuser,
input                   down_ready
);


reg pixel_counter;
reg line_counter;

wire en_pixel_counter;
wire en_line_counter;

//Pixel-counter
always @(posedge clk)
  if (rst) begin
    pixel_counter <= 1'b0;
    end else if (en_pixel_counter) begin
    pixel_counter <= pixel_counter + 1;
  end

//Line-counter
always @(posedge clk)
  if (rst) begin
    line_counter <= 1'b0;
    end else if (en_line_counter) begin
    line_counter <= line_counter + 1;
  end

assign down_data = up_data;
assign down_valid = up_valid & pixel_counter & ~line_counter;
assign down_tlast = up_tlast;
assign down_tuser = up_tuser;
assign up_ready = down_ready;
assign en_pixel_counter = up_valid & down_ready;
assign en_line_counter = up_valid & up_tlast & down_ready;

endmodule

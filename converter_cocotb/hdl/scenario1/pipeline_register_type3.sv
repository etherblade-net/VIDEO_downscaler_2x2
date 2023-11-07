//Pipeline register where pipeline keeps driving even without downstream ready. So valid doesnt depend on ready as per AXI standard.
module pipeline_register_type3 #(parameter D_WIDTH = 8)
(
  input                        clk,
  input                        rst,
  input                        up_valid,
  output                       up_ready,
  input        [(D_WIDTH-1):0] up_data,
  input                        up_tlast,
  input                        up_tuser,
  output reg                   down_valid,
  input                        down_ready,
  output reg   [(D_WIDTH-1):0] down_data,
  output reg                   down_tlast,
  output reg                   down_tuser
);

  always @(posedge clk)
    if (up_ready)
      begin
      down_data <= up_data;
      down_tlast <= up_tlast;
      down_tuser <= up_tuser;
      end

  always @(posedge clk)
    if (rst)
      down_valid <= 1'b0;
    else if (up_ready)
      down_valid <= up_valid;

  assign up_ready = ~ down_valid | down_ready;

endmodule

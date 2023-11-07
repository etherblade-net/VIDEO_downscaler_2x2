module tb
# (
  parameter D_WIDTH = 8
);

  //--------------------------------------------------------------------------
  // Signals to drive Device Under Test - DUT

  logic clk;
  logic rst;

  // Upstream
  logic                 up_valid;
  wire                  up_ready;
  logic [(D_WIDTH-1):0] up_data;
  logic                 up_tlast;
  logic                 up_tuser;

  // Downstream
  wire                  down_valid;
  logic                 down_ready;
  wire  [(D_WIDTH-1):0] down_data;
  wire                  down_tlast;
  wire                  down_tuser;

  //--------------------------------------------------------------------------
  // DUT instantiation
bfm_model # (.D_WIDTH (D_WIDTH))
BFM1
(       .clk(clk),
        .rst(rst),
        .up_data(up_data),
        .up_valid(up_valid),
        .up_tlast(up_tlast),
        .up_tuser(up_tuser),
        .up_ready(up_ready),
        .down_data(down_data),
        .down_valid(down_valid),
        .down_tlast(down_tlast),
        .down_tuser(down_tuser),
        .down_ready(down_ready));

  //--------------------------------------------------------------------------
  // Driving clock

  initial
  begin
    forever #5 clk = ~ clk;
  end

  //--------------------------------------------------------------------------
  //Initialization and driving simulation
  initial
  begin
    clk = 0;
    forever @ (posedge clk);
  end

endmodule

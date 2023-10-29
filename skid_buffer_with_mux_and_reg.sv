//This is implementation of a Skid Buffer with mux and register that is described on:
//https://chipmunklogic.com/digital-logic-design/designing-skid-buffers-for-pipelines/

//QUOTE FROM "CHIPMUNKLOGIC.COM":
//Skid Buffer is a specially designed buffer with a mux and register.
//The mux simply forwards (bypasses) input data to output as long as Receiver is ready.
//If Receiver is not ready, and Sender sends valid data, Skid Buffer allows the data to "skid"
//and come to stop by storing it in a buffer. In this way, stalling ("stopping") need not happen immediately,
//but only in the next clock cycle. The mux is switched to forward data in the buffer. When Receiver is ready,
//data in the buffer is sampled by Receiver. The mux is switched again and the input data is forwarded to Receiver
//in subsequent cycles. This allows the registering of ready signal from Receiver as we can now manage that extra
//data from Sender by buffering it inside if necessary.
//END QUOTE.

//This implementation of the skid-buffer has external "up_ready" signal registered (i.e. without combinational logic).
//This is because "up_ready" signal is coming directly from a bit of FSM state register as described in
//"Coding And Scripting Techniques For FSM Designs With Synthesis-Optimized, Glitch-Free Outputs"
//by Clifford E. Cummings article.

module skid_buffer_with_mux_and_reg #(parameter D_WIDTH = 8)
(
input clk,
input rst,
input [(D_WIDTH-1):0] up_data,
input up_valid,
input up_tlast,
input up_tuser,
output up_ready,
output [(D_WIDTH-1):0] down_data,
output down_valid,
output down_tlast,
output down_tuser,
input down_ready
);

reg   [D_WIDTH - 1:0]        data_reg;
reg                          valid_reg;
reg                          tlast_reg;
reg                          tuser_reg;
wire we;
wire sel;

//DATAPATH
  always @(posedge clk)
    if (we)
      begin
        data_reg <= up_data;
        tlast_reg <= up_tlast;
        tuser_reg <= up_tuser;
      end

  always @(posedge clk)
    if (rst)
      valid_reg <= 1'b0;
    else if (we)
      valid_reg <= up_valid;

assign down_data = (sel) ? data_reg : up_data;
assign down_valid = (sel) ? valid_reg : up_valid;
assign down_tlast = (sel) ? tlast_reg : up_tlast;
assign down_tuser = (sel) ? tuser_reg : up_tuser;

//FSM BASED CONTROL
  parameter BYPASS = 2'b01,
            SKID = 2'b10;

  reg [1:0] state, next;

  always @(posedge clk)
    if (rst) state <= BYPASS;
    else state <= next;

  always @(state or up_valid or down_ready) begin
    next = 'bx;
    case (state)
      BYPASS : if (up_valid & ~down_ready) next = SKID;
               else next = BYPASS;
      SKID   : if (down_ready) next = BYPASS;
               else next = SKID;
    endcase
  end

assign we = ((state == BYPASS) & (up_valid) & (~down_ready));
assign {sel,up_ready} = state[1:0];

endmodule

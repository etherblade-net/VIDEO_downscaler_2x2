module gl1_stream_lock #(parameter D_WIDTH = 8)
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

//BEGIN CUSTOM LOGIC BLOCK
wire enable;


//CONTROL (FSM and GENERATION OF CONTROL SIGNALS)
  parameter WAIT_FOR_SOF = 1'b0,
            SOF_LOCKED   = 1'b1;

  reg [1:0] state, next;

  always @(posedge clk)
    if (rst) state <= WAIT_FOR_SOF;
    else state <= next;

  always @(state or up_valid or up_tuser) begin
    next = 'bx;
    case (state)
      WAIT_FOR_SOF      :   if ((up_valid) & (up_tuser)) next = SOF_LOCKED;
                            else next = WAIT_FOR_SOF;
      SOF_LOCKED        :   next = SOF_LOCKED;
    endcase
  end

assign enable = ((state == WAIT_FOR_SOF) & up_valid & up_tuser) || (state == SOF_LOCKED);


assign down_data = up_data;
assign down_valid = up_valid & enable;
assign down_tlast = up_tlast;
assign down_tuser = up_tuser;
assign up_ready = down_ready;

//END CUSTOM LOGIC BLOCK

endmodule

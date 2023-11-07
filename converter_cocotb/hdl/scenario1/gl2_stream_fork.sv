module gl2_stream_fork #(parameter D_WIDTH = 8)
(
input                   clk,
input                   rst,
input  [(D_WIDTH-1):0]  up_data,
input                   up_valid,
input                   up_tlast,
input                   up_tuser,
output                  up_ready,
output [(D_WIDTH-1):0]  down_data_a,
output                  down_valid_a,
output                  down_tlast_a,
output                  down_tuser_a,
input                   down_ready_a,
output [(D_WIDTH-1):0]  down_data_b,
output                  down_valid_b,
output                  down_tlast_b,
output                  down_tuser_b,
input                   down_ready_b,
output [(D_WIDTH-1):0]  down_data_c,
output                  down_valid_c,
output                  down_tlast_c,
output                  down_tuser_c,
input                   down_ready_c,
output [(D_WIDTH-1):0]  down_data_d,
output                  down_valid_d,
output                  down_tlast_d,
output                  down_tuser_d,
input                   down_ready_d
);


//BEGIN CUSTOM LOGIC BLOCK

assign down_data_a = up_data;
assign down_tlast_a = up_tlast;
assign down_tuser_a = up_tuser;
assign down_data_b = up_data;
assign down_tlast_b = up_tlast;
assign down_tuser_b = up_tuser;
assign down_data_c = up_data;
assign down_tlast_c = up_tlast;
assign down_tuser_c = up_tuser;
assign down_data_d = up_data;
assign down_tlast_d = up_tlast;
assign down_tuser_d = up_tuser;
assign down_valid_a = up_valid & down_ready_a & down_ready_b & down_ready_c & down_ready_d;
assign down_valid_b = up_valid & down_ready_a & down_ready_b & down_ready_c & down_ready_d;
assign down_valid_c = up_valid & down_ready_a & down_ready_b & down_ready_c & down_ready_d;
assign down_valid_d = up_valid & down_ready_a & down_ready_b & down_ready_c & down_ready_d;

assign up_ready = down_ready_a & down_ready_b & down_ready_c & down_ready_d;

//END CUSTOM LOGIC BLOCK

endmodule

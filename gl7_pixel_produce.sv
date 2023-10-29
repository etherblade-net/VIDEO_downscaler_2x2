module gl7_pixel_produce #(parameter D_WIDTH = 8)
(
input                   clk,
input                   rst,
input  [(D_WIDTH-1):0]  up_data_a,
input                   up_valid_a,
input                   up_tlast_a,
input                   up_tuser_a,
output                  up_ready_a,
input  [(D_WIDTH-1):0]  up_data_b,
input                   up_valid_b,
input                   up_tlast_b,
input                   up_tuser_b,
output                  up_ready_b,
input  [(D_WIDTH-1):0]  up_data_c,
input                   up_valid_c,
input                   up_tlast_c,
input                   up_tuser_c,
output                  up_ready_c,
input  [(D_WIDTH-1):0]  up_data_d,
input                   up_valid_d,
input                   up_tlast_d,
input                   up_tuser_d,
output                  up_ready_d,
output [(D_WIDTH-1):0]  down_data,
output                  down_valid,
output                  down_tlast,
output                  down_tuser,
input                   down_ready
);

wire [(D_WIDTH+1):0] ext_sum_data;

//BEGIN CUSTOM LOGIC BLOCK

assign ext_sum_data = up_data_a + up_data_b + up_data_c + up_data_d;    //Add all 4 pixel luma values
assign down_data = ext_sum_data[(D_WIDTH+1):2];                         //divide combined luma values of 4 pixels by 4 by shifting right by 2
assign down_valid = up_valid_a & up_valid_b & up_valid_c & up_valid_d;
assign down_tlast = up_tlast_a | up_tlast_b | up_tlast_c | up_tlast_d;
assign down_tuser = up_tuser_a | up_tuser_b | up_tuser_c | up_tuser_d;
assign up_ready_a = down_ready & down_valid;
assign up_ready_b = down_ready & down_valid;
assign up_ready_c = down_ready & down_valid;
assign up_ready_d = down_ready & down_valid;

//END CUSTOM LOGIC BLOCK

endmodule

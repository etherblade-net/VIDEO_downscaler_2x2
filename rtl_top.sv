//---TOP MODULE FOR RTL DESIGN---//

module rtl_top #(parameter D_WIDTH = 8, parameter FIFO1_A_WIDTH = 2, parameter FIFO2_A_WIDTH = 1)
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

//SB1
//                    up_ready
wire  [(D_WIDTH-1):0] w_sb1_down_data;
wire                  w_sb1_down_valid;
wire                  w_sb1_down_tlast;
wire                  w_sb1_down_tuser;

//GL1
wire                  w_gl1_up_ready;
wire  [(D_WIDTH-1):0] w_gl1_down_data;
wire                  w_gl1_down_valid;
wire                  w_gl1_down_tlast;
wire                  w_gl1_down_tuser;

//RG1
wire                  w_rg1_up_ready;
wire  [(D_WIDTH-1):0] w_rg1_down_data;
wire                  w_rg1_down_valid;
wire                  w_rg1_down_tlast;
wire                  w_rg1_down_tuser;

//GL2
wire                  w_gl2_up_ready;
wire  [(D_WIDTH-1):0] w_gl2_down_data_a;
wire                  w_gl2_down_valid_a;
wire                  w_gl2_down_tlast_a;
wire                  w_gl2_down_tuser_a;
wire  [(D_WIDTH-1):0] w_gl2_down_data_b;
wire                  w_gl2_down_valid_b;
wire                  w_gl2_down_tlast_b;
wire                  w_gl2_down_tuser_b;
wire  [(D_WIDTH-1):0] w_gl2_down_data_c;
wire                  w_gl2_down_valid_c;
wire                  w_gl2_down_tlast_c;
wire                  w_gl2_down_tuser_c;
wire  [(D_WIDTH-1):0] w_gl2_down_data_d;
wire                  w_gl2_down_valid_d;
wire                  w_gl2_down_tlast_d;
wire                  w_gl2_down_tuser_d;

//RG3
wire                  w_rg3_up_ready;
wire  [(D_WIDTH-1):0] w_rg3_down_data;
wire                  w_rg3_down_valid;
wire                  w_rg3_down_tlast;
wire                  w_rg3_down_tuser;

//GL3
wire                  w_gl3_up_ready;
wire  [(D_WIDTH-1):0] w_gl3_down_data;
wire                  w_gl3_down_valid;
wire                  w_gl3_down_tlast;
wire                  w_gl3_down_tuser;

//FIFO_A
wire                  w_fifo_a_up_ready;
wire  [(D_WIDTH-1):0] w_fifo_a_down_data;
wire                  w_fifo_a_down_valid;
wire                  w_fifo_a_down_tlast;
wire                  w_fifo_a_down_tuser;

//RG4
wire                  w_rg4_up_ready;
wire  [(D_WIDTH-1):0] w_rg4_down_data;
wire                  w_rg4_down_valid;
wire                  w_rg4_down_tlast;
wire                  w_rg4_down_tuser;

//GL4
wire                  w_gl4_up_ready;
wire  [(D_WIDTH-1):0] w_gl4_down_data;
wire                  w_gl4_down_valid;
wire                  w_gl4_down_tlast;
wire                  w_gl4_down_tuser;

//FIFO_B
wire                  w_fifo_b_up_ready;
wire  [(D_WIDTH-1):0] w_fifo_b_down_data;
wire                  w_fifo_b_down_valid;
wire                  w_fifo_b_down_tlast;
wire                  w_fifo_b_down_tuser;

//RG5
wire                  w_rg5_up_ready;
wire  [(D_WIDTH-1):0] w_rg5_down_data;
wire                  w_rg5_down_valid;
wire                  w_rg5_down_tlast;
wire                  w_rg5_down_tuser;

//GL5
wire                  w_gl5_up_ready;
wire  [(D_WIDTH-1):0] w_gl5_down_data;
wire                  w_gl5_down_valid;
wire                  w_gl5_down_tlast;
wire                  w_gl5_down_tuser;

//FIFO_C
wire                  w_fifo_c_up_ready;
wire  [(D_WIDTH-1):0] w_fifo_c_down_data;
wire                  w_fifo_c_down_valid;
wire                  w_fifo_c_down_tlast;
wire                  w_fifo_c_down_tuser;

//RG6
wire                  w_rg6_up_ready;
wire  [(D_WIDTH-1):0] w_rg6_down_data;
wire                  w_rg6_down_valid;
wire                  w_rg6_down_tlast;
wire                  w_rg6_down_tuser;

//GL6
wire                  w_gl6_up_ready;
wire  [(D_WIDTH-1):0] w_gl6_down_data;
wire                  w_gl6_down_valid;
wire                  w_gl6_down_tlast;
wire                  w_gl6_down_tuser;

//FIFO_D
wire                  w_fifo_d_up_ready;
wire  [(D_WIDTH-1):0] w_fifo_d_down_data;
wire                  w_fifo_d_down_valid;
wire                  w_fifo_d_down_tlast;
wire                  w_fifo_d_down_tuser;

//GL7
wire                  w_gl7_up_ready_a;
wire                  w_gl7_up_ready_b;
wire                  w_gl7_up_ready_c;
wire                  w_gl7_up_ready_d;
wire  [(D_WIDTH-1):0] w_gl7_down_data;
wire                  w_gl7_down_valid;
wire                  w_gl7_down_tlast;
wire                  w_gl7_down_tuser;

//RG7
wire                  w_rg7_up_ready;
//                    down_data;
//                    down_valid;
//                    down_tlast;
//                    down_tuser;


skid_buffer_with_mux_and_reg # (.D_WIDTH (D_WIDTH))
SB1
(       .clk(clk),
        .rst(rst),
        .up_data(up_data),
        .up_valid(up_valid),
        .up_tlast(up_tlast),
        .up_tuser(up_tuser),
        .up_ready(up_ready),
        .down_data(w_sb1_down_data),
        .down_valid(w_sb1_down_valid),
        .down_tlast(w_sb1_down_tlast),
        .down_tuser(w_sb1_down_tuser),
        .down_ready(w_gl1_up_ready));


gl1_stream_lock # (.D_WIDTH (D_WIDTH))
GL1
(       .clk(clk),
        .rst(rst),
        .up_data(w_sb1_down_data),
        .up_valid(w_sb1_down_valid),
        .up_tlast(w_sb1_down_tlast),
        .up_tuser(w_sb1_down_tuser),
        .up_ready(w_gl1_up_ready),
        .down_data(w_gl1_down_data),
        .down_valid(w_gl1_down_valid),
        .down_tlast(w_gl1_down_tlast),
        .down_tuser(w_gl1_down_tuser),
        .down_ready(w_rg1_up_ready));


pipeline_register_type3 # (.D_WIDTH (D_WIDTH))
RG1
(       .clk(clk),
        .rst(rst),
        .up_data(w_gl1_down_data),
        .up_valid(w_gl1_down_valid),
        .up_tlast(w_gl1_down_tlast),
        .up_tuser(w_gl1_down_tuser),
        .up_ready(w_rg1_up_ready),
        .down_data(w_rg1_down_data),
        .down_valid(w_rg1_down_valid),
        .down_tlast(w_rg1_down_tlast),
        .down_tuser(w_rg1_down_tuser),
        .down_ready(w_gl2_up_ready));

gl2_stream_fork # (.D_WIDTH (D_WIDTH))
GL2
(       .clk(clk),
        .rst(rst),
        .up_data(w_rg1_down_data),
        .up_valid(w_rg1_down_valid),
        .up_tlast(w_rg1_down_tlast),
        .up_tuser(w_rg1_down_tuser),
        .up_ready(w_gl2_up_ready),
        .down_data_a(w_gl2_down_data_a),
        .down_valid_a(w_gl2_down_valid_a),
        .down_tlast_a(w_gl2_down_tlast_a),
        .down_tuser_a(w_gl2_down_tuser_a),
        .down_ready_a(w_rg3_up_ready),
        .down_data_b(w_gl2_down_data_b),
        .down_valid_b(w_gl2_down_valid_b),
        .down_tlast_b(w_gl2_down_tlast_b),
        .down_tuser_b(w_gl2_down_tuser_b),
        .down_ready_b(w_rg4_up_ready),
        .down_data_c(w_gl2_down_data_c),
        .down_valid_c(w_gl2_down_valid_c),
        .down_tlast_c(w_gl2_down_tlast_c),
        .down_tuser_c(w_gl2_down_tuser_c),
        .down_ready_c(w_rg5_up_ready),
        .down_data_d(w_gl2_down_data_d),
        .down_valid_d(w_gl2_down_valid_d),
        .down_tlast_d(w_gl2_down_tlast_d),
        .down_tuser_d(w_gl2_down_tuser_d),
        .down_ready_d(w_rg6_up_ready));


pipeline_register_type3 # (.D_WIDTH (D_WIDTH))
RG3
(       .clk(clk),
        .rst(rst),
        .up_data(w_gl2_down_data_a),
        .up_valid(w_gl2_down_valid_a),
        .up_tlast(w_gl2_down_tlast_a),
        .up_tuser(w_gl2_down_tuser_a),
        .up_ready(w_rg3_up_ready),
        .down_data(w_rg3_down_data),
        .down_valid(w_rg3_down_valid),
        .down_tlast(w_rg3_down_tlast),
        .down_tuser(w_rg3_down_tuser),
        .down_ready(w_gl3_up_ready));

gl3456_queue # (.D_WIDTH (D_WIDTH), .ACTIVEPIXCNTR (1'b0), .ACTIVELINECNTR (1'b0))
GL3
(       .clk(clk),
        .rst(rst),
        .up_data(w_rg3_down_data),
        .up_valid(w_rg3_down_valid),
        .up_tlast(w_rg3_down_tlast),
        .up_tuser(w_rg3_down_tuser),
        .up_ready(w_gl3_up_ready),
        .down_data(w_gl3_down_data),
        .down_valid(w_gl3_down_valid),
        .down_tlast(w_gl3_down_tlast),
        .down_tuser(w_gl3_down_tuser),
        .down_ready(w_fifo_a_up_ready));


ff_fifo_pow2_depth # (.D_WIDTH (D_WIDTH), .A_WIDTH (FIFO1_A_WIDTH))
FIFO_A
(       .clk(clk),
        .rst(rst),
        .up_data(w_gl3_down_data),
        .up_valid(w_gl3_down_valid),
        .up_tlast(w_gl3_down_tlast),
        .up_tuser(w_gl3_down_tuser),
        .up_ready(w_fifo_a_up_ready),
        .down_data(w_fifo_a_down_data),
        .down_valid(w_fifo_a_down_valid),
        .down_tlast(w_fifo_a_down_tlast),
        .down_tuser(w_fifo_a_down_tuser),
        .down_ready(w_gl7_up_ready_a));

pipeline_register_type3 # (.D_WIDTH (D_WIDTH))
RG4
(       .clk(clk),
        .rst(rst),
        .up_data(w_gl2_down_data_b),
        .up_valid(w_gl2_down_valid_b),
        .up_tlast(w_gl2_down_tlast_b),
        .up_tuser(w_gl2_down_tuser_b),
        .up_ready(w_rg4_up_ready),
        .down_data(w_rg4_down_data),
        .down_valid(w_rg4_down_valid),
        .down_tlast(w_rg4_down_tlast),
        .down_tuser(w_rg4_down_tuser),
        .down_ready(w_gl4_up_ready));


gl3456_queue # (.D_WIDTH (D_WIDTH), .ACTIVEPIXCNTR (1'b1), .ACTIVELINECNTR (1'b0))
GL4
(       .clk(clk),
        .rst(rst),
        .up_data(w_rg4_down_data),
        .up_valid(w_rg4_down_valid),
        .up_tlast(w_rg4_down_tlast),
        .up_tuser(w_rg4_down_tuser),
        .up_ready(w_gl4_up_ready),
        .down_data(w_gl4_down_data),
        .down_valid(w_gl4_down_valid),
        .down_tlast(w_gl4_down_tlast),
        .down_tuser(w_gl4_down_tuser),
        .down_ready(w_fifo_b_up_ready));

ff_fifo_pow2_depth # (.D_WIDTH (D_WIDTH), .A_WIDTH (FIFO1_A_WIDTH))
FIFO_B
(       .clk(clk),
        .rst(rst),
        .up_data(w_gl4_down_data),
        .up_valid(w_gl4_down_valid),
        .up_tlast(w_gl4_down_tlast),
        .up_tuser(w_gl4_down_tuser),
        .up_ready(w_fifo_b_up_ready),
        .down_data(w_fifo_b_down_data),
        .down_valid(w_fifo_b_down_valid),
        .down_tlast(w_fifo_b_down_tlast),
        .down_tuser(w_fifo_b_down_tuser),
        .down_ready(w_gl7_up_ready_b));

//RG5
pipeline_register_type3 # (.D_WIDTH (D_WIDTH))
RG5
(       .clk(clk),
        .rst(rst),
        .up_data(w_gl2_down_data_c),
        .up_valid(w_gl2_down_valid_c),
        .up_tlast(w_gl2_down_tlast_c),
        .up_tuser(w_gl2_down_tuser_c),
        .up_ready(w_rg5_up_ready),
        .down_data(w_rg5_down_data),
        .down_valid(w_rg5_down_valid),
        .down_tlast(w_rg5_down_tlast),
        .down_tuser(w_rg5_down_tuser),
        .down_ready(w_gl5_up_ready));

//GL5
gl3456_queue # (.D_WIDTH (D_WIDTH), .ACTIVEPIXCNTR (1'b0), .ACTIVELINECNTR (1'b1))
GL5
(       .clk(clk),
        .rst(rst),
        .up_data(w_rg5_down_data),
        .up_valid(w_rg5_down_valid),
        .up_tlast(w_rg5_down_tlast),
        .up_tuser(w_rg5_down_tuser),
        .up_ready(w_gl5_up_ready),
        .down_data(w_gl5_down_data),
        .down_valid(w_gl5_down_valid),
        .down_tlast(w_gl5_down_tlast),
        .down_tuser(w_gl5_down_tuser),
        .down_ready(w_fifo_c_up_ready));

//FIFO_C
ff_fifo_pow2_depth # (.D_WIDTH (D_WIDTH), .A_WIDTH (FIFO2_A_WIDTH))
FIFO_C
(       .clk(clk),
        .rst(rst),
        .up_data(w_gl5_down_data),
        .up_valid(w_gl5_down_valid),
        .up_tlast(w_gl5_down_tlast),
        .up_tuser(w_gl5_down_tuser),
        .up_ready(w_fifo_c_up_ready),
        .down_data(w_fifo_c_down_data),
        .down_valid(w_fifo_c_down_valid),
        .down_tlast(w_fifo_c_down_tlast),
        .down_tuser(w_fifo_c_down_tuser),
        .down_ready(w_gl7_up_ready_c));

//RG6
pipeline_register_type3 # (.D_WIDTH (D_WIDTH))
RG6
(       .clk(clk),
        .rst(rst),
        .up_data(w_gl2_down_data_d),
        .up_valid(w_gl2_down_valid_d),
        .up_tlast(w_gl2_down_tlast_d),
        .up_tuser(w_gl2_down_tuser_d),
        .up_ready(w_rg6_up_ready),
        .down_data(w_rg6_down_data),
        .down_valid(w_rg6_down_valid),
        .down_tlast(w_rg6_down_tlast),
        .down_tuser(w_rg6_down_tuser),
        .down_ready(w_gl6_up_ready));

//GL6
gl3456_queue # (.D_WIDTH (D_WIDTH), .ACTIVEPIXCNTR (1'b1), .ACTIVELINECNTR (1'b1))
GL6
(       .clk(clk),
        .rst(rst),
        .up_data(w_rg6_down_data),
        .up_valid(w_rg6_down_valid),
        .up_tlast(w_rg6_down_tlast),
        .up_tuser(w_rg6_down_tuser),
        .up_ready(w_gl6_up_ready),
        .down_data(w_gl6_down_data),
        .down_valid(w_gl6_down_valid),
        .down_tlast(w_gl6_down_tlast),
        .down_tuser(w_gl6_down_tuser),
        .down_ready(w_fifo_d_up_ready));

//FIFO_D
ff_fifo_pow2_depth # (.D_WIDTH (D_WIDTH), .A_WIDTH (FIFO2_A_WIDTH))
FIFO_D
(       .clk(clk),
        .rst(rst),
        .up_data(w_gl6_down_data),
        .up_valid(w_gl6_down_valid),
        .up_tlast(w_gl6_down_tlast),
        .up_tuser(w_gl6_down_tuser),
        .up_ready(w_fifo_d_up_ready),
        .down_data(w_fifo_d_down_data),
        .down_valid(w_fifo_d_down_valid),
        .down_tlast(w_fifo_d_down_tlast),
        .down_tuser(w_fifo_d_down_tuser),
        .down_ready(w_gl7_up_ready_d));

gl7_pixel_produce # (.D_WIDTH (D_WIDTH))
GL7
(       .clk(clk),
        .rst(rst),
        .up_data_a(w_fifo_a_down_data),
        .up_valid_a(w_fifo_a_down_valid),
        .up_tlast_a(w_fifo_a_down_tlast),
        .up_tuser_a(w_fifo_a_down_tuser),
        .up_ready_a(w_gl7_up_ready_a),
        .up_data_b(w_fifo_b_down_data),
        .up_valid_b(w_fifo_b_down_valid),
        .up_tlast_b(w_fifo_b_down_tlast),
        .up_tuser_b(w_fifo_b_down_tuser),
        .up_ready_b(w_gl7_up_ready_b),
        .up_data_c(w_fifo_c_down_data),
        .up_valid_c(w_fifo_c_down_valid),
        .up_tlast_c(w_fifo_c_down_tlast),
        .up_tuser_c(w_fifo_c_down_tuser),
        .up_ready_c(w_gl7_up_ready_c),
        .up_data_d(w_fifo_d_down_data),
        .up_valid_d(w_fifo_d_down_valid),
        .up_tlast_d(w_fifo_d_down_tlast),
        .up_tuser_d(w_fifo_d_down_tuser),
        .up_ready_d(w_gl7_up_ready_d),
        .down_data(w_gl7_down_data),
        .down_valid(w_gl7_down_valid),
        .down_tlast(w_gl7_down_tlast),
        .down_tuser(w_gl7_down_tuser),
        .down_ready(w_rg7_up_ready));

pipeline_register_type3 # (.D_WIDTH (D_WIDTH))
RG7
(       .clk(clk),
        .rst(rst),
        .up_data(w_gl7_down_data),
        .up_valid(w_gl7_down_valid),
        .up_tlast(w_gl7_down_tlast),
        .up_tuser(w_gl7_down_tuser),
        .up_ready(w_rg7_up_ready),
        .down_data(down_data),
        .down_valid(down_valid),
        .down_tlast(down_tlast),
        .down_tuser(down_tuser),
        .down_ready(down_ready));

endmodule

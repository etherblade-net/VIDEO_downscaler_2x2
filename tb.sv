module tb
# (
  parameter D_WIDTH = 8, FIFO1_A_WIDTH = 8, FIFO2_A_WIDTH = 1
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

  // Model
  wire [(D_WIDTH-1):0]  model_data;
  wire                  model_tlast;
  wire                  model_tuser;
  wire                  push;
  logic                 push_prev;
  wire                  pop;


  int unsigned up_valid_probability = 10;
  int unsigned down_ready_probability = 100;

  int unsigned framelock_curr = 0;      //current fleet
  int unsigned framelock_value = 13;    //pixel number marked with tuser. This is Start of frame pixel to lock the stream
  int unsigned x_curr = 0;              //current pixel in line
  int unsigned x_max = 319;               //maximum pixel value (x frame size) at which tlast will be generated
  int unsigned y_curr = 0;              //current line number
  int unsigned y_max = 199;               //maximum line number (y-frame size), after finishing that line y_curr go back to zero


  //--------------------------------------------------------------------------
  // DUT instantiation
rtl_top # (.D_WIDTH (D_WIDTH), .FIFO1_A_WIDTH (FIFO1_A_WIDTH), .FIFO2_A_WIDTH (FIFO2_A_WIDTH))
DUT1
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
  // MODEL instantiation
model # (.D_WIDTH (D_WIDTH))
MDL1
(       .clk(clk),
        .rst(rst),
        .up_data(up_data),
        .up_tlast(up_tlast),
        .up_tuser(up_tuser),
        .push(push),
        .down_data(model_data),
        .down_tlast(model_tlast),
        .down_tuser(model_tuser),
        .pop(pop));
  //--------------------------------------------------------------------------

  // Driving clock

  initial
  begin
    forever #5 clk = ~ clk;
  end

  //--------------------------------------------------------------------------
  // Driving reset and control signals

  initial
  begin
    `ifdef __ICARUS__
      $dumpvars;
    `endif

    //------------------------------------------------------------------------
    // Initialization
    clk = 1;
    rst = 0;
    up_valid = 1'bx;
    up_tlast = 1'bx;
    up_tuser = 1'bx;
    up_data = {D_WIDTH{1'bx}};
    push_prev = 0;
    down_ready = 1'bx;

    //------------------------------------------------------------------------
    // Reset

    repeat (3) @ (negedge clk);
    rst = '1;
    repeat (3) @ (negedge clk);
    rst = '0;
    @(negedge clk);

    //------------------------------------------------------------------------

    @(posedge clk);
    $display ("*** run back-to-back full speed");
    up_valid_probability = 100;
    down_ready_probability = 100;
    repeat (80) @ (negedge clk);

    @(posedge clk);
    $display ("*** slow Source");
    up_valid_probability = 10;
    down_ready_probability = 100;
    repeat (40) @ (negedge clk);

    @(posedge clk);
    $display ("*** slow Sink");
    up_valid_probability = 100;
    down_ready_probability = 10;
    repeat (40) @ (negedge clk);

    @(posedge clk);
    $display ("*** slow Source and slow Sink");
    up_valid_probability = 10;
    down_ready_probability = 10;
    repeat (40) @ (negedge clk);

    @(posedge clk);
    $display ("*** slow Source");
    up_valid_probability = 10;
    down_ready_probability = 100;
    repeat (40) @ (negedge clk);

    @(posedge clk);
    $display ("*** Source and Sink running at average speed");
    up_valid_probability = 50;
    down_ready_probability = 50;
    repeat (40) @ (negedge clk);

    @(posedge clk);
    $display ("*** run back-to-back full speed");
    up_valid_probability = 100;
    down_ready_probability = 100;
    repeat (200000) @ (negedge clk);

    //------------------------------------------------------------------------
    $finish;
  end

  //--------------------------------------------------------------------------

  // Monitoring/Driving data
  always @ (negedge clk)
    begin
      if (down_valid)
        begin
          $write ("NEGEDGE-    Valid-RTL-Out/Model-Out: %h,%h,%h / %h,%h,%h    ", down_data, down_tlast, down_tuser, model_data, model_tlast, model_tuser);
          $write ("\n");
            if ((model_data !== down_data) | (model_tlast !== down_tlast) | (model_tuser !== down_tuser))
              begin
                $display ("ERROR: downstream data mismatch. Expected %h,%h,%h, actual %h,%h,%h",
                model_data, model_tlast, model_tuser, down_data, down_tlast, down_tuser);
              end
        end

      if (up_valid & !push_prev)
        begin
          up_valid = 1;        //unconfirmed valid must remain up as per AXI
        end else begin
          if ($urandom_range (1, 100) <= up_valid_probability)
            begin
              up_valid = 1'b1;
            end else begin
              up_valid = 1'b0;
            end
          if (up_valid)        //new valid data flit is generated
            begin
              //Generate up_data
              up_data  = $urandom();
              //Generate up_tlast and up_tuser
              if (x_curr == x_max)
                begin
                  up_tlast = 1'b1;
                end else begin
                  up_tlast = 1'b0;
                end
              if ((x_curr == 0) & (y_curr == 0) & (framelock_curr == framelock_value)) 
                begin
                  up_tuser = 1'b1;
                end else begin
                  up_tuser = 1'b0;
                end
            end
        end

      if ($urandom_range (1, 100) <= down_ready_probability)
        begin   //ready may go up or down as per AXI
          down_ready = 1'b1;
        end else begin
          down_ready = 1'b0;
        end
    end


  assign push = up_valid & up_ready;
  assign pop = down_valid & down_ready;


  always @ (posedge clk)
    begin
      push_prev = push;

        if (push)
          begin
            if (framelock_curr != framelock_value)
              begin
                framelock_curr = framelock_curr + 1;
              end else
            if ((x_curr == x_max) & (y_curr == y_max)) 
              begin
                x_curr = 0;
                y_curr = 0;
              end else
            if ((x_curr == x_max) & (y_curr != y_max)) 
              begin
                x_curr = 0;
                y_curr = y_curr + 1;
              end else
            if (x_curr != x_max) 
              begin
                x_curr = x_curr + 1;
              end
          end

      $write ("POSEDGE-   ");
      if (rst)
        $write ("RESET      ");
      else
        $write ("           ");
      if (push)
        $write ("PUSH %h,%h,%h  ", up_data, up_tlast, up_tuser);
      else
        $write ("          ");
      if (pop)
        $write ("POP    ");
      else
        $write ("           ");
        $write ("\n");
    end

endmodule

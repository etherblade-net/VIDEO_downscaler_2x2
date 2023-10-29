//---TRANSACTION LEVEL MODEL---//

module model #(parameter D_WIDTH = 8)
(
input                         clk,
input                         rst,
input        [(D_WIDTH-1):0]  up_data,
input                         up_tlast,
input                         up_tuser,
input                         push,
output logic [(D_WIDTH-1):0]  down_data,
output logic                  down_tlast,
output logic                  down_tuser,
input                         pop
);

logic [(D_WIDTH+1):0] queue_a[$], queue_b[$], queue_c[$], queue_d[$], queue_out [$];
logic [(D_WIDTH-1):0] queue_a_data, queue_b_data, queue_c_data, queue_d_data, queue_out_data;
logic queue_a_tlast, queue_b_tlast, queue_c_tlast, queue_d_tlast, queue_out_tlast;
logic queue_a_tuser, queue_b_tuser, queue_c_tuser, queue_d_tuser, queue_out_tuser;
logic framelock, pixel_counter, line_counter;
logic [(D_WIDTH+1):0] ext_sum_data;

////START OF TLM MODEL////
  always @ (posedge clk)
  begin
    if (rst)
    begin
      queue_a = {};
      queue_b = {};
      queue_c = {};
      queue_d = {};
      queue_out = {};
      pixel_counter = 1'b0;
      line_counter = 1'b0;
      framelock = 1'b0;
    end else
    ////DO MODELLING HERE////
    begin
      if (push)
        begin                              //blocking assignments and function calls can be used between these begin and end
          if (up_tuser) framelock = 1'b1;  //waiting for the first Start-of-frame (pixel with tuser) and start processing stream from this pixel.
          if (framelock)
            begin
              if ((pixel_counter == 1'b0) & (line_counter == 1'b0)) queue_a.push_back ({up_tlast, up_tuser, up_data});
              if ((pixel_counter == 1'b1) & (line_counter == 1'b0)) queue_b.push_back ({up_tlast, up_tuser, up_data});
              if ((pixel_counter == 1'b0) & (line_counter == 1'b1)) queue_c.push_back ({up_tlast, up_tuser, up_data});
              if ((pixel_counter == 1'b1) & (line_counter == 1'b1)) queue_d.push_back ({up_tlast, up_tuser, up_data});

              pixel_counter = pixel_counter + 1'b1;
              if (up_tlast) line_counter = line_counter + 1'b1;

              if ((queue_a.size () != 0) & (queue_b.size () != 0) & (queue_c.size () != 0) & (queue_d.size () != 0))
                begin
                  {queue_a_tlast, queue_a_tuser, queue_a_data} = queue_a [0];
                  {queue_b_tlast, queue_b_tuser, queue_b_data} = queue_b [0];
                  {queue_c_tlast, queue_c_tuser, queue_c_data} = queue_c [0];
                  {queue_d_tlast, queue_d_tuser, queue_d_data} = queue_d [0];

                  queue_out_tlast = queue_a_tlast | queue_b_tlast | queue_c_tlast | queue_d_tlast;
                  queue_out_tuser = queue_a_tuser | queue_b_tuser | queue_c_tuser | queue_d_tuser;
                  ext_sum_data = queue_a_data + queue_b_data + queue_c_data + queue_d_data;
                  queue_out_data = ext_sum_data[(D_WIDTH+1):2];
                  queue_out.push_back ({queue_out_tlast, queue_out_tuser, queue_out_data});

                  `ifdef __ICARUS__
                    // Some version of Icarus has a bug, and this is a workaround
                    queue_a.delete (0);
                    queue_b.delete (0);
                    queue_c.delete (0);
                    queue_d.delete (0);
                  `else
                    queue_a.pop_front ();
                    queue_b.pop_front ();
                    queue_c.pop_front ();
                    queue_d.pop_front ();
                  `endif
                end
            end
          end

      if (pop)
      begin
        if (queue_out.size () != 0)
        begin
          `ifdef __ICARUS__
            queue_out.delete (0);          // queue.delete(0) is used because "queue.pop_front()" method doesn't work in IcarusVerilog
          `else
            queue_out.pop_front ();
          `endif
        end
      end
    end
    {down_tlast, down_tuser, down_data} = queue_out [0];

  end
////END OF TLM MODEL////

endmodule

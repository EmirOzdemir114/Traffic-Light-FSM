//--------------------
`timescale 1ns/1ps
module tb_TrafficFSM;

  logic       clk;
  logic       reset;
  logic       TAORB;
  logic [2:0] LA, LB;


 
  TrafficFSM dut (
    .clk   (clk),
    .reset (reset),
    .TAORB (TAORB),
    .LA    (LA),
    .LB    (LB)
  );


 // Decode LA/LB into text
 
  typedef enum logic [1:0] {
    RED    = 2'd0,
    YELLOW = 2'd1,
    GREEN = 2'd2,
    UNK    = 2'd3
  } color_t;

  color_t LA_color, LB_color;

  always_comb begin
    unique case (LA)
      3'b100: LA_color = GREEN;
      3'b010: LA_color = YELLOW;
      3'b001: LA_color = RED;
      default: LA_color = UNK;
    endcase

    unique case (LB)
      3'b100: LB_color = GREEN;
      3'b010: LB_color = YELLOW;
      3'b001: LB_color = RED;
      default: LB_color = UNK;
    endcase
  end
  
  initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
   initial begin
        reset = 1'b1;
        TAORB = 1'b1;
        #20;
        reset = 1'b0;
        #40;
        TAORB = 1'b0;
        #140;
        TAORB = 1'b1;
        #140;
        $finish;
    end

endmodule

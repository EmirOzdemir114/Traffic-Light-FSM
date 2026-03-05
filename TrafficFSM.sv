`timescale 1ns / 1ps

module TrafficFSM(
    input clk,
    input reset,
    input TAORB,
    output logic [2:0] LA,  // Each bit corresponds to G,Y,R respectively
    output logic [2:0] LB   //LA = (100) means LA is GREEN.
    );
    
    typedef enum logic [1:0] { S0, S1, S2, S3 } state_t;
    state_t state, next_state;

    logic [2:0] timer;
    localparam logic [2:0] Delay = 3'd5;
    localparam logic [2:0] G = 3'b100;
    localparam logic [2:0] Y = 3'b010;
    localparam logic [2:0] R = 3'b001;
    
     always_ff @(posedge clk) begin
        if (reset) begin
            state <= S0;
            timer <= 3'd0;
        end 
        else begin
            state <= next_state;

            if ((state == S1) || (state == S3)) begin
                if (next_state == state) begin
                    if (timer < Delay-1) timer <= timer + 3'd1;           
                end else begin
                    timer <= 3'd0;
                end
            end else begin
                timer <= 3'd0;
            end
        end
    end

  
    always_comb begin
        next_state = state;

        unique case (state)
            S0: if (!TAORB)          next_state = S1;

            S1: begin   
                if (timer >= Delay-1)   next_state = S2;
                else                 next_state = S1;
            end

            S2: if (TAORB)           next_state = S3;

            S3: begin
                if (timer >= Delay-1)  next_state = S0;
                else                 next_state = S3;
            end

            default:                 next_state = S0;
        endcase
    end

   

    always_comb begin
        LA = G;
        LB = R;

        unique case (state)
            S0: begin LA = G; LB = R; end
            S1: begin LA = Y; LB = R; end
            S2: begin LA = R; LB = G; end
            S3: begin LA = R; LB = Y; end
            default: begin LA = G; LB = R; end
        endcase
    end

endmodule
    
  




module gcd_bonus (
    output reg [10:0] pow_out,
    output reg       out_valid,
    output reg       error,
    output reg [2:0] state,
    input            clk,
    input            rst_n,
    input      [9:0] data_in,
    input            in_valid
);

    parameter [2:0] IDLE   = 3'd0;
    parameter [2:0] READ   = 3'd1;
    parameter [2:0] CALC   = 3'd2;
    parameter [2:0] WRITE  = 3'd3;
    parameter [2:0] FINISH = 3'd4;



   
    reg [2:0] next_state;
    reg [2:0] state;
    // Sequential registers
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            
        end else begin
           
        end
    end

    
    always @(*) begin
        

        case (state)
            IDLE: begin
                
            end

            READ: begin
                
            end

            CALC: begin
                
            end

            WRITE: begin
                
            end

            FINISH: begin
                
            end

            default: begin
                
            end
        endcase
    end

endmodule

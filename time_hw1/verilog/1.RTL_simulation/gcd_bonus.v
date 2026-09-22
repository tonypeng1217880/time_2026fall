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

    parameter [1:0] IDLE   = 3'd0;
    parameter [1:0] CALC   = 3'd1;
    parameter [1:0] FINISH = 3'd2;

    reg [2:0] state;
    reg [9:0] data_reg;

    //input register
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_reg <= 0;
        end 
        else if (in_valid && (state == IDLE)) begin
            data_reg <= data_in;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
        end
        else begin
            case (state)
                IDLE: begin
                    state <= CALC;
                end

                CALC: begin
                    
                end

                FINISH: begin
                    
                end

                default: begin
                    
                end
            endcase
        end
    end

endmodule

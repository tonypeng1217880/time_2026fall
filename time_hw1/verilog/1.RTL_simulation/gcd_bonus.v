module gcd_bonus (
    output  [10:0] pow_out,
    output        out_valid,
    input            clk,
    input            rst_n,
    input      [9:0] data_in,
    input            in_valid
);

    parameter [2:0] IDLE   = 3'd0;
    parameter [2:0] CALC   = 3'd1;
    parameter [2:0] FINISH = 3'd2;

    reg [2:0] state;
    reg [9:0] data_reg;
    reg [3:0] bit_index;
    reg [10:0] y_reg;
    wire [19:0] data_square;
    wire [32:0] target;
    wire [10:0] trial_y;
    wire [21:0] trial_square;
    wire [32:0] trial_cube;
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
            state       <= IDLE;
            bit_index   <= 4'b0;
            y_reg       <= 11'b0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (in_valid)begin
                        state       <= CALC;
                        bit_index   <= 4'd10;
                        y_reg       <= 11'b0;
                    end
                end

                CALC: begin
                    if (trial_cube <= target) begin
                        y_reg <= trial_y;
                    end
                    if (bit_index == 0) begin
                        state <= FINISH ;
                    end
                    else begin
                        state <= CALC;
                        bit_index <= bit_index - 1'b1;
                    end
                end

                FINISH: begin
                    state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

assign data_square   = {11'b0, data_reg} * data_reg;
assign target       = {1'b0, data_square, 12'b0};
assign trial_y      = (11'b1<<bit_index) | y_reg;
assign trial_square = {11'b0, trial_y} * trial_y;
assign trial_cube   = {11'b0, trial_square} * trial_y;
assign pow_out      = y_reg;
assign out_valid    = (state == FINISH) ? 1 : 0;
endmodule

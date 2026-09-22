module gcd (
    output     [9:0] sqr_out,
    output reg       out_valid,
    input             clk,
    input             rst_n,
    input      [9:0] data_in,
    input             in_valid
);

    reg [1:0] state;
    reg [1:0] next_state;
    reg [9:0] data_reg;
    reg [9:0] y_reg;
    reg [9:0] next_y_reg;
    reg [3:0] bit_index;
    reg [3:0] next_bit_index;

    wire [19:0] target;
    wire [9:0] trial_y;
    wire [19:0] trial_y_20;
    wire [19:0] trial_square;

    parameter [1:0] IDLE = 0;
    parameter [1:0] CALC = 1;
    parameter [1:0] FINISH = 2;

//input regiter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg <= 0;
        end
        else if (in_valid && (state == IDLE)) begin
            data_reg <= data_in;
        end
    end
//next state
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        next_y_reg = y_reg;
        next_bit_index = bit_index;
        case (state)
            IDLE: begin
                if (in_valid) begin
                    next_state = CALC;
                    next_bit_index = 4'd9;
                    next_y_reg = 10'd0;
                end
            end

            CALC: begin
                if (trial_square <= target) begin
                    next_y_reg = trial_y;
                end

                if (bit_index == 0) begin
                    next_state = FINISH;
                end
                else begin
                    next_bit_index = bit_index - 1'b1;
                end
            end

            FINISH: begin
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

assign target = {1'b0, data_reg, 9'b0};
assign trial_y = y_reg | (10'b1 << bit_index);
assign trial_y_20 = {10'b0, trial_y};
assign trial_square = trial_y_20 * trial_y_20;

assign sqr_out = y_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            y_reg <= 0;
            bit_index <= 0;
        end
        else begin
            y_reg <= next_y_reg;
            bit_index <= next_bit_index;
        end
    end

    always @(*) begin
        if (state == FINISH)
            out_valid = 1;
        else
            out_valid = 0;
    end

endmodule

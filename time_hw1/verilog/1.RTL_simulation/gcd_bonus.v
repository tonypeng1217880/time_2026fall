module gcd_bonus (
    output reg [9:0] pow_out,
    output reg       done,
    output reg       error,
    output reg [2:0] state,
    input            clk,
    input            rst_n,
    input      [9:0] number,
    input            start
);

    parameter [2:0] IDLE   = 3'd0;
    parameter [2:0] READ   = 3'd1;
    parameter [2:0] CALC   = 3'd2;
    parameter [2:0] WRITE  = 3'd3;
    parameter [2:0] FINISH = 3'd4;

    // Datapath registers
    reg [9:0] number_reg;
    reg [9:0] y_reg;
    reg [3:0] bit_index;

    // Next-state / next-data signals
    reg [2:0] next_state;
    reg [9:0] next_number_reg;
    reg [9:0] next_y_reg;
    reg [3:0] next_bit_index;
    reg [9:0] next_pow_out;
    reg       next_error;

    // Temporary combinational values for the bonus calculation.
    // target = number_reg^2 << 12
    // trial_cube = trial_y^3
    reg [9:0]  trial_y;
    reg [31:0] number_ext;
    reg [31:0] trial_y_ext;
    reg [31:0] target;
    reg [31:0] trial_cube;

    // Sequential registers
    always @(posedge clk) begin
        if (~rst_n) begin
            pow_out   <= 10'd0;
            error     <= 1'b0;
            state     <= IDLE;
            number_reg <= 10'd0;
            y_reg      <= 10'd0;
            bit_index  <= 4'd9;
        end else begin
            pow_out   <= next_pow_out;
            error     <= next_error;
            state     <= next_state;
            number_reg <= next_number_reg;
            y_reg      <= next_y_reg;
            bit_index  <= next_bit_index;
        end
    end

    // Next-state and datapath logic
    always @(*) begin
        done = 1'b0;

        next_state      = state;
        next_number_reg = number_reg;
        next_y_reg      = y_reg;
        next_bit_index  = bit_index;
        next_pow_out    = pow_out;
        next_error      = error;

        // Default temporary values. Extending before multiplication prevents
        // the intermediate products from being truncated to 10 bits.
        trial_y      = y_reg | (10'd1 << bit_index);
        number_ext   = {22'd0, number_reg};
        trial_y_ext  = {22'd0, trial_y};
        target       = (number_ext * number_ext) << 12;
        trial_cube   = trial_y_ext * trial_y_ext * trial_y_ext;

        case (state)
            IDLE: begin
                if (start) begin
                    next_state = READ;
                    next_error = 1'b0;
                end
            end

            READ: begin
                next_number_reg = number;
                next_y_reg      = 10'd0;
                next_bit_index  = 4'd9;
                next_state      = CALC;
            end

            CALC: begin
                // TODO:
                // 1. Compare trial_cube with target.
                // 2. Keep trial_y when the comparison passes.
                // 3. Move bit_index from 9 down to 0.
                // 4. After testing bit 0, go to WRITE.

                // Remove these two placeholder statements when implementing
                // the four steps above.
                next_error = 1'b1;
                next_state = WRITE;
            end

            WRITE: begin
                next_pow_out = (error) ? 10'd0 : y_reg;
                next_state   = FINISH;
            end

            FINISH: begin
                done       = 1'b1;
                next_error = 1'b0;
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
                next_error = 1'b1;
            end
        endcase
    end

endmodule

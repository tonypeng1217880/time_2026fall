module gcd (
    output reg [7:0] gcd_out,
    output reg done,
    output reg error,
    output reg [2:0] state,
    input clk,
    input rst_n,
    input [7:0] number1,
    input [7:0] number2,
    input start
);

    reg [7:0] reg_number1, reg_number2;
    reg [7:0] next_reg_number1, next_reg_number2;
    reg [2:0] next_state;
    reg [7:0] next_gcd_out;
    reg next_error;

    parameter [2:0] IDLE = 0;
    parameter [2:0] READ = 1;
    parameter [2:0] CALC = 2;
    parameter [2:0] WRITE = 3;
    parameter [2:0] FINISH = 4;

    always @(posedge clk) begin
        if (~rst_n) begin
            reg_number1 <= 0;
            reg_number2 <= 0;
            state       <= IDLE;
            gcd_out     <= 0;
            error       <= 0;
        end else begin
            reg_number1 <= next_reg_number1;
            reg_number2 <= next_reg_number2;
            state       <= next_state;
            gcd_out     <= next_gcd_out;
            error       <= next_error;
        end
    end

    always @(*) begin
        done             = 0;
        next_reg_number1 = reg_number1;
        next_reg_number2 = reg_number2;
        next_state       = state;
        next_gcd_out     = gcd_out;
        next_error       = error;
        case (state)
            IDLE: begin
                if (start) begin
                    next_state = READ;
                end
            end

            READ: begin
                next_state       = CALC;
                next_reg_number1 = number1;
                next_reg_number2 = number2;
            end

            CALC: begin
                if ((reg_number1 == 0) || (reg_number2 == 0)) begin  // data_in have error.
                    next_state = WRITE;
                    next_error = 1;
                end else begin  // data_in don't have error.
                    if (reg_number1 == reg_number2) begin  // calculate done
                        next_state = WRITE;
                    end else if (reg_number1 > reg_number2) begin  // GCD calculating...
                        next_state       = CALC;
                        next_reg_number1 = reg_number1 - reg_number2;
                    end else begin  // GCD calculating...
                        next_state       = CALC;
                        next_reg_number2 = reg_number2 - reg_number1;
                    end
                end
            end

            WRITE: begin
                next_state   = FINISH;
                next_gcd_out = (error) ? 0 : reg_number1;
            end

            FINISH: begin
                done       = 1'b1;
                next_error = 0;
                next_state = IDLE;
            end
        endcase
    end

endmodule

`default_nettype none

module uart_receive
    #(parameter CLK_SPEED = 5_000_000,
                BAUD_RATE = 9600,
                
                localparam 
                BAUD_TICK = CLK_SPEED / BAUD_RATE,
                HALF_BAUD_TICK = BAUD_TICK / 2,
                BAUD_TICK_WIDTH = $clog2(BAUD_TICK))
    (input logic rx, clock, reset_n,
    output logic [7:0] dataOut,
    output logic finished_read);

    logic [3:0] data_bits; // keep track of how many data bits we have sent
    logic [BAUD_TICK_WIDTH-1:0] clock_ticks; // oversampling ticks
    logic [7:0] tempdata; // temporary data storage to form our data output
    logic data_count_enable; // enable signal to count how many data bits we have read
    logic data_count_load; // load signal to reset how many data bits we have read
    logic clk_count_enable; // enable signal to count how many clock cycles we have read
    logic clk_count_load; // load signal to reset how many clock cycles we have read
    logic sipo_enable; // enable signal for the SIPO to store the data bits
    logic sipo_clear; // clear signal for the SIPO to store the data bits

    Counter #(4) data_read (.D(4'd0),
                            .en(data_count_enable),
                            .clear(1'b0),
                            .load(data_count_load),
                            .clock(clock),
                            .up(1'b1),
                            .Q(data_bits));

    Counter #(BAUD_TICK_WIDTH) clk_read (.D('d0),
                            .en(clk_count_enable),
                            .clear(1'b0),
                            .load(clk_count_load),
                            .clock(clock),
                            .up(1'b1),
                            .Q(clock_ticks));   

    ShiftRegister_SIPO #(8) reg_read (.serial(rx),
                                 .en(sipo_enable),
                                 .left(1'b0),
                                 .clear(sipo_clear),
                                 .clock(clock),
                                 .Q(tempdata));                         

    // defining our states
    enum logic [2:0] {WAITING=3'd1, READING=3'd2, STOP=3'd3} state, nextState;

    // FF logic to actually perform the state changes
    always_ff @(posedge clock, negedge reset_n) begin
        if (~reset_n) begin
            state <= WAITING;
        end
        else state <= nextState;
    end

    // nextState logic 
    always_comb begin
        unique case (state)
            WAITING : nextState = (rx == 0 && {20'd0, clock_ticks} == HALF_BAUD_TICK) ? READING : WAITING;
            READING : nextState = (data_bits == 4'h7 && {20'd0, clock_ticks} == BAUD_TICK) ? STOP : READING;
            STOP : nextState = (rx == 1 && {20'd0, clock_ticks} == BAUD_TICK) ? WAITING : STOP;
            default: nextState = WAITING;
        endcase
    end

    // output logic
    always_comb begin
        finished_read = 1'b0; data_count_load = 1'b0; data_count_enable = 1'b0;
        clk_count_enable = 1'b0; clk_count_load = 1'b0; sipo_enable = 1'b0;
        sipo_clear = 1'b0;
        case (state) 
            WAITING : 
                begin
                    if (rx == 0 && {20'd0, clock_ticks} == HALF_BAUD_TICK) begin
                        clk_count_load = 1'b1;
                    end
                    else if (rx == 0) begin
                        clk_count_enable = 1'b1; 
                    end
                    else begin
                        sipo_clear = 1'b1;
                        data_count_load = 1'b1;
                        clk_count_load = 1'b1;
                    end
                end
            READING : 
                begin
                    if ({20'd0, clock_ticks} == BAUD_TICK) begin
                        clk_count_load = 1'b1;
                        data_count_enable = 1'b1;
                        sipo_enable = 1'b1;
                    end
                    else begin
                        clk_count_enable = 1'b1; 
                    end
                end
            STOP :
                begin
                    if (rx == 1 && {20'd0, clock_ticks} == BAUD_TICK) begin
                        clk_count_load = 1'b1;
                        finished_read = 1'b1;
                        data_count_load = 1'b1;
                    end
                    else begin
                        clk_count_enable = 1'b1;
                    end
                end
        endcase
    end

    assign dataOut = tempdata;


endmodule : uart_receive

// A binary up-down counter.
// Clear has priority over Load, which has priority over Enable
module Counter
    #(parameter WIDTH=8)
    (input logic [WIDTH-1:0] D,
     input logic en, clear, load, clock, up,
     output logic [WIDTH-1:0] Q);

    always_ff @(posedge clock)
        if (clear)
            Q <= {WIDTH {1'b0}};
        else if (load)
            Q <= D;
        else if (en)
            if (up)
                Q <= Q + 1'b1;
            else
                Q <= Q - 1'b1;

endmodule : Counter

// A SIPO Shift Register, with controllable shift direction
// Load has priority over shifting.
module ShiftRegister_SIPO
    #(parameter WIDTH=8)
    (input logic serial,
     input logic en, left, clear, clock,
     output logic [WIDTH-1:0] Q);

    always_ff @(posedge clock)
    if (clear) 
        Q <= {WIDTH {1'b0}};
    else if (en)
        if (left)
            Q <= {Q[WIDTH-2:0], serial};
        else
            Q <= {serial, Q[WIDTH-1:1]};

endmodule : ShiftRegister_SIPO

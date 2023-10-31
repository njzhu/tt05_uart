`default_nettype none

module uart_receive
    #(parameter CLK_SPEED = 50_000_000,
                BAUD_RATE = 9600
                
                localparam 
                BAUD_TICK = CLK_SPEED / BAUD_RATE,
                HALF_BAUD_TICK = BAUD_TICK / 2)
                BAUD_TICK_WIDTH = $clog2(BAUD_TICK_WIDTH)
    (input logic rx, clock, reset_n,
    output logic [7:0] dataOut,
    output logic finished_read);

    // defining our states
    enum logic [2:0] {WAITING=3'd1, READING=3'd2, STOP=3'd3} state, nextState;

    logic [2:0] data_bits; // keep track of how many data bits we have sent
    logic [BAUD_TICK_WIDTH:0] clock_ticks; // oversampling ticks
    logic [7:0] tempdata; // temporary data storage to form our data output

    // FF logic to actually perform the state changes
    always_ff @(posedge clock, negedge reset_n) begin
        if (~reset_n) begin
            state <= WAITING;
            tempdata <= 8'd0;
            data_bits <= 0;
            clock_ticks <= 0;
        end
        else state <= nextState
    end

    // nextState logic 
    always_comb begin
        unique case (state)
            WAITING : nextState = (rx == 0 && clock_ticks == HALF_BAUD_TICK) ? READING : WAITING;
            READING : nextState = (data_bits == 3'h7 && clock_ticks == BAUD_TICK) ? STOP : READING;
            STOP : nextState = (rx == 1 && clock_ticks == HALF_BAUD_TICK) ? WAITING : STOP;
    end

    // output logic
    always_comb begin
        finished_read = 1'b0;
        case (state) 
            WAITING : 
                begin
                    if (rx == 0 && clock_ticks == HALF_BAUD_TICK) begin
                        clock_ticks = 0;
                    end
                    else if (rx == 0) begin
                        clock_ticks = clock_ticks + 1;
                    end
                end
            READING : 
                begin
                    if (clock_ticks == BAUD_TICK) begin
                        clock_ticks = 0;
                        data_bits = data_bits + 1;
                        tempdata = {rx, tempdata[7:1]};
                    end
                    else begin
                        clock_ticks = clock_ticks + 1;
                    end
                end
            STOP :
                begin
                    if (rx == 1 && clock_ticks == BAUD_TICK) begin
                        clock_ticks = 0;
                        finished_read = 1;
                        dataOut = tempdata;
                        data_bits = 0;
                    end
                    else begin
                        clock_ticks = clock_ticks + 1;
                    end
                end
        endcase
    end

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
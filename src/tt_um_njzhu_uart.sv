`default_nettype none

module tt_um_njzhu_uart (
    input  logic [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output logic [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  logic [7:0] uio_in,   // IOs: Bidirectional Input path
    output logic [7:0] uio_out,  // IOs: Bidirectional Output path
    output logic [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  logic       ena,      // will go high when the design is enabled
    input  logic       clk,      // clock
    input  logic       rst_n     // reset_n - low to reset
);
    logic finished_read, rx, dataReady, tx;

    logic [7:0] dataOut, dataIn;

    always_comb begin
        if (ui_in[7]) begin // rx

            // use bidirectionals as outputs
            uio_oe = 8'b1111_1111;

            uio_out[0] = finished_read;

            uio_out[7:1] = 'd0;

            rx = ui_in[0];

            uo_out = dataOut;

            dataIn = 8'd0;

            dataReady = 8'd0;
        end
        else begin

            // use bidirectionals as inputs
            uio_oe = 8'b0000_0000;

            dataIn = uio_in;

            dataReady = ui_in[0];

            uo_out[0] = tx;

            uo_out[7:1] = 'd0;

            uio_out = 'd0;

            rx = 1'b0;

        end
    end


    // 

    uart_receive #(5_000_000, 9600) uart_rx (.rx(rx), 
                                              .clock(clk),
                                              .reset_n(rst_n),
                                              .dataOut(dataOut),
                                              .finished_read(finished_read));

    uart_transmit #(5_000_000, 9600) uart_tx (.clock(clk), 
                                              .reset_n(rst_n), 
                                              .dataReady(dataReady),
                                              .dataIn(dataIn),
                                              .tx(tx));                                              

endmodule : tt_um_njzhu_uart

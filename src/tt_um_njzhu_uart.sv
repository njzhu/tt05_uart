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
    logic finished_read;

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;

    assign uio_out[0] = finished_read;

    assign uio_out[7:1] = 'd0;

    uart_receive #(5_000_000, 9600) uart_rx (.rx(ui_in[0]), 
                                              .clock(clk),
                                              .reset_n(rst_n),
                                              .dataOut(uo_out),
                                              .finished_read(finished_read));

endmodule : tt_um_njzhu_uart

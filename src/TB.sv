module TB;
  logic clock, resetN;
  logic rx, finished_read;

  logic [7:0] dataOut;
  
  uart_receive #(49_996_800, 9600) dut (.rx(rx),
                        .clock(clock),
                        .reset_n(resetN),
                        .dataOut(dataOut),
                        .finished_read(finished_read));

  initial begin
    clock = 1'b0;

    forever #5 clock = ~clock;
  end

//   initial begin
//     #10000

//     $display("@%0t: Error timeout!", $time);
//     $finish;
//   end

  initial begin 
    $monitor($time, " finished_read: %h dataOut: %b tempData: %b %d", 
                        finished_read, dataOut, dut.tempdata, dut.state);  
  end

  initial begin
    rx <= 1'b1;
    resetN <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    resetN <= 1'b0;
    rx <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    resetN <= 1'b1;
    @(posedge clock);
    @(posedge clock);

    rx <= 1'b0;
    for (int i = 0; i < 5208; i++) begin // SEND THE START BIT
        $display($time, " finished_read: %h dataOut: %b tempData: %b %d", 
                        finished_read, dataOut, dut.tempdata, dut.state); 
      @(posedge clock);
    end

    $display($time, " finished_read: %h dataOut: %b tempData: %b", 
                        finished_read, dataOut, dut.tempdata);

    rx <= 1'b1;
    for (int i = 0; i < 5208; i++) begin // 1 DATA BIT
      @(posedge clock);
    end

    $display($time, " finished_read: %h dataOut: %b tempData: %b", 
                        finished_read, dataOut, dut.tempdata);

    rx <= 1'b0;
    for (int i = 0; i < 5208; i++) begin // 2 DATA BIT
      @(posedge clock);
    end

    $display($time, " finished_read: %h dataOut: %b tempData: %b", 
                        finished_read, dataOut, dut.tempdata);

    rx <= 1'b1;
    for (int i = 0; i < 5208; i++) begin // 3 DATA BIT
      @(posedge clock);
    end

    $display($time, " finished_read: %h dataOut: %b tempData: %b", 
                        finished_read, dataOut, dut.tempdata);

    rx <= 1'b0;
    for (int i = 0; i < 5208; i++) begin // 4 DATA BIT
      @(posedge clock);
    end

    $display($time, " finished_read: %h dataOut: %b tempData: %b", 
                        finished_read, dataOut, dut.tempdata);

    rx <= 1'b1;
    for (int i = 0; i < 5208; i++) begin // 5 DATA BIT
      @(posedge clock);
    end

    $display($time, " finished_read: %h dataOut: %b tempData: %b", 
                        finished_read, dataOut, dut.tempdata);

    rx <= 1'b0;
    for (int i = 0; i < 5208; i++) begin // 6 DATA BIT
      @(posedge clock);
    end

    $display($time, " finished_read: %h dataOut: %b tempData: %b", 
                        finished_read, dataOut, dut.tempdata);

    rx <= 1'b1;
    for (int i = 0; i < 5208; i++) begin // 7 DATA BIT
      @(posedge clock);
    end

    $display($time, " finished_read: %h dataOut: %b tempData: %b", 
                        finished_read, dataOut, dut.tempdata);

    rx <= 1'b0;
    for (int i = 0; i < 5208; i++) begin // 8 DATA BIT
      @(posedge clock);
    end

    $display($time, " finished_read: %h dataOut: %b tempData: %b", 
                        finished_read, dataOut, dut.tempdata);

    rx <= 1'b1;
    for (int i = 0; i < 5208; i++) begin // SEND STOP BIT
      @(posedge clock);
    end
    $display($time, " finished_read: %h dataOut: %b tempData: %b", 
                        finished_read, dataOut, dut.tempdata);
    $finish;
  end

endmodule : TB

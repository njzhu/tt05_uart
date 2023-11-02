module TB;
  logic clock, resetN;
  logic dataReady, tx;

  logic [7:0] dataIn;
  
  uart_transmit #(4_992_000, 9600) dut (.dataReady(dataReady),
                                        .dataIn(dataIn),
                                        .tx(tx),
                                        .reset_n(resetN),
                                        .clock(clock));

  initial begin
    clock = 1'b0;

    forever #5 clock = ~clock;
  end

  // initial begin 
  //   // $monitor($time, " dataReady: %h dataIn: %b tx: %b %d", 
  //   //                     dataReady, dataIn, tx, dut.state);  
  // end

  initial begin
    dataReady <= 1'b0;
    resetN <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    resetN <= 1'b0;
    dataReady <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    resetN <= 1'b1;
    @(posedge clock);
    @(posedge clock);

    dataReady <= 1'b1;
    dataIn <= 8'b0000_1101;
    for (int i = 0; i < 520; i++) begin // SEND THE START BIT
      @(posedge clock);
    end

    $display("Start sent");
    $display($time, " dataReady: %h dataIn: %b tx: %b %d", 
                        dataReady, dataIn, tx, dut.state);  

    for (int i = 0; i < 520; i++) begin // 1 DATA BIT
      @(posedge clock);
    end

    dataReady <= 1'b0;

    $display("data[0] sent");
    $display($time, " dataReady: %h dataIn: %b tx: %b %d", 
                        dataReady, dataIn, tx, dut.state);  

    for (int i = 0; i < 520; i++) begin // 2 DATA BIT
      @(posedge clock);
    end

    $display("data[1] sent");
    $display($time, " dataReady: %h dataIn: %b tx: %b %d", 
                        dataReady, dataIn, tx, dut.state);  

    for (int i = 0; i < 520; i++) begin // 3 DATA BIT
      @(posedge clock);
    end

    $display("data[2] sent");
    $display($time, " dataReady: %h dataIn: %b tx: %b %d", 
                        dataReady, dataIn, tx, dut.state);  

    for (int i = 0; i < 520; i++) begin // 4 DATA BIT
      @(posedge clock);
    end

    $display("data[3] sent");
    $display($time, " dataReady: %h dataIn: %b tx: %b %d", 
                        dataReady, dataIn, tx, dut.state);  

    for (int i = 0; i < 520; i++) begin // 5 DATA BIT
      @(posedge clock);
    end

    $display("data[4] sent");
    $display($time, " dataReady: %h dataIn: %b tx: %b %d", 
                        dataReady, dataIn, tx, dut.state);  

    for (int i = 0; i < 520; i++) begin // 6 DATA BIT
      @(posedge clock);
    end

    $display("data[5] sent");
    $display($time, " dataReady: %h dataIn: %b tx: %b %d", 
                        dataReady, dataIn, tx, dut.state);  

    for (int i = 0; i < 520; i++) begin // 7 DATA BIT
      @(posedge clock);
    end

    $display("data[6] sent");
    $display($time, " dataReady: %h dataIn: %b tx: %b %d", 
                        dataReady, dataIn, tx, dut.state);  

    for (int i = 0; i < 520; i++) begin // 8 DATA BIT
      @(posedge clock);
    end

    $display("data[7] sent");
    $display($time, " dataReady: %h dataIn: %b tx: %b %d", 
                        dataReady, dataIn, tx, dut.state);  

    for (int i = 0; i < 520; i++) begin // SEND STOP BIT
      @(posedge clock);
    end

    $display("stop sent");
    $display($time, " dataReady: %h dataIn: %b tx: %b %d", 
                        dataReady, dataIn, tx, dut.state);  

    for (int i = 0; i < 520; i++) begin // SEND STOP BIT
      @(posedge clock);
    end
    @(posedge clock);
    
    $finish;
  end

endmodule : TB

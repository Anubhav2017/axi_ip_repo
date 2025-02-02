

`timescale 1ns / 1ps


module tb();


bit                                     clock;
bit                                     reset;
bit init_read, init_write;


  axi_verif_top DUT(
      .start_write_txn(init_write),
      .start_read_txn(init_read),
      .clk(clock),
      .reset(reset)
    ); 
  
  initial begin
    reset <= 1'b1;
    #10ns;
    reset <= 1'b0;
    #10000ns;
  end
  always #5 clock <= ~clock;
  initial begin
    init_write = 0;
    init_read = 0;
    #200ns;
    init_write =1'b1;
    #20ns;
    init_write = 1'b0;
      #1000ns;
      init_read= 1'b1;
      #200ns
      init_read = 1'b0;
      $finish;
  end

endmodule

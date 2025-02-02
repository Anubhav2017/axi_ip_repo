module axi_verif_top
   (clk,
    reset,
    start_read_txn,
    start_write_txn);
  input clk;
  input reset;
  input start_read_txn;
  input start_write_txn;

  wire clk;
  reg [31:0]read_base_addr;
  reg rstn;
  wire rstn;
  wire start_read_txn;
  wire start_write_txn;
  reg [31:0]write_base_addr;
  reg [511:0]write_data;

  integer i;

  always_comb begin

    for(i=0; i<16;i++)
        write_data[i*32+:32] = i;

    read_base_addr = 32'hC0000000;
    write_base_addr = 32'hC0000000;

    rstn = ~reset;

  end
  axi_verif_bd_wrapper axi_verif_bd_wrapper_i
       (.clk(clk),
        .read_base_addr(read_base_addr),
        .rstn(rstn),
        .start_read_txn(start_read_txn),
        .start_write_txn(start_write_txn),
        .write_base_addr(write_base_addr),
        .write_data(write_data));
endmodule

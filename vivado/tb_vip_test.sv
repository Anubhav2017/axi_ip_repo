

`timescale 1ns / 1ps
`define BD_NAME axi_verif_bd
`define BD_INST_NAME axi_verif_bd_i
`define BD_WRAPPER axi_verif_bd_wrapper

import axi_vip_pkg::*;
import axi_verif_bd_axi_vip_0_0_pkg::*;

module tb();


xil_axi_uint                            error_cnt = 0;
xil_axi_uint                            comparison_cnt = 0;
axi_transaction                         wr_transaction;   
axi_transaction                         rd_transaction;   
axi_monitor_transaction                 mst_monitor_transaction;  
axi_monitor_transaction                 master_moniter_transaction_queue[$];  
xil_axi_uint                            master_moniter_transaction_queue_size =0;  
axi_monitor_transaction                 mst_scb_transaction;  
axi_monitor_transaction                 passthrough_monitor_transaction;  
axi_monitor_transaction                 passthrough_master_moniter_transaction_queue[$];  
xil_axi_uint                            passthrough_master_moniter_transaction_queue_size =0;  
axi_monitor_transaction                 passthrough_mst_scb_transaction;  
axi_monitor_transaction                 passthrough_slave_moniter_transaction_queue[$];  
xil_axi_uint                            passthrough_slave_moniter_transaction_queue_size =0;  
axi_monitor_transaction                 passthrough_slv_scb_transaction;  
axi_monitor_transaction                 slv_monitor_transaction;  
axi_monitor_transaction                 slave_moniter_transaction_queue[$];  
xil_axi_uint                            slave_moniter_transaction_queue_size =0;  
axi_monitor_transaction                 slv_scb_transaction;  
xil_axi_uint                           mst_agent_verbosity = 0;  
xil_axi_uint                           slv_agent_verbosity = 0;  
xil_axi_uint                           passthrough_agent_verbosity = 0;  
bit                                     clock;
bit                                     reset;
xil_axi_ulong                           mem_rd_addr;
xil_axi_ulong                           mem_wr_addr;
bit[32-1:0]                             write_data;
bit                                     write_strb[];
bit[32-1:0]                             read_data;
axi_verif_bd_axi_vip_0_0_slv_mem_t          slv_agent_0;
bit error_0;
bit done_0;
bit init_read, init_write;

logic [511:0] tx_data;

initial begin

integer i;
for(i=0;i<16;i=i+1) begin
    tx_data[i*32+:32] = i*8+3;
end

end

  `BD_WRAPPER DUT(
      .start_write_txn(init_write),
      .start_read_txn(init_read),
      .write_base_addr(32'h40000000),
      .read_base_addr(32'h40000000),
      .m00_axi_aclk(clock),
      .m00_axi_aresetn(reset), 
      .write_data(tx_data)
    ); 
  
initial begin
    slv_agent_0 = new("slave vip agent",DUT.`BD_INST_NAME.axi_vip_0.inst.IF);
    slv_agent_0.vif_proxy.set_dummy_drive_type(XIL_AXI_VIF_DRIVE_NONE);
    slv_agent_0.set_agent_tag("Slave VIP");
    slv_agent_0.set_verbosity(slv_agent_verbosity);
    slv_agent_0.start_slave();
     $timeformat (-12, 1, " ps", 1);
  end
  initial begin
    reset <= 1'b0;
    #200ns;
    reset <= 1'b1;
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
  initial begin
  #1;
    forever begin
      slv_agent_0.monitor.item_collected_port.get(slv_monitor_transaction);
      slave_moniter_transaction_queue.push_back(slv_monitor_transaction);
      slave_moniter_transaction_queue_size++;
    end
  end

endmodule

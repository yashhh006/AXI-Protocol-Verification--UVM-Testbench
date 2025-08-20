`include "uvm_pkg.sv"
import uvm_pkg::*;
`include "axi_comm.sv"
`include "axi_tx.sv"
`include "axi_intf.sv"
`include "axi_cov.sv"
`include "axi_drv.sv"
`include "axi_mon.sv"
`include "axi_responder.sv"
`include "axi_sqr.sv"
`include "axi_slave_agt.sv"
`include "axi_master_agt.sv"
`include "axi_sbd.sv"
`include "axi_env.sv"
`include "axi_seq_lib.sv"
`include "axi_test_lib.sv"

module top;

  bit rstn,clk;
  axi_intf pif(rstn,clk);

  initial begin
    clk=0;
	forever #5 clk=~clk;
  end
  
  initial begin
    rstn=0;
	repeat(2)@(posedge clk);
	rstn=1;
    //#1000;
    //$finish;
  end

  initial begin
    uvm_config_db#(virtual axi_intf)::set(null,"*","axi_intf",pif);
  end
  
  initial begin
    //run_test("axi_nwr_nrd_test");
    //run_test("axi_nwr_nrd_test_wrap");
    run_test("axi_nwr_nrd_test_incr");
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars(0, top);
  end
endmodule
interface axi_intf(input bit rstn,clk);
  
  //write channel
  bit [31:0] awaddr;
  bit [3:0] awid;
  bit [3:0] awlen;
  bit [2:0] awsize;
  bit [1:0] awburst;
  bit [1:0] awlock;
  bit [3:0] awcache;
  bit [2:0] awprot;
  bit awvalid;
  bit awready;
  bit [3:0] wid;
  bit [63:0] wdata;
  bit [7:0] wstrb;
  bit wlast;
  bit wvalid;
  bit wready;
  bit [3:0] bid;
  bit [1:0] bresp;
  bit [3:0] bvalid;
  bit [3:0] bready;
  
  //read channel
  bit [31:0] araddr;
  bit [3:0] arid;
  bit [3:0] arlen;
  bit [2:0] arsize;
  bit [1:0] arburst;
  bit [1:0] arlock;
  bit [3:0] arcache;
  bit [2:0] arprot;
  bit arvalid;
  bit arready;
  bit [3:0] rid;
  bit [31:0] rdata;
  bit rlast;
  bit rvalid;
  bit rready;
  bit [1:0] rresp;
  
  clocking cb_mon@(posedge clk);
    default input #1;
    input awaddr;
    input awid;
    input awlen;
    input awsize;
    input awburst;
    input awlock;
    input awcache;
    input awprot;
    input awvalid;
    input awready;
    input wid;
    input wdata;
    input wstrb;
    input wlast;
    input wvalid;
    input wready;
    input bid;
    input bresp;
    input bvalid;
    input bready;
    
    input araddr;
    input arid;
    input arlen;
    input arsize;
    input arburst;
    input arlock;
    input arcache;
    input arprot;
    input arvalid;
    input arready;
    input rid;
    input rdata;
    input rlast;
    input rvalid;
    input rready;
    input rresp;
  endclocking
    
endinterface
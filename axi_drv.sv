class axi_drv extends uvm_driver#(axi_tx);
  `new_comp
  `uvm_component_utils(axi_drv)
  
  //axi_sqr sqr;
  axi_tx tx;
  virtual axi_intf vif;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual axi_intf)::get(this,"","axi_intf",vif);
  endfunction
  
  task run();
    forever begin
      seq_item_port.get_next_item(req);
      drive_tx(req);
      seq_item_port.item_done();
    end
  endtask
  
  task drive_tx(axi_tx tx);
    //`uvm_info("DRIVER","driver is running",UVM_MEDIUM);
    if(tx.wr_rd==1)begin
      write_addr_phase(tx);
      write_data_phase(tx);
      write_rspn_phase(tx);
    end
    else begin
      read_addr_phase(tx);
      read_data_phase(tx);
    end
  endtask
  
  //write addr
  task write_addr_phase(axi_tx tx);
    
    if (tx == null) begin
      `uvm_error("DRV", "write_addr_phase: tx is null")
      return;
    end
    if (vif == null) begin
      `uvm_error("DRV", "write_addr_phase: vif is null")
      return;
    end
    
    @(posedge vif.clk);
    vif.awaddr =tx.addr; 
    //`uvm_info("WRITE ADDR",$psprintf("addr=%h",vif.awaddr),UVM_LOW)
    vif.awid   =tx.tx_id;
    vif.awlen  =tx.burst_len;
    vif.awsize =tx.burst_size;
    vif.awburst=tx.burst_type;
    vif.awlock =tx.lock;
    vif.awcache=tx.cache;
    vif.awprot =tx.prot;
    vif.awvalid=1'b1;
    wait(vif.awready==1'b1);
    @(posedge vif.clk);
    rstn_addr_write();
  endtask
  
  // write addr-rstn
  task rstn_addr_write();
    vif.awaddr =0;
    vif.awid   =0;
    vif.awlen  =0;
    vif.awsize =0;
    vif.awburst=0;
    vif.awlock =0;
    vif.awcache=0;
    vif.awprot =0;
    vif.awvalid=0;
    vif.awaddr =0;
  endtask
  
  //write data
  task write_data_phase(axi_tx tx);
    rstn_write_data(); 
    for(int i=0;i<=tx.burst_len;i++)begin
      @(posedge vif.clk);
      vif.wdata=tx.data.pop_front();
      //`uvm_info("WRITE DATA",$psprintf("data=%h",vif.wdata),UVM_LOW)
      vif.wstrb=tx.strb.pop_front();
      //`uvm_info("WRITE STROBE",$psprintf("strb=%0d",vif.wstrb),UVM_LOW)
      vif.wid=tx.tx_id;
      vif.wvalid=1;
      vif.wlast=(i==tx.burst_len)?1:0;
      //`uvm_info("WRITE WLAST",$psprintf("wlast=%d",vif.wlast),UVM_LOW)
      wait(vif.wready==1);
    end
    @(posedge vif.clk);
    rstn_write_data(); 
  endtask
  
  //write data-rstn
  task rstn_write_data();
    vif.wdata=0;
    vif.wstrb=0;
    vif.wid=0;
    vif.wvalid=0;
    vif.wlast=0;
    vif.wready=0;
  endtask
  
  //write responce
  task write_rspn_phase(axi_tx tx);
    
    if (tx == null) begin
      `uvm_error("DRV", "write_resp_phase: tx is null")
      return;
    end
    if (vif == null) begin
      `uvm_error("DRV", "write_resp_phase: vif is null")
      return;
    end
    
    while(vif.bvalid==0)
      @(posedge vif.clk);
    vif.bready=1;
    //`uvm_info("BVALID DRV",$psprintf("bready=%d",vif.bready),UVM_LOW)
    @(posedge vif.clk);
    vif.bready=0;
  endtask
  
  //read addr
  task read_addr_phase(axi_tx tx);
    @(posedge vif.clk);
    vif.araddr =tx.addr;
    //`uvm_info("READ ADDR",$psprintf("addr=%h",vif.araddr),UVM_LOW)
    vif.arid   =tx.tx_id;
    vif.arlen  =tx.burst_len;
    vif.arsize =tx.burst_size;
    vif.arburst=tx.burst_type;
    vif.arlock =tx.lock;
    vif.arcache=tx.cache;
    vif.arprot =tx.prot;
    vif.arvalid=1'b1;
    wait(vif.arready==1'b1);
    @(posedge vif.clk);
    rstn_addr_read();
  endtask
  
  //read addr-rstn
  task rstn_addr_read();
    vif.araddr =0;
    vif.arid   =0;
    vif.arlen  =0;
    vif.arsize =0;
    vif.arburst=0;
    vif.arlock =0;
    vif.arcache=0;
    vif.arprot =0;
    vif.arvalid=0;
    vif.araddr =0;
  endtask
  
  //read data
  task read_data_phase(axi_tx tx);
    for(int i=0;i<=tx.burst_len;i++)begin
      while(vif.rvalid==0)begin
        @(posedge vif.clk);
      end
      vif.rready=1;
      @(posedge vif.clk);
      vif.rready=0;
    end 
  endtask
  
endclass
class axi_responder extends uvm_component;
  axi_tx wr_tx;
  axi_tx rd_tx;
  virtual axi_intf vif;
  bit [7:0] mem[*];
  
  bit [7:0] strb_temp;
  `new_comp
  `uvm_component_utils(axi_responder)
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual axi_intf)::get(this,"","axi_intf",vif);
  endfunction
  
  task run();
    `uvm_info("RESPOND","responder is running",UVM_MEDIUM);
    
        wr_tx=new("wr_tx");
    forever begin
      @(posedge vif.clk);
      if(vif.awvalid==1)begin
        vif.awready=1;
        wr_tx.addr=vif.awaddr;
        //`uvm_info("WRITE AADR",$psprintf("writing at addr=%h",wr_tx.addr),UVM_LOW)
        wr_tx.tx_id=vif.awid;
        wr_tx.burst_len=vif.awlen;
        wr_tx.burst_size=vif.awsize;
        wr_tx.burst_type=vif.awburst;
        //wr_tx.strb.push_back(vif.wstrb);
        
      end
      
      if(vif.wvalid==1)begin
        vif.wready=1;
        #1;
        //`uvm_info("WRITE",$psprintf("writing at addr=%0d, data=%d",wr_tx.addr,vif.wdata),UVM_LOW)
        strb_temp=vif.wstrb;
        
        //for(int j=0;j<vif.awlen;j++)begin
          //@(posedge vif.clk);
        for(int i=0;i<$bits(strb_temp);i++)begin
          if(strb_temp[i])begin
            mem[wr_tx.addr]=vif.wdata[8*i +: 8];
            `uvm_info("MEMORY",$psprintf("Memory[%0d]=%h",
                                         wr_tx.addr,mem[wr_tx.addr]),UVM_LOW)
            wr_tx.addr++;
          end
          //else begin
            
        end
        //end
        
        //wr_tx.addr ++;
        if(vif.wlast==1)begin
          //`uvm_info("RSPN","in the responce loop",UVM_LOW)
          write_rspn(vif.wid);
        end
      end
      
      if(vif.arvalid==1)begin
        vif.arready=1;
        rd_tx=new("rd_tx");
        rd_tx.addr=vif.araddr;
        rd_tx.tx_id=vif.arid;
        rd_tx.burst_len=vif.arlen;
        rd_tx.burst_size=vif.arsize;
        rd_tx.burst_type=vif.arburst;
        read_data(vif.arid);
      end
    //`uvm_info("MEMORY AT RSPD",$psprintf("Memory=%p",mem),UVM_LOW)
    end
  endtask
  
  task write_rspn(bit [3:0]id);
    vif.bid=id;
    vif.bresp=EXOKAY;
    vif.bvalid=1;
    //`uvm_info("BVALID DRV ",$psprintf("bvalid=%d",vif.bvalid),UVM_LOW)
    wait(vif.bready==1);
    @(posedge vif.clk);
    vif.bid=0;
    vif.bresp=0;
    vif.bvalid=0;
  endtask
  
  task read_data(bit [3:0]id);
    for(int i=0;i<=rd_tx.burst_len;i++)begin
      @(posedge vif.clk);
      //$display("%t At the read data phase >> i=%0d",$time,i);
      vif.rdata=mem[rd_tx.addr];
      //`uvm_info("READ DATA",$psprintf("addr=%0d",vif.rdata),UVM_LOW)
      rd_tx.addr++;
      vif.rid=id;
      vif.rlast=(i==rd_tx.burst_len)? 1:0 ;
      vif.rvalid=1;
      wait(vif.rready==1);
    end
    @(posedge vif.clk);
    vif.rdata=0;
    vif.rid=0;
    vif.rlast=0;
    vif.rvalid=0;
  endtask
endclass
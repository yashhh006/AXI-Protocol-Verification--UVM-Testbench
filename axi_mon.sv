class axi_mon extends uvm_monitor;
  `uvm_component_utils(axi_mon)
  uvm_analysis_port#(axi_tx) ap_port;
  virtual axi_intf vif;
  axi_tx wr_tx,rd_tx;
  
  
  function new(string name="",uvm_component parent=null);
    super.new(name,parent);
    ap_port=new("ap_port",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual axi_intf)::get(this,"","axi_intf",vif);
  endfunction
  
  function void write(axi_tx t);
    
  endfunction
  
  task run_phase(uvm_phase phase);
    `uvm_info("MONITOR","monitor is running",UVM_MEDIUM);
    forever begin
      write_monitor();
      read_monitor();
    end
  endtask 
  
  task write_monitor();
    //axi_tx wr_tx;
    wr_tx=axi_tx::type_id::create("wr_tx");
    
    wait(vif.cb_mon.awvalid);
    @(vif.cb_mon);
    wr_tx.wr_rd=1'b1;
    wr_tx.addr=vif.cb_mon.awaddr;
    wr_tx.tx_id=vif.cb_mon.awid;
    wr_tx.burst_len=vif.cb_mon.awlen;
    wr_tx.burst_size=vif.cb_mon.awsize;
    wr_tx.burst_type=vif.cb_mon.awburst;
    wr_tx.lock=vif.cb_mon.awlock;
    wr_tx.cache=vif.cb_mon.awcache;
    wr_tx.prot=vif.cb_mon.awprot;
    //`uvm_info("MON",$psprintf("Addr=%0d AWlen=%0d", wr_tx.addr,wr_tx.burst_len),UVM_LOW)
    
    fork
      begin
        forever begin
          wait(vif.cb_mon.wvalid);
          @(vif.cb_mon);
          wr_tx.data.push_back(vif.cb_mon.wdata);
          wr_tx.strb.push_back(vif.cb_mon.wstrb);
          //`uvm_info("MON", $psprintf("Captured Data Beat: %0h", vif.cb_mon.wdata), UVM_LOW)
          //`uvm_info("MON",$psprintf("Data=%p", wr_tx.data),UVM_LOW)
          if (vif.cb_mon.wlast) begin
            wr_tx.wlast=vif.cb_mon.wlast;
            `uvm_info("MON", "WLAST detected, burst complete.", UVM_LOW)
            break; 
          end 
        end
        `uvm_info("MON",$psprintf("Data=%p", wr_tx.data),UVM_LOW)
      end

    
      begin
        wait(vif.cb_mon.bvalid);
        wr_tx.rspQ.push_back(vif.cb_mon.bresp);
        //wr_tx.print();
      end
    join
    `uvm_info("MON","Into the TLM",UVM_LOW)
    ap_port.write(wr_tx);
  endtask
  
  task read_monitor();
    //axi_tx wr_tx;
    rd_tx=axi_tx::type_id::create("wr_tx");
    
    wait(vif.cb_mon.arvalid);
    @(vif.cb_mon);
    rd_tx.wr_rd=1'b0;
    rd_tx.addr=vif.cb_mon.araddr;
    rd_tx.tx_id=vif.cb_mon.arid;
    rd_tx.burst_len=vif.cb_mon.arlen;
    rd_tx.burst_size=vif.cb_mon.arsize;
    rd_tx.burst_type=vif.cb_mon.arburst;
    rd_tx.lock=vif.cb_mon.arlock;
    rd_tx.cache=vif.cb_mon.arcache;
    rd_tx.prot=vif.cb_mon.arprot;
    `uvm_info("MON",$psprintf("ARaddr=%0d ARlen=%0d", rd_tx.addr,rd_tx.burst_len),UVM_LOW)
    
    fork
      begin
        forever begin
          wait(vif.cb_mon.rvalid);
          @(vif.cb_mon);
          rd_tx.data.push_back(vif.cb_mon.rdata);
          //`uvm_info("MON", $psprintf("Captured Data Beat: %0h", vif.cb_mon.rdata), UVM_LOW)
          `uvm_info("MON",$psprintf("Data=%p", rd_tx.data),UVM_LOW)
          if (vif.cb_mon.rlast) begin
            rd_tx.wlast=vif.cb_mon.rlast;
            `uvm_info("MON", "RLAST detected, burst complete.", UVM_LOW)
            break; 
          end 
        end
        `uvm_info("MON",$psprintf("RData=%p", rd_tx.data),UVM_LOW)
      end

    
      //begin
      //  wait(vif.cb_mon.rvalid);
      //  wr_tx.rspQ.push_back(vif.cb_mon.bresp);
      //  //wr_tx.print();
      //end
    join
    `uvm_info("MON","Into the Read TLM",UVM_LOW)
    ap_port.write(rd_tx);
  endtask
  
  task write_mon();
    wr_tx=new();
    fork
      begin
        
        wait(vif.awvalid);
          wr_tx.wr_rd=1'b1;
          wr_tx.addr=vif.awaddr;
          wr_tx.burst_len=vif.cb_mon.awlen;
          wr_tx.burst_size=vif.cb_mon.awsize;
          wr_tx.burst_type=vif.cb_mon.awburst;
          `uvm_info("MON",$psprintf("Addr=%0d",wr_tx.addr),UVM_LOW)
        
      end
      
      begin
        wait(vif.wvalid );
          wr_tx.data.push_back(vif.cb_mon.wdata);
          wr_tx.strb.push_back(vif.cb_mon.wstrb);
          wr_tx.print();
        
      end
      
    join
  endtask
  
  task read_mon();
    
  endtask
endclass

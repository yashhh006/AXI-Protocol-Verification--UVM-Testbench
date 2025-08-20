class axi_mon extends uvm_monitor;
  // ... new() and build_phase() are the same ...
  `uvm_component_utils(axi_mon)
  uvm_analysis_port#(axi_tx) ap_port;
  virtual axi_intf vif;
  
  function new(string name="",uvm_component parent=null);
    super.new(name,parent);
    ap_port=new("ap_port",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual axi_intf)::get(this,"","axi_intf",vif);
  endfunction

  // FIX #1: Use run_phase and fork..join_none
  task run_phase(uvm_phase phase);
    `uvm_info("MONITOR","monitor is running",UVM_MEDIUM);
    fork
      write_mon();
      read_mon();
    join_none
  endtask
  
  // FIX #2: The logic INSIDE the task must be sequential
  task write_mon();
    forever begin
      // The local variable is correct!
      axi_tx txn;

      // WAIT for the address phase
      @(vif.cb_mon iff (vif.cb_mon.awvalid && vif.cb_mon.awready));
      
      // NOW, create the object
      txn = axi_tx::type_id::create("write_txn");
      txn.wr_rd = 1'b1;
      txn.addr  = vif.cb_mon.awaddr;
      // ... get all other aw channel signals ...
      
      // THEN, loop to collect all data beats
      for (int i = 0; i <= txn.burst_len; i++) begin
        @(vif.cb_mon iff (vif.cb_mon.wvalid && vif.cb_mon.wready));
        txn.data.push_back(vif.cb_mon.wdata);
        txn.strb.push_back(vif.cb_mon.wstrb);
      end

      // FINALLY, wait for the response
      @(vif.cb_mon iff (vif.cb_mon.bvalid && vif.cb_mon.bready));
      txn.rspQ.push_back(vif.cb_mon.bresp);
      
      // Transaction is complete. Send it.
      ap_port.write(txn);
    end
  endtask
  
  task read_mon();
    forever begin
      // 1. Declare a LOCAL variable for each new read transaction.
      axi_tx txn;
  
      // 2. Wait for the beginning of a read transaction's address phase.
      @(vif.cb_mon iff (vif.cb_mon.arvalid && vif.cb_mon.arready));
      
      // 3. Create the object and collect the address information.
      txn = axi_tx::type_id::create("read_txn");
      txn.wr_rd       = 1'b0; // This is a read
      txn.addr        = vif.cb_mon.araddr;
      txn.tx_id       = vif.cb_mon.arid;
      txn.burst_len   = vif.cb_mon.arlen;
      txn.burst_size  = vif.cb_mon.arsize;
      txn.burst_type  = vif.cb_mon.arburst;
      txn.lock        = vif.cb_mon.arlock;
      txn.cache       = vif.cb_mon.arcache;
      txn.prot        = vif.cb_mon.arprot;
        
      // 4. Loop to collect all the read data beats for THIS transaction.
      for (int i = 0; i <= txn.burst_len; i++) begin
        @(vif.cb_mon iff (vif.cb_mon.rvalid && vif.cb_mon.rready));
        txn.data.push_back(vif.cb_mon.rdata);
        txn.rspQ.push_back(vif.cb_mon.rresp);
        
        // Optional check to ensure burst length matches rlast signal
        if (i == txn.burst_len) begin
          if (vif.cb_mon.rlast != 1) begin
            `uvm_error(get_type_name(), "RLAST was not asserted on the final beat of the read burst.")
          end
        end
      end
  
      // 5. Read transaction is now complete. Send it to the analysis port.
      //`uvm_info(get_type_name(), $sformatf("SENDING READ TXN:\n%s", txn.sprint()), UVM_MEDIUM)
      ap_port.write(txn);
    end
  endtask
endclass
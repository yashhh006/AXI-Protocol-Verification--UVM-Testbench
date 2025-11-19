class axi_cov extends uvm_subscriber#(axi_tx);
  `uvm_component_utils(axi_cov)
  axi_tx tx;
  
  covergroup cg_wr;
    write_cg:coverpoint tx.wr_rd{
      bins WR={1'b1};
      bins RD={1'b0};
    }
    
    addr_cg:coverpoint tx.addr{
      option.auto_bin_max=2;
    }
    
    id_cg:coverpoint tx.tx_id{
      option.auto_bin_max=4;
    }
    
    burst_len_cg:coverpoint tx.burst_len{
      option.auto_bin_max=4;
    }
    
    burst_type_cg:coverpoint tx.burst_type{
      bins fixed={2'b00};
      bins incr={2'b01};
      bins wrap={2'b10};
      bins rsvd={2'b11};
    }
    
    burst_size_cg:coverpoint tx.burst_size{
      option.auto_bin_max=4; 
    }
  endgroup
  
  covergroup cg_rd;
    write_cg_rd:coverpoint tx.wr_rd{
      bins WR={1'b1};
      bins RD={1'b0};
    }
    
    addr_cg_rd:coverpoint tx.addr{
      option.auto_bin_max=2;
    }
    
    id_cg_rd:coverpoint tx.tx_id{
      option.auto_bin_max=16;
    }
    
    burst_len_cg_rd:coverpoint tx.burst_len{
      option.auto_bin_max=4;
    }
    
    burst_type_cg_rd:coverpoint tx.burst_type{
      bins fixed={2'b00};
      bins incr={2'b01};
      bins wrap={2'b10};
      bins rsvd={2'b11};
    }
    
    burst_size_cg_rd:coverpoint tx.burst_size{
      option.auto_bin_max=4; 
    }
  endgroup
  
  function new(string name="",uvm_component parent);
    super.new(name,parent);
    cg_wr=new();
    cg_rd=new();
  endfunction
  
  //TLM method > must be implemented in the cov class
  function void write(axi_tx t);
    this.tx=t;   
    //`uvm_info("COVERAGE", $sformatf("Sampled %s tx: id=%0h", tx.wr_rd ? "write" : "read", tx.tx_id), UVM_MEDIUM)
    if(tx.wr_rd==1)
      cg_wr.sample();
    else
      cg_rd.sample();
  endfunction
  
  function void report_phase(uvm_phase phase);
    
    `uvm_info(get_full_name(),$sformatf("WR Channel Coverage is %0.2f %%",
                                       cg_wr.get_coverage()),UVM_LOW);
    `uvm_info(get_full_name(),$sformatf("Wr_Addr Coverage is %0.2f %%",
                                       cg_wr.addr_cg.get_coverage()),UVM_LOW);
    `uvm_info(get_full_name(),$sformatf("Wr_Write Coverage is %0.2f %%",
                                      cg_wr.write_cg.get_coverage()),UVM_LOW);
    `uvm_info(get_full_name(),$sformatf("Wr_Bur_Len Coverage is %0.2f %%",                                      cg_wr.burst_len_cg.get_coverage()),UVM_LOW);
    `uvm_info(get_full_name(),$sformatf("Wr_Bur_Type Coverage is %0.2f %%",                                      cg_wr.burst_type_cg.get_coverage()),UVM_LOW);
    
    `uvm_info(get_full_name(),$sformatf("RD Channel Coverage is %0.2f %%",
                                       cg_rd.get_coverage()),UVM_LOW);
    `uvm_info(get_full_name(),$sformatf("Rd_Addr Coverage is %0.2f %%", cg_rd.addr_cg_rd.get_coverage()),UVM_LOW);
    `uvm_info(get_full_name(),$sformatf("Rd_Write Coverage is %0.2f %%", cg_rd.write_cg_rd.get_coverage()),UVM_LOW);
    `uvm_info(get_full_name(),$sformatf("Rd_Bur_Len Coverage is %0.2f %%",                                      cg_rd.burst_len_cg_rd.get_coverage()),UVM_LOW);
    `uvm_info(get_full_name(),$sformatf("Rd_Bur_Type Coverage is %0.2f %%", cg_rd.burst_type_cg_rd.get_coverage()),UVM_LOW);
  endfunction
endclass

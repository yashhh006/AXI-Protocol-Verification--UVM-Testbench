class axi_master_agt extends uvm_agent;
  axi_drv drv;
  axi_sqr sqr;
  axi_mon mon;
  axi_cov cov;
  
  `uvm_component_utils(axi_master_agt);
  `new_comp
  
  function void build_phase(uvm_phase phase);
    drv=axi_drv::type_id::create("drv",this);
    sqr=axi_sqr::type_id::create("sqr",this);
    mon=axi_mon::type_id::create("mon",this);
    cov=axi_cov::type_id::create("cov",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
    mon.ap_port.connect(cov.analysis_export);
  endfunction
endclass
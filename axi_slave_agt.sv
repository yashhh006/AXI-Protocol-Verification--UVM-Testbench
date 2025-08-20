class axi_slave_agt extends uvm_agent;
  axi_mon mon;
  axi_responder rsp;
  
  `uvm_component_utils(axi_slave_agt);
  `new_comp
  
  function void build_phase(uvm_phase phase);
    mon=axi_mon::type_id::create("mon",this);
    rsp=axi_responder::type_id::create("rsp",this);
  endfunction
endclass
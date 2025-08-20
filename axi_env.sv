class axi_env extends uvm_env;
  `uvm_component_utils(axi_env);
  
  axi_master_agt m_agt;
  axi_slave_agt s_agt;
  axi_sbd sbd;
  
  `new_comp
  //function new(string name="",uvm_component parent);
  //  super.new(name,parent);
  //  sbd_imp=new("sbd_imp",this);
  //endfunction
  
  function void build_phase(uvm_phase phase);
    m_agt=axi_master_agt::type_id::create("m_agt",this);
    s_agt=axi_slave_agt::type_id::create("s_agt",this);
    sbd=axi_sbd::type_id::create("sbd",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    s_agt.mon.ap_port.connect(sbd.sbd_imp);
  endfunction
endclass
class axi_test_lib extends uvm_test;
  axi_env env;
  
  `uvm_component_utils(axi_test_lib)
  `new_comp
  
  function void build();
    env=axi_env::type_id::create("env",this);
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
endclass

class axi_nwr_nrd_test extends axi_test_lib;
  `new_comp
  `uvm_component_utils(axi_nwr_nrd_test)
  int count;
  
  function void build_phase(uvm_phase phase);
    super.build();
    uvm_resource_db#(int)::set("GLOBAL","count",10,this);
    
    //// Set message actions
    //env.m_agt.set_report_severity_action(UVM_ERROR, UVM_DISPLAY | UVM_COUNT);
    //env.m_agt.set_report_id_action("AXI_MON", UVM_LOG | UVM_DISPLAY);
    //
    //// Set global verbosity to UVM_MEDIUM
    //uvm_top.set_report_verbosity_level(UVM_MEDIUM);
//
    //// Set specific verbosity for AXI agent hierarchy
    //env.m_agt.set_report_verbosity_level_hier(UVM_HIGH);
//
    //// Set verbosity for specific message ID in monitor
    //env.m_agt.drv.set_report_id_verbosity("BVALID DRV", UVM_HIGH);
    //
    //// Set message actions
    //env.m_agt.set_report_severity_action(UVM_INFO, UVM_DISPLAY | UVM_COUNT);
    //env.m_agt.set_report_id_action("BVALID DRV", UVM_LOG | UVM_DISPLAY);
    //env.s_agt.set_report_id_action("MEMORY", UVM_LOG | UVM_DISPLAY);
  endfunction
  
  task run_phase(uvm_phase phase);
    axi_nwr_nrd nwr_nrd;
    nwr_nrd=axi_nwr_nrd::type_id::create("nwr_nrd");
    phase.raise_objection(this);
    phase.phase_done.set_drain_time(this,100);
    nwr_nrd.start(env.m_agt.sqr);
    phase.drop_objection(this);
  endtask
endclass

class axi_nwr_nrd_test_wrap extends axi_test_lib;
  `new_comp
  `uvm_component_utils(axi_nwr_nrd_test_wrap)
  int count;
  
  function void build();
    super.build();
    uvm_resource_db#(int)::set("GLOBAL","count",5,this);
  endfunction
  
  task run_phase(uvm_phase phase);
    axi_nwr_nrd_wrap nwr_nrd;
    nwr_nrd=axi_nwr_nrd_wrap::type_id::create("nwr_nrd");
    phase.raise_objection(this);
    phase.phase_done.set_drain_time(this,100);
    nwr_nrd.start(env.m_agt.sqr);
    phase.drop_objection(this);
  endtask
endclass

class axi_nwr_nrd_test_incr extends axi_test_lib;
  `new_comp
  `uvm_component_utils(axi_nwr_nrd_test_incr)
  int count;
  
  function void build();
    super.build();
    uvm_resource_db#(int)::set("GLOBAL","count",5,this);
  endfunction
  
  task run_phase(uvm_phase phase);
    axi_nwr_nrd_incr nwr_nrd;
    nwr_nrd=axi_nwr_nrd_incr::type_id::create("nwr_nrd");
    phase.raise_objection(this);
    phase.phase_done.set_drain_time(this,100);
    nwr_nrd.start(env.m_agt.sqr);
    phase.drop_objection(this);
  endtask
endclass
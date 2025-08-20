class axi_sbd extends uvm_scoreboard;
  `uvm_component_utils(axi_sbd);
  uvm_analysis_imp #(axi_tx,axi_sbd) sbd_imp;
  axi_tx tx;
  bit [7:0] mem2[*];
  
  function new(string name="",uvm_component parent=null);
    super.new(name,parent);
    sbd_imp=new("sbd_imp",this);
  endfunction
  
  function void write(axi_tx t);
    this.tx=t;
    if(tx.wr_rd==1)begin
      //for(int i=0;i<tx.burst_len;i++)begin
        mem2[tx.addr]=tx.data.pop_front();
        `uvm_info("SBD",$psprintf("MEM2[%0d]=%h",tx.addr,mem2[tx.addr]),UVM_LOW)
        
      //end
    end
    
  endfunction
endclass
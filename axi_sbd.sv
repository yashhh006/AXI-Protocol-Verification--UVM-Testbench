class axi_sbd extends uvm_scoreboard;
  `uvm_component_utils(axi_sbd);
  uvm_analysis_imp #(axi_tx,axi_sbd) sbd_imp;
  axi_tx tx;
  bit [7:0] mem2[*];
  bit [7:0] strb_temp2;
  bit [63:0] data_temp;
  int addr_temp;
  
  function new(string name="",uvm_component parent=null);
    super.new(name,parent);
    sbd_imp=new("sbd_imp",this);
  endfunction
  
  function void write(axi_tx t);
    this.tx=t;
    addr_temp=tx.addr;
    for(int j=0;j<=tx.burst_len;j++)begin
      strb_temp2=tx.strb.pop_front();
      data_temp=tx.data.pop_front();
      if(j==0)data_temp=tx.data.pop_front();
      
      `uvm_info("SBD",$psprintf("Data_T=%h Strb_T=%b",data_temp,strb_temp2), UVM_LOW)
      for(int i=0;i<7;i++)begin
        if(strb_temp2[i])begin
          mem2[addr_temp]=data_temp[8*i +: 8];
          `uvm_info("MEMORY",$psprintf("Memory SBD[%0d]=%h",
                                       addr_temp,mem2[addr_temp]),UVM_LOW)
          addr_temp++;
        end
      end
      strb_temp2=0;
      data_temp=0;
    end
    addr_temp=0;
  endfunction
endclass

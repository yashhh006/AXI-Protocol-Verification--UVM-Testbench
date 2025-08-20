// THIS IS THE TXN CLASS OF THE STROBE
// THEREFORE THIS TESTBENCH IS FOR NARROW TRANSFERS ONLY

//TO CHANGE THIS TO NORMAL CHANGE THE DATA SIZE BY 32 BIT BELOW BY UNCOMMENTING

class axi_tx extends uvm_sequence_item;
  
  //addr_channel
  rand bit wr_rd;
  rand bit [31:0] addr;
  rand bit[3:0] tx_id;
  rand bit[3:0] burst_len;
  rand bit[2:0] burst_size;
  rand bit[1:0] burst_type;
  rand bit[1:0] lock;
  rand bit[3:0] cache;
  rand bit[1:0] prot;
  
  //data channel
  rand bit[63:0]data[$];
  //rand bit[31:0]data[$];
  rand bit[7:0] strb[$];
  rand bit[1:0] rspQ[$];
  rand int k;
  
  `new_obj
  `uvm_object_utils_begin(axi_tx)
    `uvm_field_int(addr,UVM_ALL_ON)
    `uvm_field_int(tx_id,UVM_ALL_ON)
    `uvm_field_int(burst_len,UVM_ALL_ON)
    `uvm_field_int(burst_size,UVM_ALL_ON)
    `uvm_field_int(burst_type,UVM_ALL_ON)
    `uvm_field_int(lock,UVM_ALL_ON)
    `uvm_field_int(cache,UVM_ALL_ON)
    `uvm_field_int(prot,UVM_ALL_ON)
    `uvm_field_queue_int(data,UVM_ALL_ON)
    `uvm_field_queue_int(strb,UVM_ALL_ON)
    `uvm_field_queue_int(rspQ,UVM_ALL_ON)
  `uvm_object_utils_end
  
  function void post_randomize();
    foreach(strb[i])begin
      strb[i]=0;
      for(int j=k;j<(k+4);j++)begin
        strb[i][j]=1;
      end
    end
  endfunction
        
  
  constraint rsvd_c{
    burst_type !=2'b11;
    lock!=2'b11;
  }
  
  
  constraint data_c{
    data.size() == burst_len+1;
    strb.size() == burst_len+1;
    k inside {[0:4]};
  }
  
  constraint soft_c{
    soft burst_type == WRAP;
    soft burst_size == 2;    // 4 bytes/beat
    soft addr%4 == 0;        //alligned transfer
  }
endclass
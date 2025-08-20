class axi_seq_lib extends uvm_sequence#(axi_tx);
  uvm_phase phase;
  `uvm_object_utils(axi_seq_lib)
  `new_obj
  axi_tx tx,temp;
  axi_tx txQ[$];
  int count;
  
  task pre_body();
    phase=get_starting_phase();
    if(phase!=null)begin
      phase.raise_objection(this);
      phase.phase_done.set_drain_time(this,100);
    end
  endtask
  
  task body();
    uvm_resource_db#(int)::read_by_name("GLOBAL","count",count,this);
  endtask
  
  task post_body();
    if(phase!=null)begin
      phase.drop_objection(this);
    end
  endtask
endclass

class axi_nwr_nrd extends axi_seq_lib;
  `uvm_object_utils(axi_nwr_nrd)
  `new_obj
  
  task body();
    super.body();
    tx = axi_tx::type_id::create("tx");
    //write txn
    repeat(count)begin
      `uvm_do_with(req, {req.wr_rd==1;
                         req.burst_len==6;
                         req.burst_type==RSVD;
                        })
      txQ.push_back(req);
    end
    
    //read txn
    repeat(count)begin
      temp=txQ.pop_front();
      `uvm_do_with(req,{req.wr_rd==0;
                        req.addr==temp.addr;
                        req.burst_len==temp.burst_len;
                        req.burst_size==temp.burst_size;
                        req.burst_type==temp.burst_type;
                       })
    end
  endtask
endclass

class axi_nwr_nrd_wrap extends axi_seq_lib;
  `uvm_object_utils(axi_nwr_nrd_wrap)
  `new_obj
  
  task body();
    super.body();
    tx = axi_tx::type_id::create("tx");
    //write txn
    for(int i=0;i<count;i++)begin
      `uvm_do_with(req, {req.wr_rd==1;
                         req.burst_len==4;
                         req.addr==1;
                         req.burst_type==WRAP;
                        })
      txQ.push_back(req);
      //req.print();
    end
    
    `uvm_info("SEQ",$psprintf("Strobe =%p",req.strb),UVM_LOW)
    
    //read txn
    repeat(count)begin
      temp=txQ.pop_front();
      `uvm_do_with(req,{req.wr_rd==0;
                        req.tx_id==temp.tx_id;
                        req.addr==temp.addr;
                        req.burst_len==temp.burst_len;
                        req.burst_size==temp.burst_size;
                        req.burst_type==temp.burst_type;
                       })
    end
  endtask
endclass

class axi_nwr_nrd_incr extends axi_seq_lib;
  `uvm_object_utils(axi_nwr_nrd_incr)
  `new_obj
  
  task body();
    super.body();
    tx = axi_tx::type_id::create("tx");
    //write txn
    for(int i=0;i<count;i++)begin
      `uvm_do_with(req, {req.wr_rd==1;
                         req.burst_len==4;
                         req.addr==((req.burst_len+1)*(2**req.burst_size))*i;
                         req.burst_type==INCR;
                        })
      txQ.push_back(req);
      //req.print();
    end
    
    `uvm_info("SEQ",$psprintf("Strobe =%p",req.strb),UVM_LOW)
    
    //read txn
    repeat(count)begin
      temp=txQ.pop_front();
      `uvm_do_with(req,{req.wr_rd==0;
                        req.tx_id==temp.tx_id;
                        req.addr==temp.addr;
                        req.burst_len==temp.burst_len;
                        req.burst_size==temp.burst_size;
                        req.burst_type==temp.burst_type;
                       })
    end
  endtask
endclass
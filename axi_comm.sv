`define new_comp \
function new(string name="",uvm_component parent); \
  super.new(name,parent); \
endfunction

`define new_obj \
function new(string name="" ); \
  super.new(name); \
endfunction 

typedef enum bit [1:0]{
  FIXED,
  WRAP,
  INCR,
  RSVD
}burst_type_t;

typedef enum bit [1:0]{
  NORMAL,
  EXCL,
  LOCKED,
  RSVD_LOCK
}lock_t;

typedef enum bit [1:0]{
  OKAY,
  EXOKAY,
  SLVERR,
  DECERR
}resp_type_t;
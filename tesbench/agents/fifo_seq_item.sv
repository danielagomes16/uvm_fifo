/*
Author:   Daniela Gomes Ramalho
Email:    danielagramalho16@gmail.com
Description:
*/

class fifo_seq_item #(parameter data_size = 8) extends uvm_sequence_item;
  // input signals
  rand logic [data_size-1:0] data_in;
  rand logic write_en;
  rand logic read_en;

  // output signals
  logic [data_size-1:0] data_out;
  logic fifo_full;
  logic fifo_empty;

  `uvm_object_param_utils_begin(fifo_seq_item #(.data_size(data_size)))
    // Use uvm_field_int for logic fields
    // The `uvm_field_* macros are invoked inside of the `uvm_*_utils_begin
    // and `uvm_*_utils_end macro blocks to form “automatic” implementations 
    // of the core data methods: copy, compare, pack, unpack, record, print, and sprint.
   	`uvm_field_int(data_in, UVM_ALL_ON)
 	  `uvm_field_int(write_en, UVM_ALL_ON)
 	  `uvm_field_int(read_en, UVM_ALL_ON)
 	  `uvm_field_int(data_out, UVM_ALL_ON)
 	  `uvm_field_int(fifo_full, UVM_ALL_ON)
 	  `uvm_field_int(fifo_empty, UVM_ALL_ON)
   `uvm_object_utils_end  
 
  constraint op_enable {(write_en != read_en);}
  
  function new(string name = "fifo_seq_item");
    super.new(name);
  endfunction 
  
  virtual function void do_copy(uvm_object rhs);
    fifo_seq_item #(data_size) rhs_;
    if (!$cast(rhs_,rhs)) begin // to make sure that the objects have the same type
      `uvm_fatal("fifo_seq_item","cast of the rhs object failed!")
    end  
    
    super.do_copy(rhs);
    this.data_in    = rhs_.data_in;
    this.write_en   = rhs_.write_en;
    this.read_en    = rhs_.read_en;
    this.data_out   = rhs_.data_out;
    this.fifo_full  = rhs_.fifo_full;
    this.fifo_empty = rhs_.fifo_empty;
    
  endfunction
  
   virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    fifo_seq_item #(.data_size(data_size)) rhs_;
    int result = 1;
    
    if (!$cast(rhs_,rhs))begin // to make sure that the objects have the same type
      `uvm_fatal("fifo_seq_item","cast of the rhs object failed!")
      return 0;
    end  
    
    result = (super.do_compare(rhs, comparer) &&
             (this.data_out == rhs_.data_out) &&
             (this.fifo_full == rhs_.fifo_full) &&
             (this.fifo_empty == rhs_.fifo_empty)
    );
    
    if (this.data_out != rhs_.data_out) begin
      `uvm_error("MISARCH", $sformatf("data_out signal did not match"))
      result = 0;
    end


    if (this.fifo_full != rhs_.fifo_full) begin
      `uvm_error("MISARCH", $sformatf("fifo_full signal did not match"))
      result = 0;
    end

    
    if (this.fifo_empty != rhs_.fifo_empty) begin
      `uvm_error("MISARCH", $sformatf("fifo_empty signal did not match"))
      result = 0;
    end
    
    return result;
   
  endfunction
  
  
endclass
/*
Author:   Daniela Gomes Ramalho
Email:    danielagramalho16@gmail.com
Description: reference model
*/

class fifo_ref_model#(parameter data_size = 8) extends uvm_component;
  
  `uvm_component_param_utils(fifo_ref_model#(.data_size(data_size)))
                             
  int write_ptr;
  int read_ptr;
  int counter;
  
  logic fifo_full;
  logic fifo_empty;
                             
  logic [data_size-1:0] memory [data_size-1:0];                             
  logic [data_size-1:0] data_out;
                            
  function new (string name = "", uvm_component parent);
    super.new(name,parent);
    write_ptr  = 0;
    read_ptr   = 0;
    fifo_full  = 0;
    fifo_empty = 0;    
    counter    = 0;
  endfunction

  function void reset(fifo_seq_item#(.data_size(data_size)) outputs=null);
     outputs.data_out   = 0;
     outputs.fifo_full  = 0;
     outputs.fifo_empty = 0;
    
     write_ptr  = 0;
     read_ptr   = 0;
     fifo_full  = 0;
     fifo_empty = 1; 
     counter    = 0;
    
     data_out = 0;
     for(int i = 0; i < data_size; i++) begin
       memory[i] = 0;
     end
   endfunction
                             
        
  task check_fifo( fifo_seq_item#(.data_size(data_size))  seq_in,
                   fifo_seq_item#(.data_size(data_size))  seq_out);
    
    if (seq_in.write_en && fifo_full == 0) begin
      memory[write_ptr] = seq_in.data_in;
      write_ptr = write_ptr + 1;
      counter  = counter + 1;
      fifo_empty = 0;
    end
        
    if (seq_in.read_en && fifo_empty == 0) begin
      data_out = memory[read_ptr];
      read_ptr = read_ptr + 1;
      counter  = counter - 1;
    end
    
    
    if (counter == 0) begin
      fifo_empty = 1;
    end
    else if (counter == data_size-1) begin
      fifo_full = 1;
    end
    else begin
      fifo_empty = 0;
      fifo_full  = 0;
    end
    

    seq_out.data_out    = data_out;
    seq_out.fifo_full   = fifo_full;
    seq_out.fifo_empty  = fifo_empty;  
    
    `uvm_info("ref_model", $sformatf("\n Ref model Outputs: fifo_full=%0d, fifo_empty=%0d",fifo_full ,fifo_empty), UVM_INFO);    
   
  endtask

  
endclass
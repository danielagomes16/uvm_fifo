/*
Author:   Daniela Gomes Ramalho
Email:    danielagramalho16@gmail.com
Description: Sequence generates the stimulus
 and sends to driver via sequencer.
*/

class fifo_base_seq #(parameter data_size=8) extends uvm_sequence #(fifo_seq_item #(.data_size(data_size)));

  `uvm_object_param_utils(fifo_base_seq #(.data_size(data_size)))

  fifo_seq_item #(.data_size(data_size)) req;
  
  function new(string name="fifo_base_seq");
 	super.new(name);
  endfunction
  
  virtual task body();

 	req = fifo_seq_item #(.data_size(data_size))::type_id::create("req");
  
    start_item(req);
    assert(req.randomize() with {write_en == 1;read_en == 0;});
 	  // Debugging: print values after randomization
    `uvm_info("SEQ", $sformatf("\n Fifo inputs : write=%0d, read=%0d, data=%0d",req.write_en, req.read_en, req.data_in), UVM_INFO);
	finish_item(req);
 
  endtask 

endclass  
/*
Author:   Daniela Gomes Ramalho
Email:    danielagramalho16@gmail.com
Description: Sequencer is written by extending 
uvm_sequencer, there is no extra logic required 
to be added in the sequencer.
*/

class fifo_sequencer #(parameter data_size  = 8) extends uvm_sequencer #(fifo_seq_item #(
    .data_size(data_size)));
    
    `uvm_component_param_utils(fifo_sequencer #(
        .data_size(data_size)))
    
    function new(string name = "fifo_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
    

endclass
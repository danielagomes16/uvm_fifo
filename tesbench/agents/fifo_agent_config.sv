/*
Author:   Daniela Gomes
Email:    danielagramalho16@gmail.com
Description: agent configuration class
*/

class fifo_agent_config #(parameter data_size=8) extends uvm_object;
  
  `uvm_object_utils(fifo_agent_config)
  
  uvm_active_passive_enum active = UVM_ACTIVE;
  
  virtual fifo_if vif;
  
  function new(string name="fifo_agent_config");
    super.new(name);
  endfunction
  
endclass
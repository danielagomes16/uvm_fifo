/*
Author:   Daniela Gomes Ramalho
Email:    danielagramalho16@gmail.com
Description: The environment is the container class,
It contains one or more agents, as well as other 
components such as the scoreboard, top-level monitor,
 and checker.
*/

class fifo_env#(parameter data_size=8) extends uvm_env;
  
  `uvm_component_param_utils(fifo_env#(.data_size(data_size)))
  
  fifo_agent#(.data_size(data_size))       fifo_agt;
  fifo_scoreboard#(.data_size(data_size))  fifo_scb;

  function new(string name = "gate_env", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    fifo_agt = fifo_agent#(.data_size(data_size))::type_id::create("fifo_agt",this);
    fifo_scb = fifo_scoreboard#(.data_size(data_size))::type_id::create("fifo_scbv",this);
  endfunction 
  
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    fifo_agt.mon.in_ap.connect(fifo_scb.in_transactions.analysis_export);
    fifo_agt.mon.out_ap.connect(fifo_scb.out_transactions.analysis_export);
  endfunction

  
endclass
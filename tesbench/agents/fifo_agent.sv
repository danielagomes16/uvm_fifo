/*
Author:   Daniela Gomes Ramalho
Email:    danielagramalho16@gmail.com
Description: An agent is a container class 
contains a driver, a sequencer, and a monitor.
*/

class fifo_agent #(parameter data_size = 8) extends uvm_agent;  
  
  `uvm_component_param_utils(fifo_agent #(.data_size(data_size)))
  
  uvm_analysis_port #(fifo_seq_item #(.data_size(data_size))) in_ap;
  uvm_analysis_port #(fifo_seq_item #(.data_size(data_size))) out_ap; 

  fifo_monitor #(.data_size(data_size))       mon;
  fifo_driver #(.data_size(data_size))        drv;
  fifo_agent_config #(.data_size(data_size))  cfg;
  fifo_sequencer #(.data_size(data_size))     sqr;
  
  function new(string name = "fifo_agent", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg = fifo_agent_config #(.data_size(data_size))::type_id::create("cfg",this);

    if (!uvm_config_db#(fifo_agent_config #(.data_size(data_size)))::get(this, "", "cfg", cfg))
      `uvm_fatal(get_type_name(), "fifo_agent_config not set")       
    
    if(cfg.active == UVM_ACTIVE) begin
      sqr = fifo_sequencer #(.data_size(data_size))::type_id::create("sqr",this);
      drv = fifo_driver #(.data_size(data_size))::type_id::create("drv",this);      
    end
    mon = fifo_monitor #(.data_size(data_size))::type_id::create("mon",this);
  endfunction
  
  
  function void connect_phase(uvm_phase phase);
  	super.connect_phase(phase);
    mon.vif = cfg.vif;
    if(get_is_active == UVM_ACTIVE) begin
 		drv.seq_item_port.connect(sqr.seq_item_export);
        drv.vif = cfg.vif;
 	end
  endfunction

  
endclass
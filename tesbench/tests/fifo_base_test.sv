/*
Author:   Daniela Gomes Ramalho
Email:    danielagramalho16@gmail.com
Description: The test defines the test 
scenario for the testbench.
*/

class fifo_base_test extends uvm_test;
  
  `uvm_component_utils(fifo_base_test)
  
  virtual fifo_if#(.data_size(data_size)) vif;  
  
  fifo_env#(.data_size(data_size)) env;
  fifo_base_seq#(.data_size(data_size)) seq;
  fifo_agent_config#(.data_size(data_size)) cfg;  

  function new(string name="fifo_base_test", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_env#(.data_size(data_size))::type_id::create("env",this);
    cfg = fifo_agent_config#(.data_size(data_size))::type_id::create("cfg",this);

    // Using the get method to get a virtual interface handle from a database and assigns 
    // it to vif. If the get method fails, the fatal message will be displayed.
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Virtual interface not set")   
 
    cfg.vif = vif;
    cfg.active = UVM_ACTIVE;   

    uvm_config_db #(fifo_agent_config#(.data_size(data_size)))::set(this,"*","cfg",cfg);

  endfunction
    
  task main_phase(uvm_phase phase);
    void'(super.randomize());
 	  phase.raise_objection(this);
 	  seq = fifo_base_seq#(.data_size(data_size))::type_id::create("seq");
    seq.start(env.fifo_agt.sqr);
   	phase.drop_objection(this);
    `uvm_info(get_type_name(),"END OF TESTCASE", UVM_INFO);
  endtask

  function void end_of_elaboration_phase(uvm_phase phase);
 	  uvm_top.print_topology();
  endfunction

endclass

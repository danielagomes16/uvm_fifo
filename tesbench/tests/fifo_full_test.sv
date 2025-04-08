/*
Author:   Daniela Gomes Ramalho
Email:    danielagramalho16@gmail.com
Description: The test defines the test 
scenario for the testbench.
*/

class fifo_full_test extends fifo_base_test;
  
  `uvm_component_utils(fifo_full_test)
  
 fifo_full_seq#(.data_size(data_size)) full_seq;

 function new(string name="fifo_full_test", uvm_component parent);
   super.new(name,parent);
 endfunction

 function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   full_seq = fifo_full_seq#(.data_size(data_size))::type_id::create("full_seq");
 endfunction
    
 task main_phase(uvm_phase phase);
    void'(super.randomize());
   	phase.raise_objection(this);
    full_seq.start(env.fifo_agt.sqr);
 	  phase.drop_objection(this);

   `uvm_info(get_type_name(),"END OF TESTCASE", UVM_INFO);
 endtask


endclass
/*
Author:   Daniela Gomes Ramalho
Email:    danielagramalho16@gmail.com
Description: the scoreboard will check the correctness of the DUT 
by comparing the DUT output with the expected values
*/

class fifo_scoreboard#(parameter data_size=8) extends uvm_scoreboard;
  
  `uvm_component_param_utils(fifo_scoreboard#(.data_size(data_size)))
  
  // TLM analysis FIFO allows the storing of transactions instead of one-time-use 
  // and can be utilized at any place where a uvm_analysis_import is used, allowing
  // components with different data transfer rates to communicate effectively 
  // within a simulation environment; essentially acting as a buffer between
  // faster and slower components in a TLM design.  
  uvm_tlm_analysis_fifo#(fifo_seq_item #(.data_size(data_size))) in_transactions;
  uvm_tlm_analysis_fifo#(fifo_seq_item #(.data_size(data_size))) out_transactions;
  
  fifo_seq_item #(.data_size(data_size)) fifo_data_in;
  fifo_seq_item #(.data_size(data_size)) fifo_data_out;   
  
  fifo_seq_item #(.data_size(data_size)) fifo_data;   
                          
  fifo_seq_item #(.data_size(data_size)) model_data_in;     
  fifo_seq_item #(.data_size(data_size)) model_data_out;     
          
  fifo_ref_model#(.data_size(data_size))  ref_model;

  int mismatch, match;
                          
  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
    mismatch = 0;
    match = 0;
  endfunction: new
  
 
  function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
	  fifo_data_in  = fifo_seq_item #(.data_size(data_size))::type_id::create("fifo_data_in",this);
	  fifo_data_out = fifo_seq_item #(.data_size(data_size))::type_id::create("fifo_data_out",this);
    
	  model_data_in  = fifo_seq_item #(.data_size(data_size))::type_id::create("model_data_in",this);
    model_data_out = fifo_seq_item #(.data_size(data_size))::type_id::create("model_data_out",this);
    
    in_transactions  = new(.name("in_transactions"), .parent(this));
    out_transactions = new(.name("out_transactions"), .parent(this));
    
    ref_model = new(.name("ref_model"), .parent(this));
  endfunction: build_phase
    
  task reset_phase(uvm_phase phase);
     fifo_seq_item #(.data_size(data_size)) fifo_out;
     fifo_out = fifo_seq_item #(.data_size(data_size))::type_id::create("fifo_out",this);
     super.reset_phase(phase);
     phase.raise_objection(this);
     ref_model.reset(fifo_out); 
     model_data_out.data_out   = fifo_out.data_out;
     model_data_out.fifo_full  = fifo_out.fifo_full;
     model_data_out.fifo_empty = fifo_out.fifo_empty;
     phase.drop_objection(this);
  endtask
 
  task main_phase(uvm_phase phase);
    fifo_seq_item #(.data_size(data_size)) fifo_din;
    fifo_seq_item #(.data_size(data_size)) fifo_dout;
    
    fifo_din = fifo_seq_item #(.data_size(data_size))::type_id::create("fifo_din",this);
    fifo_dout = fifo_seq_item #(.data_size(data_size))::type_id::create("fifo_dout",this);
    
	  super.main_phase(phase);
    fork
      forever begin
        in_transactions.get(fifo_data_in);
        ref_model.check_fifo(fifo_data_in, fifo_dout);
        model_data_out.data_out   = fifo_dout.data_out;
        model_data_out.fifo_full  = fifo_dout.fifo_full;
        model_data_out.fifo_empty = fifo_dout.fifo_empty; 
      end    
      
      forever begin
        out_transactions.get(fifo_data_out);
        check_data(fifo_data_out, model_data_out);
      end 
      
    join 
      
  endtask

  function void check_data(fifo_seq_item #(.data_size(data_size)) rtl_data= null,
                           fifo_seq_item #(.data_size(data_size)) model_data= null);

      // Compare the rtl output with the model output
      if(rtl_data != null && model_data != null) begin
        if(!rtl_data.compare(model_data)) begin
          mismatch++;
        end else begin
          match++;
        end
      end    
      
  endfunction
           
  function void report_phase(uvm_phase phase);
    `uvm_info("fifo_scoreboard", $sformatf("FIFO matchs: %d", match), UVM_INFO)
    `uvm_info("fifo_scoreboard", $sformatf("FIFO missmatch: %d", mismatch), UVM_INFO)
  endfunction
           
           
endclass
                          

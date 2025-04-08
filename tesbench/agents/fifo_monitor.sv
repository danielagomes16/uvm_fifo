
/*
Author:   Daniela Gomes Ramalho
Email:    danielagramalho16@gmail.com
Description: Monitor samples the DUT signals through 
the virtual interface and converts the signal level 
activity to the transaction level.
*/

class fifo_monitor#(parameter data_size = 8)
  extends uvm_monitor;
  
  `uvm_component_param_utils(fifo_monitor#(.data_size(data_size)))
  
  // interface
  virtual fifo_if #(.data_size(data_size)) vif;
  
  uvm_analysis_port #(fifo_seq_item #(.data_size(data_size))) in_ap;
  uvm_analysis_port #(fifo_seq_item #(.data_size(data_size))) out_ap;  
  
  fifo_seq_item #(.data_size(data_size)) in_seq_item;
  fifo_seq_item #(.data_size(data_size)) out_seq_item;
  
  function new(string name = "fifo_monitor", uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    in_ap = new(.name("in_ap"), .parent(this));
    out_ap = new(.name("out_ap"), .parent(this));
  endfunction : build_phase
  
  task reset_phase(uvm_phase phase);
    in_seq_item  = fifo_seq_item #(.data_size(data_size))::type_id::create("in_seq_item");
    in_seq_item.data_in  = 0;
    in_seq_item.write_en = 0;
    in_seq_item.read_en  = 0;
    in_ap.write(in_seq_item);
    @(posedge vif.clock);
  endtask

  task main_phase(uvm_phase phase);
    in_seq_item  = fifo_seq_item #(.data_size(data_size))::type_id::create("in_seq_item");
    out_seq_item = fifo_seq_item #(.data_size(data_size))::type_id::create("out_seq_item");
    
    fork
      begin
        forever begin
          if (!vif.reset) begin
            in_seq_item.data_in  = vif.data_in;
            in_seq_item.write_en = vif.write_en;
            in_seq_item.read_en  = vif.read_en;
          end
          else begin
            in_seq_item.data_in  = 0;
            in_seq_item.write_en = 0;
            in_seq_item.read_en  = 0;
          end  
          // After sampling, by using the write method send the sampled transaction packet to the scoreboard
          in_ap.write(in_seq_item);
          @(posedge vif.clock);
        end  
      end
      
      begin
        forever begin
          if (!vif.reset) begin
            out_seq_item.data_out   = vif.data_out;
            out_seq_item.fifo_full  = vif.fifo_full;
            out_seq_item.fifo_empty = vif.fifo_empty;
          end
          else begin
            out_seq_item.data_out   = 0;
            out_seq_item.fifo_full  = 0;
            out_seq_item.fifo_empty = 1;
          end 
          // After sampling, by using the write method send the sampled transaction packet to the scoreboard
          out_ap.write(out_seq_item); 
          @(posedge vif.clock); 
        end 
      end

    join
  endtask

endclass
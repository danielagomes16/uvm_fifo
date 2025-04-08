/*
Author:   Daniela Gomes Ramalho
Email:    danielagramalho16@gmail.com
Description: driver receives the stimulus 
from sequence via sequencer and drives on 
interface signals.
*/

class fifo_driver#(parameter data_size = 8)
  extends uvm_driver#(fifo_seq_item #(.data_size(data_size)));
  
  `uvm_component_param_utils(fifo_driver#(.data_size(data_size)))
  
  // interface
  virtual fifo_if#(.data_size(data_size)) vif;
  
  // sequence item
  fifo_seq_item#(.data_size(data_size)) seq_item;
  
  function new(string name = "fifo_driver", uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase
 
  task reset_phase(uvm_phase phase);
    seq_item_port.get_next_item(seq_item);
    vif.driver_cb.data_in   <= '0;
    vif.driver_cb.write_en  <= '0;
    vif.driver_cb.read_en   <= '0;
    @(posedge vif.clock);
    seq_item_port.item_done();  
  endtask
 
 task reset_task;
    seq_item_port.try_next_item(seq_item);
    if(seq_item != null) begin
       vif.driver_cb.data_in     <= seq_item.data_in;
       vif.driver_cb.write_en    <= seq_item.write_en;
       vif.driver_cb.read_en     <= seq_item.read_en;
       seq_item_port.item_done();
    end
    @(posedge vif.clock);
  endtask : reset_task
   
  task main_phase(uvm_phase phase);
    forever begin
      if (vif.reset) begin
        seq_item_port.get_next_item(seq_item);
        fork 
          begin
          if (seq_item.write_en) begin
             vif.driver_cb.write_en <= 1; 
             vif.driver_cb.read_en  <= 0; 
      	     vif.driver_cb.data_in  <= seq_item.data_in;
          end  
        end
        begin
          if (seq_item.read_en) begin
      	     vif.driver_cb.read_en  <= 1;
             vif.driver_cb.write_en <= 0; 
             seq_item.data_out <= vif.driver_cb.data_out;
          end  
        end  
      join  
            
      seq_item_port.item_done();          
      @(posedge vif.clock);  
      end
      else begin
        reset_task();
    end
  end
  endtask

endclass
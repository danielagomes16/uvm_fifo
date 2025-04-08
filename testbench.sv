
/*
Author:   Daniela Gomes Ramalho
Email:    danielagramalho16@gmail.com
Description:
*/

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_interface.sv"
`include "fifo_pkg.sv"
import fifo_pkg::*;

parameter data_size = 'd8;

module tb;
 logic clock;
 logic reset;
 
 always #10 clock = ~clock;
  
 initial begin
   clock = 0;
   reset = 1;
   #40 reset = 0;
 end
  
  fifo_if#(.data_size(data_size)) vif(.clock(clock),.reset(reset)); 

  fifo DUT(
   .clock(vif.clock),
   .reset(vif.reset),
   .data_in(vif.data_in),
   .wr_enable(vif.write_en),
   .rd_enable(vif.read_en),
   .data_out(vif.data_out),
   .full(vif.fifo_full),
   .empty(vif.fifo_empty)
 );

 initial
 begin
   uvm_config_db #(virtual fifo_if#(.data_size(data_size)))::set(uvm_root::get(),"*","vif",vif);
   $dumpfile("dump.vcd");
   $dumpvars;
 end

 initial
 begin
   run_test();
 end

endmodule

/*
Author:   Daniela Gomes Ramalho
Email:    danielagramalho16@gmail.com
Description: An Interface is a way to encapsulate 
signals into a block.
*/

interface fifo_if #(parameter data_size = 8)
  (input logic clock, reset);
  // input signals
  logic [data_size-1:0] data_in;
  logic write_en;
  logic read_en;

  // output signals
  logic [data_size-1:0] data_out;
  logic fifo_full;
  logic fifo_empty;

  // driver clocking block
  clocking driver_cb @(posedge clock);
    // default input #[delay_or_edge] output #[delay_or_edge]
    // The delay_value represents a skew of how many time units 
    // away from the clock event a signal is to be sampled or driven.
    // An input skew of #1step indicates that the value read by the 
    // active edge of the clock is always the last value of the signal 
    // immediately before the corresponding clock edge. 
    // A step is the time precision.
    default input #1step output #0.1ns;
    // list of signals
    output data_in;
	  output write_en;
  	output read_en;
	  input  data_out;
  	input  fifo_full;
  	input  fifo_empty;
  endclocking
  
  // monitor clocking block
  clocking monitor_cb  @(posedge clock);
    // default input #[delay_or_edge] output #[delay_or_edge]
    // The delay_value represents a skew of how many time units 
    // away from the clock event a signal is to be sampled or driven.
    // An input skew of #1step indicates that the value read by the 
    // active edge of the clock is always the last value of the signal 
    // immediately before the corresponding clock edge. 
    // A step is the time precision.
    default input #1step output #0.1ns;
    // list of signals
    input data_in;
	  input write_en;
  	input read_en;
	  input data_out;
  	input fifo_full;
  	input fifo_empty;
  endclocking

  
endinterface
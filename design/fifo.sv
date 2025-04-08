/*
Author:   Daniela Gomes Ramalho
Email:    danielagramalho16@gmail.com
Description: agent configuration class
*/

// Code your design here
module fifo #(
  parameter DATA_SIZE = 8) (
  input [DATA_SIZE-1:0] data_in,
  input clock,
  input reset, 
  input wr_enable,
  input rd_enable,
  output reg [DATA_SIZE-1:0] data_out,
  output reg full,
  output reg empty
);
  
  reg [2:0] wptr, rptr;
  
  // FIFO buffer 
  reg [DATA_SIZE-1:0] memory [DATA_SIZE-1:0]; 
  reg [2:0] counter; 

 // Initialize FIFO memory and pointers
 always @(posedge clock) begin
 	if (reset) begin
 	  // Reset memory and pointers
 	  integer i;
      for (i = 0; i < DATA_SIZE; i = i + 1)
 	    memory[i] <= 0;
      data_out <= 0;
      counter <= 0;
 	    wptr <= 0;
      rptr <= 0;
 	end
 	else begin
      // Write operation
      if (wr_enable && !full) begin
        memory[wptr] <= data_in;
        wptr <= wptr + 1;
        counter <= counter + 1;
      end

      // Read operation
      if (rd_enable && !empty) begin
        data_out <= memory[rptr];
        rptr <= rptr + 1;
        counter <= counter - 1;
      end
    
    end
 end

 // FIFO full condition
  assign full = (counter == DATA_SIZE-1) ? 1 : 0;
 // FIFO empty condition
  assign empty = (counter == 0);
endmodule
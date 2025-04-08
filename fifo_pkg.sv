/*
Author:   Daniela Gomes Ramalho
Email:    danielagramalho16@gmail.com
Description:
*/

`timescale 1ns/1ps

import uvm_pkg::*;

package fifo_pkg;
`include "uvm_macros.svh"
`include "fifo_seq_item.sv"
`include "fifo_base_seq.sv"
`include "fifo_sequencer.sv"
`include "fifo_driver.sv"
`include "fifo_monitor.sv"
`include "fifo_agent_config.sv"
`include "fifo_agent.sv"
`include "fifo_ref_model.sv"
`include "fifo_scoreboard.sv"
`include "fifo_coverage.sv"
`include "fifo_env.sv"
`include "fifo_base_test.sv"
`include "fifo_full_seq.sv"
`include "fifo_full_test.sv"
endpackage
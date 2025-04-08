/*
Author:   Daniela Gomes Ramalho
Email:    danielagramalho16@gmail.com
Description:
*/

class fifo_coverage #(parameter data_size = 8) extends uvm_component;
  
    `uvm_component_param_utils(fifo_coverage#(.data_size(data_size)))

    uvm_tlm_analysis_fifo#(fifo_seq_item #(.data_size(data_size))) cov_in;
    uvm_tlm_analysis_fifo#(fifo_seq_item #(.data_size(data_size))) cov_out;
  
    fifo_seq_item #(.data_size(data_size)) seq_in;
    fifo_seq_item #(.data_size(data_size)) seq_out;

    covergroup in_rtl;
        option.per_instance = 1;
        
        coverpoint_data_in: coverpoint seq_in.data_in
        {
            bins data_zero = {8'h0};
            bins data_one  = {8'hff};
            bins data_random = {[8'h1:$]};
            // A single bin to store all other values that don't belong to any other bin
	        bins others = default;
        }

        coverpoint_write: coverpoint seq_in.write_en;

        coverpoint_read: coverpoint seq_in.read_en;
        
        data_in_wr: cross coverpoint_data_in,coverpoint_write;

        data_in_rd: cross coverpoint_data_in,coverpoint_read;

    endgroup

    covergroup out_rtl;
        option.per_instance = 1;
        coverpoint_o_data:  coverpoint seq_out.data_out
        {
            bins o_data_zero = {8'h0};
            bins o_data_one  = {8'hff};
            bins o_data_random = {[8'h1:$]};
            // A single bin to store all other values that don't belong to any other bin
            bins o_data_others = default;        
        }        

        coverpoint_fifo_full: coverpoint seq_out.fifo_full;

        coverpoint_fifo_empty: coverpoint seq_out.fifo_empty;
   
    endgroup

    function new(string name = "fifo_coverage", uvm_component parent=null);
        super.new(name, parent);
        in_rtl  = new();
        out_rtl = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        seq_in  = fifo_seq_item #(.data_size(data_size))::type_id::create("seq_in", this);
        seq_out = fifo_seq_item #(.data_size(data_size))::type_id::create("seq_out", this);

        cov_in  = new(.name("cov_in"), .parent(this));  
        cov_out = new(.name("cov_out"), .parent(this));
    endfunction

    task run_phase(uvm_phase phase);
        fork
          in_coverage();
          out_coverage();
        join_none
   endtask

    task in_coverage;
        forever begin
          cov_in.get(seq_in);
          in_rtl.sample();
        end
    endtask

    task out_coverage;
        forever begin
          cov_out.get(seq_out);
          out_rtl.sample();
        end
    endtask

endclass
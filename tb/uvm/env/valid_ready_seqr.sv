/// @file valid_ready_seqr.sv
/// @brief Valid-Ready sequencer 
/// @author Danil Zavarnitsyn

class valid_ready_seqr #(
        valid_ready_params_s PARAMS = DEFAULT_PARAMS
) extends uvm_sequencer#(valid_ready_item#(PARAMS));
    
    `uvm_component_param_utils(valid_ready_pkg::valid_ready_seqr#(PARAMS))
    
    //--------------------------------------------------------------------
    // Methods
    //--------------------------------------------------------------------
    
    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    
endclass : valid_ready_seqr


function new(string name, uvm_component parent)
    super.new(name, parent);
endfunction : new

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction : build_phase
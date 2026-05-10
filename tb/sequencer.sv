import uvm_pkg::*;
`include "uvm_macros.svh"
`include "config_macros.svh"

class base_sequencer #(
    parameter type PACKET_TYPE = base_packet
) extends uvm_sequencer #(PACKET_TYPE);

    `uvm_component_param_utils(base_sequencer#(PACKET_TYPE))

    function new(string name = `BASE_SEQUENCER_NAME, uvm_component parent);
        super.new(name, parent);
    endfunction: new

endclass: base_sequencer
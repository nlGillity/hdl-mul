import uvm_pkg::*;
`include "uvm_macros.svh"

class base_env extends uvm_env;

    master_agent master;
    slave_agent  slave;

    `uvm_component_utils(env)

    function new(string name = "base_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        master = master_agent::type_id::create("master", this);
        slave  = slave_agent::type_id::create("slave", this);

        `uvm_info(get_full_name(), "Build stage complete.", UVM_LOW);
    endfunction

endclass
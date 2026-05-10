import uvm_pkg::*;
`include "uvm_macros.svh"
`include "config_macros.svh"

class base_sequence #(
    parameter type PACKET_TYPE = base_packet
) extends uvm_sequence #(PACKET_TYPE);

    int unsigned max_delay;
    int unsigned min_delay;

    constraint delay_con { max_delay >= min_delay; }

    `uvm_object_param_utils(base_sequence#(PACKET_TYPE))

    function new(string name = `BASE_SEQUENCE_NAME);
        super.new(name);
    endfunction: new

    virtual task pre_body();
        if ( !uvm_config_db#(int unsigned)::get(m_sequencer, "", `MASTER_MIN_DELAY, min_delay) )
            `uvm_fatal("NOINT", { "min delay must be set for: ", get_full_name(), ".min_delay" })
        if ( !uvm_config_db#(int unsigned)::get(m_sequencer, "", `MASTER_MAX_DELAY, max_delay) )
            `uvm_fatal("NOINT", { "max delay must be set for: ", get_full_name(), ".max_delay" })
    endtask: pre_body

    virtual task body();
        req = PACKET_TYPE::type_id::create(`BASE_SEQ_PACKET_NAME);
        start_item(req);
        item_randomize(req);
        finish_item(req);
    endtask: body

    virtual task item_randomize(PACKET_TYPE item);
        sequence_a: assert (
            item.randomize() with {
                delay >= min_delay;
                delay <= max_delay;
            }
        ) else `uvm_error("RAND_ERR", $sformatf("Failed to randomize item '%s' for '%s'", item.get_name(), get_full_name()))
    endtask: item_randomize

endclass: base_sequence
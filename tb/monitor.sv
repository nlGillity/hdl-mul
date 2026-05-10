// import uvm_pkg::*;
// `include "uvm_macros.svh"

/*
    The MONITOR is responsible for extracting signal information from the bus
    and translating it into events, data and status information. The monitor
    should never rely on state information colleted by other components, such
    as a driver, but it may need to rely on request-specific id information
    in order to properly set the sequence and transaction id information for
    the response.

    The monitor functionality should be limited to basic monitoring that is
    always required. This can include protocol checking - which should be
    configurable so it can be enabled or disabled - and coverage collection.

    Example of monitor's functionality:
        * The monitor collects bus information through a virtual interface.
        * The collected data is used to coverage collection and checking.
        * The collected data is exported on an analysis port.
*/

// class monitor #(
//     parameter type PACKET_TYPE = packet_base
// ) extends uvm_monitor;

//     bit check_en    = 1;
//     bit coverage_en = 1;
//     uvm_analysis_port #(PACKET_TYPE) item_collected_port;
//     event cover_transaction;

//     protected PACKET_TYPE pkt_collected;

//     virtual mul_if vif;

//     `uvm_component_utils_begin(monitor)
//         `uvm_field_int(check_en, UVM_ALL_ON)
//         `uvm_field_int(coverage_en, UVM_ALL_ON)
//     `uvm_component_utils_end

//     covergroup cov_trans @cover_transaction
//         option.per_instance = 1
//         // TODO: ... 
//     endgroup

//     function new(string name, uvm_component parent)
//         super.new(name, parent);
//         cov_trans           = new();
//         pkt_collected       = new();
//         item_collected_port = new("item_collected_port", this);
//         cov_trans.set_inst_name({get_full_name(), ".cov_trans"});
//     endfunction


//     virtual task run_phase(uvm_phase phase)
//         forever begin
//             @(posedge vif.clk);
//             collect();
//         end
//     endtask

//     virtual protected task collect();
//         if (vif.down_vld && vif.down_ready) begin
//             pkt_collected.
//         end
//         if (check_en)    do_checking();
//         if (coverage_en) do_coverage(); item_collected_port.write()
//     endtask

//     virtual protected task do_checking();

//     endtask

//     virtual protected task do_coverage();
//     endtask
    
// endclass
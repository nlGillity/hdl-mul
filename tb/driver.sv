import uvm_pkg::*;
`include "uvm_macros.svh"
`include "config_macros.svh"

virtual class base_driver #(
    parameter type PACKET_TYPE = base_packet
) extends uvm_driver #(PACKET_TYPE);

    virtual mul_if vif;

    //=============================================================================
    // Pure Tasks
    //=============================================================================

    pure virtual task wait_response();   // wait for response from DUT
    pure virtual task drive_packet();    // drive sequence item to ports
    pure virtual task drive_reset();     // drive reset values to ports
    pure virtual task driving_routine(); // main driving loop

    //=============================================================================
    // Functions
    //=============================================================================

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if ( !uvm_config_db#(virtual mul_if)::get(this, "", `MUL_INTERFACE_NAME, vif) ) 
            `uvm_fatal("NOVIF", {
                "virtual interface must be set for: ", get_full_name(), ".vif"
            })
        `uvm_info(get_full_name(), "Build stage complete.", UVM_LOW);
    endfunction

    //=============================================================================
    // Tasks
    //=============================================================================

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.rstn);
            fork: driving_loop
                forever driving_routine();
            join_none
            @(negedge vif.rstn);
            disable driving_loop;
            reset();
        end
    endtask

    //-----------------------------------------------------------------------------

    // Reset handler
    virtual task reset();
        `uvm_info(get_type_name(), "Resetting signals.", UVM_LOW);
        drive_reset();
    endtask

    // Delay between transactions
    virtual task delay();
        repeat (req.delay) @(posedge vif.clk);
    endtask

endclass


class master_driver extends base_driver #(master_packet);

    `uvm_component_utils(master_driver)

    //=============================================================================
    // Functions
    //=============================================================================

    function new(string name = `MASTER_DRIVE_NAME, uvm_component parent);
        super.new(name, parent);    
    endfunction

    //=============================================================================
    // Tasks
    //=============================================================================

    virtual task driving_routine();
        seq_item_port.get_next_item(req);
        drive_packet();
        wait_response();
        drive_reset();
        seq_item_port.item_done(req);
        delay();
    endtask

    virtual task wait_response();
        do @(posedge vif.clk);
        while (!vif.up_ready);
    endtask

    virtual task drive_reset();
        vif.up_vld = 1'b0;
        vif.a      = '0;
        vif.b      = '0;
    endtask

    virtual task drive_packet();
        vif.up_vld = req.vld;
        vif.a      = req.a;
        vif.b      = req.b;
    endtask

endclass: master_driver


class slave_driver extends base_driver #(slave_packet);

    `uvm_component_utils(slave_driver)

    //=============================================================================
    // Functions
    //=============================================================================

    function new(string name = `SLAVE_DRIVE_NAME, uvm_component parent);
        super.new(name, parent);    
    endfunction
    
    //=============================================================================
    // Tasks
    //=============================================================================

    virtual task driving_routine();
        seq_item_port.get_next_item(req);
        drive_packet();
        @(posedge vif.clk);
        drive_reset();
        seq_item_port.item_done(req);
        delay();
    endtask

    virtual task wait_response();
        // no responses
    endtask

    virtual task drive_reset();
        vif.down_ready = 1'b0;
    endtask

    virtual task drive_packet();
        vif.down_ready = req.ready;
    endtask

endclass: slave_driver

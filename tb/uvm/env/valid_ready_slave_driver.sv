/// @file valid_ready_slave_driver.sv
/// @brief Valid-Ready master driver 
/// @author Danil Zavarnitsyn

class valid_ready_slave_driver #(
        valid_ready_params_s PARAMS = DEFAULT_PARAMS
) extends valid_ready_driver#(PARAMS);
    
    `uvm_component_param_utils(valid_ready_pkg::valid_ready_slave_driver#(PARAMS))
    
    //--------------------------------------------------------------------
    // Methods
    //--------------------------------------------------------------------
    
    extern function new(string name, uvm_component parent);
    extern protected virtual task reset_process();
    extern protected virtual task drive_process();
    
endclass : valid_ready_slave_driver


function valid_ready_slave_driver::new(string name, uvm_component parent)
    super.new(name, parent);
endfunction : new


task valid_ready_slave_driver::drive_process();
    item_t item;
    
    forever begin
        seq_item_port.get_next_item(item);
        
        @(posedge vif.clk);
        vif.ready <= item.ready;
        
        seq_item_port.item_done();
    end
endtask : drive_process


task valid_ready_slave_driver::reset_process();
    wait (!vif.rstn);
    vif.ready <= 0;
endtask : reset_process
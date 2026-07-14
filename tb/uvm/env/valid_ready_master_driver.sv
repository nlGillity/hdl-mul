/// @file valid_ready_master_driver.sv
/// @brief Valid-Ready master driver 
/// @author Danil Zavarnitsyn

class valid_ready_master_driver #(
        valid_ready_params_s PARAMS = DEFAULT_PARAMS
) extends valid_ready_driver#(valid_ready_item#(PARAMS));
    
    `uvm_component_param_utils(valid_ready_pkg::valid_ready_master_driver#(PARAMS))
    
    //--------------------------------------------------------------------
    // Type aliases
    //--------------------------------------------------------------------
    
    // Configurator type
    typedef valid_ready_agent_cfg#(PARAMS) config_t;
    // Item type
    typedef valid_ready_item#(PARAMS) item_t;
    // Interface type
    typedef valid_ready_if#(PARAMS).master interface_t;
    
    //--------------------------------------------------------------------
    // Properties
    //--------------------------------------------------------------------
    
    // Configurator
    config_t cfg;
    // Virtual valid-ready inteface
    virtual interface_t vif;
    
    //--------------------------------------------------------------------
    // Methods
    //--------------------------------------------------------------------
    
    extern function new(string name, uvm_component parent);
    extern protected virtual task reset_process();
    extern protected virtual task drive_process();
    
endclass : valid_ready_master_driver


function valid_ready_master_driver::new(string name, uvm_component parent)
    super.new(name, parent);
endfunction : new


task valid_ready_master_driver::drive_process();
    item_t item;
    
    forever begin
        seq_item_port.get_next_item(item);
        
        @(posedge vif.clk);
        vif.valid <= item.valid;
        foreach (vif.data[i])
            vif.data[i] <= item.data[i];
        
        do @(posedge vif.clk);
        while (!vif.ready);
        
        vif.valid <= 0;
        foreach (vif.data[i])
            vif.data[i] <= '0;
        
        seq_item_port.item_done();
    end
endtask : drive_process


task valid_ready_master_driver::reset_process();
    wait (!vif.rstn);
    @(posedge vif.clk);
    vif.valid <= 0;
    foreach (vif.data[i])
        vif.data[i] <= '0;
endtask : reset_process
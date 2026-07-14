/// @file valid_ready_agent_cfg.sv
/// @brief Valid-Ready agent configurator
/// @author Danil Zavarnitsyn

class valid_ready_agent_cfg #(
        valid_ready_params_s PARAMS = DEFAULT_PARAMS
) extends uvm_object;
    
    `uvm_object_param_utils(valid_ready_pkg::valid_ready_agent_cfg#(PARAMS))
    
    //--------------------------------------------------------------------
    // Type aliases
    //--------------------------------------------------------------------
    
    // Interface type
    typedef valid_ready_if#(PARAMS) interface_t;
    // Item type
    typedef valid_ready_item#(PARAMS) item_t;
    
    //--------------------------------------------------------------------
    // Data members
    //--------------------------------------------------------------------
    
    // Virtual inteface
    virtual interface_t vif;
    // Is the agent active or passive
    uvm_active_passive_enum active = UVM_ACTIVE;
    
    //--------------------------------------------------------------------
    // Methods
    //--------------------------------------------------------------------
    
    extern function new(string name = "agent_config");
    
endclass : valid_ready_agent_cfg


function valid_ready_agent_cfg::new(string name = "agent_config");
    super.new(name);
endfunction : new
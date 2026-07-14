/// @file valid_ready_env.sv
/// @brief Valid-Ready environment
/// @author Danil Zavarnitsyn

class valid_ready_env #(
        valid_ready_params_s PARAMS = DEFAULT_PARAMS
) extends uvm_env;
    
    `uvm_component_param_utils(valid_ready_pkg::valid_ready_env#(PARAMS))
    
    //--------------------------------------------------------------------
    // Type aliases
    //--------------------------------------------------------------------
    
    // Env configurator type
    typedef valid_ready_env_cfg#(PARAMS) env_cfg_t;
    // Agent configurator type
    typedef valid_ready_agent_cfg#(PARAMS) agent_cfg_t;
    // Item type
    typedef valid_ready_item#(PARAMS) item_t;
    // Agent type
    typedef valid_ready_agent#(PARAMS) agent_t;
    
    //--------------------------------------------------------------------
    // Properties
    //--------------------------------------------------------------------
    
    agent_t master;
    agent_t slave;
    
    //--------------------------------------------------------------------
    // Properties
    //--------------------------------------------------------------------
    
    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    
endclass : valid_ready_env
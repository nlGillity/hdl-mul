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
    
    // Configurator
    env_cfg_t cfg;
    // Master agent
    agent_t master;
    // Slave agent
    agent_t slave;
    
    //--------------------------------------------------------------------
    // Properties
    //--------------------------------------------------------------------
    
    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    
endclass : valid_ready_env


function valid_ready_env::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new


function valid_ready_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if (!uvm_config_db#(env_cfg_t)::get(this, "", "cfg", cfg))
        `uvm_fatal({get_full_name(), ".db_get_fail"}, "Cannot get configs.")
    
    set_inst_override_by_type(
            "master.driver",
            valid_ready_driver#(PARAMS)::get_type(),
            valid_ready_master_driver#(PARAMS)::get_type()
    );
    master = agent_t::type_id::create("master");
    
    set_inst_override_by_type(
            "slave.driver",
            valid_ready_driver#(PARAMS)::get_type(),
            valid_ready_slave_driver#(PARAMS)::get_type()
    );
    slave = agent_t::type_id::create("slave");
endfunction : build_phase
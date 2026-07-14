/// @file valid_ready_agent.sv
/// @brief Valid-Ready agent
/// @author Danil Zavarnitsyn

class valid_ready_agent #(
        valid_ready_params_s PARAMS = DEFAULT_PARAMS
) extends uvm_agent;
    
    `uvm_component_param_utils(valid_ready_pkg::valid_ready_agent#(PARAMS))
    
    //--------------------------------------------------------------------
    // Type aliases
    //--------------------------------------------------------------------
    
    // Transaction type
    typedef valid_ready_item#(PARAMS) item_t;
    // Configurator type
    typedef valid_ready_agent_cfg#(PARAMS) config_t;
    // Sequencer type
    typedef valid_ready_seqr#(PARAMS) sequencer_t;
    // Monitor type
    typedef valid_ready_monitor#(PARAMS) monitor_t;
    // Driver type
    typedef valid_ready_driver#(PARAMS) driver_t;
    
    //--------------------------------------------------------------------
    // Properties
    //--------------------------------------------------------------------
    
    // Configurator
    config_t cfg;
    // Sequencer
    sequencer_t sequencer;
    // Monitor
    protected monitor_t monitor;
    // Driver
    protected driver_t driver;
    
    // Analysis port for output transactions
    uvm_analysis_port#(item_t) ap;
    
    //--------------------------------------------------------------------
    // Methods
    //--------------------------------------------------------------------
    
    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    
endclass : valid_ready_agent


function valid_ready_agent::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new


function valid_ready_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if (!uvm_config_db#(config_t)::get(this, "", "cfg", cfg))
        `uvm_fatal({get_full_name(), ".db_get_fail"}, "Cannot get configs.")
    
    monitor = monitor_t::type_id::create("monitor", this);
    monitor.cfg = cfg;
    
    if (cfg.active == UVM_ACTIVE) begin
        sequencer = sequencer_t::type_id::create("sequencer", this);
        sequencer.cfg = cfg;
        
        driver = driver_t::type_id::create("driver", this);
        driver.cfg = cfg;
    end
    
    ap = new("analysis_port", this);
    if (ap == null)
        `uvm_fatal({get_name(), ".null_ptr"}, "Cannot create analysis_port.")
endfunction : build_phase


function void valid_ready_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    monitor.ap.connect(ap);
    if (cfg.active == UVM_ACTIVE)
        driver.seq_item_port.connect(sequencer.seq_item_export);
endfunction : connect_phase
/// @file valid_ready_driver.sv
/// @brief Valid-Ready master driver 
/// @author Danil Zavarnitsyn

virtual class valid_ready_driver #(
        valid_ready_params_s PARAMS = DEFAULT_PARAMS
) extends uvm_driver#(valid_ready_item#(PARAMS));
    
    `uvm_component_param_utils(valid_ready_pkg::valid_ready_driver#(PARAMS))
    
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
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    
    pure protected virtual task reset_process();
    pure protected virtual task drive_process();
    
endclass : valid_ready_driver


function valid_ready_driver::new(string name, uvm_component parent)
    super.new(name, parent);
endfunction : new


function void valid_ready_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if (!uvm_config_db#(config_t)::get(this, "", "cfg", cfg))
        `uvm_fatal({get_full_name(), ".db_get_fail"}, "Cannot get configs.")
    
    vif = cfg.vif;
endfunction : build_phase


task valid_ready_driver::run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
        process threads[$];
        
        @(posedge vif.rstn);
        `uvm_info({get_full_name(), ".reset_release"}, "Reset released", UVM_MEDIUM)
        
        fork begin : handle_reset
                threads.push_back(process::self());
                reset_process();
            end
            
            begin : drive_port
                threads.push_back(process::self());
                drive_process();
            end
        join_any
        
        foreach (threads[i]) begin
            if (threads[i].status() != process::FINISHED)
                threads[i].kill();
        end
    end
endtask : run_phase
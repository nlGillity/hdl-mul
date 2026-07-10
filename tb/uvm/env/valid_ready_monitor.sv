/// @file valid_ready_monitor.sv
/// @brief Valid-Ready monitor 
/// @author Danil Zavarnitsyn

class valid_ready_monitor #(
        valid_ready_params_s PARAMS = DEFAULT_PARAMS
) extends uvm_monitor;
    
    `uvm_component_param_utils(valid_ready_pkg::valid_ready_monitor#(PARAMS))
    
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
    // Analysis port for transactions
    uvm_analysis_port#(item_t) ap;
    
    //--------------------------------------------------------------------
    // Methods
    //--------------------------------------------------------------------
    
    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    
    extern protected virtual task reset_process();
    extern protected virtual task monitor_process();
    
endclass : valid_ready_monitor


function valid_ready_monitor::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new


function void valid_ready_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if (cfg == null)
        if (!uvm_config_db#(config_t)::get(this, "", "cfg", cfg))
            `uvm_fatal({get_full_name(), ".db_get_fail"}, "Cannot get configs.")
    
    vif = cfg.vif;
    
    ap = new("ap", this);
    if (ap == null)
        `uvm_fatal({get_name(), ".null_ptr"}, "Cannot create analysis_port.")
endfunction : build_phase


task valid_ready_monitor::run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
        process threads[$];
        
        wait (vif.rstn);
        `uvm_info({get_full_name(), ".reset_release"}, "Reset released", UVM_MEDIUM)
        
        fork
            begin : handle_reset
                threads.push_back(process::self());
                reset_process();
            end
            
            begin : monitor_port
                threads.push_back(process::self());
                monitor_process();
            end
        join_any
        
        foreach (threads[i]) begin
            if (threads[i].status() != process::FINISHED)
                threads[i].kill();
        end
    end
endtask : run_phase


task valid_ready_monitor::reset_process();
    wait (!vif.rstn);
    `uvm_info({get_full_name(), ".reset_assert"}, "Reset asserted", UVM_MEDIUM)
endtask : reset_process


task valid_ready_monitor::monitor_process();
    item_t item;
    
    forever begin
        @(posedge vif.clk);
        if (vif.is_handshake() && vif.rstn) begin
            item = item_t::type_id::create({get_full_name(), ".item"});
            
            item.valid = vif.valid;
            foreach (item.data[i])
                item.data[i] = vif.data[i];
            
            `uvm_info({get_full_name(), ".handshake"}, item.convert2string(), UVM_MEDIUM)
            
            ap.write(item);
        end
    end
endtask : monitor_process
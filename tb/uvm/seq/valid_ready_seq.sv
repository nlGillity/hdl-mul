/// @file valid_ready_seq.sv
/// @brief Valid-Ready sequence 
/// @author Danil Zavarnitsyn

class valid_ready_seq #(
        valid_ready_params_s PARAMS = DEFAULT_PARAMS
) extends uvm_sequence#(valid_ready_item#(PARAMS));
    
    `uvm_object_param_utils(valid_ready_pkg::valid_ready_seq#(PARAMS))
    
    //--------------------------------------------------------------------
    // Type aliases
    //--------------------------------------------------------------------
    
    typedef valid_ready_item#(PARAMS) item_t;
    
    //--------------------------------------------------------------------
    // Properties
    //--------------------------------------------------------------------
    
    // The number of transactions
    int unsigned item_num = 1;
    // The transaction number
    int unsigned item_id = 0;
    
    //--------------------------------------------------------------------
    // Methods
    //--------------------------------------------------------------------
    
    extern function new(string name);
    extern virtual task body();
    
endclass : valid_ready_seq


function valid_ready_seq::new(string name);
    super.new(name);
endfunction : new


task valid_ready_seq::body();
    item_t item;
    
    repeat (item_num) begin
        item = item_t::type_id::create($sformatf("item_%0d", item_id++));
        start_item(item);
        
        if (!item.randomize())
            `uvm_fatal({get_full_name(), ".rand_fail"}, "Randomization is failed!")
        
        `uvm_info({get_full_name(), ".start_item"}, item.convert2string(), UVM_HIGH)
        finish_item(item);
        `uvm_info({get_full_name(), ".finish_item"}, item.convert2string(), UVM_LOW)
    end
endtask : body
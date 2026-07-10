/// @file valid_ready_item_pkg.sv
/// @brief Valid-Ready item package
/// @author Danil Zavarnitsyn

package valid_ready_item_pkg;
    
    import uvm_pkg::*;
    
    typedef enum bit [2:0] {
        POS, // all positive values
        NEG, // all negative values
        ZERO, // all zeros
        NO_ZERO, // different values without zeros
        POS_ZERO, // positive values with zeros
        NEG_ZERO // negative values with zeros
    } data_kind_e;
    
    `include "valid_ready_item.sv"
    
endpackage
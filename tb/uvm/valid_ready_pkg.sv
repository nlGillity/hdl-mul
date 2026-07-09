/// @file valid_ready_pkg.sv
/// @brief Valid-Ready package
/// @author Danil Zavarnitsyn

`include "uvm_macros.svh"

package valid_ready_pkg;

    import uvm_pkg::*;

    // Structure with parameters
    typedef struct {
        int unsigned data_num;
        int unsigned data_width;
    } valid_ready_params_s;

    localparam valid_ready_params_s DEFAULT_PARAMS = '{
        data_num   : 1,
        data_width : 8
    };

endpackage: valid_ready_pkg
